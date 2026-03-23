Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B7D3AC0E3;
	Mon, 23 Mar 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274733; cv=none; b=oTHYJ/sRGmxEOi+zq7uF6D7VRP6Xi28BbpU+jIrGIWByfYuOYvkvgO2bOZc4PBKH2gOpFEbRcuunTubqoFZRqjSDI+F2dlLtcVhklFHcwwRbvKkkRFd5JOyOa16T/zKo9GakqfSPr6oLMtlk9vsPkkFsVEo8P3L7Hc/nhaurAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274733; c=relaxed/simple;
	bh=NpetuCB9j+cfFWDzaHAl2IfJOc54mh09On5c0to8n5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XiBsUeIo+KdTXjkMRX/njzQZbFSMbElz5+/359koUayL7PgO2Mm2YMyhgg3yyJHRJnjZJw14smbNH88sWnM0UO47IfbVZ9/d7HwAawFugWNTzAyeRHQfNpFIlo5+5XJkmACuRJEoKeX6mFUM3jHeO1S34LMkKOY1XFZH9TfS0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diLCeOFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diLCeOFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAAFC4CEF7;
	Mon, 23 Mar 2026 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274733;
	bh=NpetuCB9j+cfFWDzaHAl2IfJOc54mh09On5c0to8n5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diLCeOFXtVv9m/GE3tYoN4qEkx0q9O/gOBhIBDBooW7w8sL0oeDZcz6H06F+yvDI3
	 /u9XjmALeSIcL2dNgRYF2+gcRjJeLTP9oVBkXeyT94LmbY6NoBADKN2TMH3ZJ+z7I7
	 p78LWr3a/3r7VEMpyPj+awv+xEsYSQu/VVRSe3Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 092/212] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Mon, 23 Mar 2026 14:45:13 +0100
Message-ID: <20260323134506.683534494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -36,6 +36,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -190,6 +191,9 @@ int amdgpu_bo_create_list_entry_array(st
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);


