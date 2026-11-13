Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585522;
	b=nyNH7sHqfN7rgwHVL+HZ3+2dOxznuvuGTSD/FLHrNqHtjNplc9NIC3Jf1bfdc5F8yrH7
	 vB9Hk0QcpUHIMS6vwvCxwdFfoe5+9/zyor60wfaEXupVsKCqF7E3rCgGOJyBGlpdWTkmO
	 vXqrCr7ZJAkefU1aqHxzQoYuqxqI8p8UV+FcAjlthjEosJYLznXMffDdsE13lIMsJKfS9
	 xWr+XRxlQBwojwzrk1HSQNK7IfgftmviMc/x1g1VIsG6jRHMTaU3j4o5wa2keOTaUVZQO
	 SsNV6S57gffFvJXPf/vY86BpfJgO2EWuiPx0hDbLKsgarQwn9Rao2RzQY7iucYQmDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZThaJ+WtdYT/+OAqdpoSgO7EPOMHK2dIXSVtAUNJgTQ=;
	b=IyVWiwnuWbAurZsIrMFiiqq/M1hBtoVDTyC7/x82t1sPRbkaNxo378uHOxUVgUS0g8e8
	 zd5ihevIdzCAPbMJn/MGte5/AYNKHqpuJ8iEA22YZMWSVJc2B8yqA4k9kgOwGraNvW/ob
	 ABesFQkK2K+yYWy0pK/EOlB0/vEUNcq6ItWsIjeNDnY2z/VlQVuJ5hCzgxWsV5Cl/y8V8
	 xS9AT/BgSuaFLYoY3fHpjPp3rcUnReEsdwEHTwdYZwJooxdKd7k8TS9M1HWDlxH6XtgoK
	 nE0YMxOxCUD3GzyMSAY7q6sGtsUcRlP/4f3+B11yyZaWVqgG6U867jEyzX57XhBlcaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKaqk3PS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A90D606EBBC;
	Fri, 13 Nov 2026 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKaqk3PS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA71F1F000C4;
	Fri, 13 Nov 2026 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585522;
	bh=ZThaJ+WtdYT/+OAqdpoSgO7EPOMHK2dIXSVtAUNJgTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKaqk3PS/xsq6ozTpC67yjPPgKTSus5/nirS52d2gbqw4DYfwpWVSRLmEi7SkPxcy
	 Z3lNvJJEl6G+G0CSQYEWYkvsE+Irt3t0IH5nOWr1ITHmyu1J5XBQOKHUEtVYerNK10
	 T3buQGm+e79nTuQlfTZTwZR/+5ivk7LCwTeWdLU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 165/507] vringh: bound top-level re-entry into indirect tables
Date: Fri, 13 Nov 2026 10:47:49 -0500
Message-ID: <20261113153800.080329315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit f898439ace7f89922e853b43bcbfcd26ea2e0a98 ]

In __vringh_iov(), the F_INDIRECT branch descends into the indirect
table and continues before the descriptor accounting runs. A top-level
indirect descriptor is therefore never charged to count. If such a
descriptor sets NEXT to point back at itself, returning from the
indirect table resumes at the same top-level descriptor, which is again
not counted, so the walk never makes forward progress.

Because count stays flat and indirect_count is reset to 0 on every
return to the top-level table, neither bound in the loop check trips.
A guest can spin the vringh worker at 100% CPU inside __vringh_iov(),
an uninterruptible host DoS.

Move the descriptor accounting above the indirect switch so that a
top-level indirect descriptor is charged one top-level traversal step
before the walk descends into its table, bringing this re-entry under
the existing vrh->vring.num bound. Each top-level descriptor is still
charged at most one step and indirect_count still bounds a single
table, so legitimate chains (including the multiple-indirect case in
tools/virtio/vringh_test.c) stay within vring.num, while a cyclic
indirect descriptor is now rejected with -ELOOP.

Fixes: dbd29e075228 ("vringh: Fix loop descriptors check in the indirect cases")
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922122955.69433-2-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 9066f9f12ba13..f672e1115d13c 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -333,6 +333,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		if (unlikely(err))
 			goto fail;
 
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
+			vringh_bad("Descriptor loop in %p", descs);
+			err = -ELOOP;
+			goto fail;
+		}
+
 		if (unlikely(desc.flags &
 			     cpu_to_vringh16(vrh, VRING_DESC_F_INDIRECT))) {
 			u64 a = vringh64_to_cpu(vrh, desc.addr);
@@ -358,17 +369,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (up_next == -1)
-			count++;
-		else
-			indirect_count++;
-
-		if (count > vrh->vring.num || indirect_count > desc_max) {
-			vringh_bad("Descriptor loop in %p", descs);
-			err = -ELOOP;
-			goto fail;
-		}
-
 		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_WRITE))
 			iov = wiov;
 		else {
-- 
2.53.0



