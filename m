Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF43242BE;
	Sat, 30 May 2026 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159826; cv=none; b=IK2TRoRQLuHHBvMYCo21aJZ+Dw89SAgD+at+4wsqYMVDWRgZJQNRbj5Hx6aO9cAUwhbHh9gn9EgRUFsvk9oQX66O+WutegZP5c1IA78abPdJ32ieoDK16duoORku5QnTpeo6kK50zcrVzUAZds14BlLlPrFMUBQcK+DtACkIFWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159826; c=relaxed/simple;
	bh=/GRKj51rNMOgO3jfSHmfkSvpYNpCX2QW1y96SrQSrqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VheXYdhNoYG8KDb+r9SaJ6a6hVmc8KXG1YyTSpFp3hk9wpp4LIax9K9ciYt4x6JZPQ/dkhKbiCfLe7cxaj5yn/yBmuExmViFOtKydSqCyAOddKPXPmC++0281sV5YA/pINDkc/xHoUQO5aM41+ef2pKhXQvHJMbmdBykOimX3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5NBO+yQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5NBO+yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15151F00893;
	Sat, 30 May 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159824;
	bh=bbnh01wP4j1RmGMpi1o7nleMHUgkPo0uHwiR01sm2j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5NBO+yQLpv/0YH9GpOb1arQmQZTz6iUEgD19+nwh7bGzUsQPpAcjwlQRR8M9Vg2Q
	 QmMV8Ix1F7SU/LOzLf6KI3O+SE5kdNAICZfxy6CK3PhDnwy8tYtvQhmt+ykJtoZhRS
	 sFlx+WzY/PA8JNuqYFu0ouwIHkhPLD6Yl4wBmYUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Fang Wang <32840572@qq.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/969] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Sat, 30 May 2026 17:54:56 +0200
Message-ID: <20260530160305.253364142@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd ]

Userspace can pass an arbitrary number of BO list entries via the
bo_number field. Although the previous multiplication overflow check
prevents out-of-bounds allocation, a large number of entries could still
cause excessive memory allocation (up to potentially gigabytes) and
unnecessarily long list processing times.

Introduce a hard limit of 128k entries per BO list, which is more than
sufficient for any realistic use case (e.g., a single list containing all
buffers in a large scene). This prevents memory exhaustion attacks and
ensures predictable performance.

Return -EINVAL if the requested entry count exceeds the limit

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 688b87d39e0aa8135105b40dc167d74b5ada5332)
Cc: stable@vger.kernel.org
Signed-off-by: Fang Wang <32840572@qq.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 79e43896edddb..28a5b54a3aae1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -35,6 +35,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -232,6 +233,9 @@ int amdgpu_bo_create_list_entry_array(struct drm_amdgpu_bo_list_in *in,
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);
-- 
2.53.0



