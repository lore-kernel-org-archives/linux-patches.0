Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D79C329C6D;
	Sat, 30 May 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163951; cv=none; b=MQKb0jaVaQ013pEfhQfMqogQeneSo2//RMmuXaAK9V2dOt45GHqWv19YtA2JZrghy9ovCFqRK8XZ3o14kye7ZFvSuBcsiz9rr7QkmRF1WSWftSF/wOinr6R9Z9LB546tsNcIaa/wPFoHBGwjatXJGcX70HoM7X1SSOID0dSA32k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163951; c=relaxed/simple;
	bh=bmJglTggB79cwWSRCvFN4Y1jrc0remEl++Ei1a4lNkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAiOrFxZ8FTG/TGC4Uir0TGPSwVBadumtZWJNpkB3V/1P7ZIHpevm1YRR5GpeuRkA904sFVGbNu8EqqyM0LHQh3hDCsHLr5SOR/yMx3cIFv0s0WFm+wmC/Bno+KNq9TvIkW2lPFztdIaSVaHna0s07npRHIJ/9yR9wxldMcTT7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4uIlMcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4uIlMcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12DC1F00893;
	Sat, 30 May 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163950;
	bh=jF8qOS3ENNPvlGKDLz+x4/r2zZtWWuqJU8AuGXngiLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4uIlMcCRanezf0gk7wNMIEt3Y1RPEylo2X6QZkI3WKKPcafcyPKPaEfYfDuGPzRM
	 2ZMS7O1SFwlS6VTdAMrMy1MKdWj+ipt8vMYGBWHBP8U6x95Hf56F/sREGJaxu+NoEn
	 odD+dIQwMb2FtzcWk8jU/GP2E+4APYhNYZC/PUsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Frederick Lawler <fred@cloudflare.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/776] bpf-lsm: Make bpf_lsm_userns_create() sleepable
Date: Sat, 30 May 2026 18:02:04 +0200
Message-ID: <20260530160251.086967557@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederick Lawler <fred@cloudflare.com>

[ Upstream commit 401e64b3a4af4c7a2f6a00337232a3cf0bb757ed ]

Users may want to audit calls to security_create_user_ns() and access
user space memory. Also create_user_ns() runs without
pagefault_disabled(). Therefore, make bpf_lsm_userns_create() sleepable
for mandatory access control policies.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Acked-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: beaf0e96b1da ("bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 06062370c3b81..c9e785ab62cf0 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -212,6 +212,7 @@ BTF_ID(func, bpf_lsm_task_getsecid_obj)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_task_to_inode)
+BTF_ID(func, bpf_lsm_userns_create)
 BTF_SET_END(sleepable_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.53.0



