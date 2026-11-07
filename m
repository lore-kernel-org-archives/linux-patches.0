Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062225;
	b=b7Ise34uc7uQgJNjdaMngUmEFxuDfARf4PJUY8mdWt0SlaCjrX+M+7nwHGL9L+JJ/GGL
	 Y0uZINAFnvBMfArXjTl8ItFYfFq89OCLc5+clkGtnRDpsZe7SKn7qfOVoRgC2trAjslK/
	 RBirav8sSnESH91z5whDNcBeQUdm1FrUwoI0dNwShRp+8+29BLQXNPCET/D5WuUef1/zW
	 QQlR5Lq32HfDcQQg7Fdgw6oGBeZRwK7QLGrmGpY695EyvGsQIZw5/3wqmfZ/CxI6AVPOd
	 jwh1/iv4QTSbCJdmDSSi8D0a/7tYBl6AFzoH5feBrZwbo2xUyWWxjvQdBV37Mq04ysA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6DQ7OfR8INOV6bYMDx4tyCj1E1nQdiJoOOQpKcdmktQ=;
	b=1La4+nGK4X3AXnLaD1LfwRDCmbCY2ev7dThi/g9ROqBj13JMxFp78lF4mP+kqtoUhmRQ
	 +EUC4+XLVz8OzXJw0ZXW/tu71HMcTtNDTMZWkV+c0l0oQxADUFKvea6epQAXWD+R+MsAd
	 vUjcRvYDGzUKbOmcZBfDrcRbMxG83Ul/2yi+Rh6IELPOH4bChe9/c3Es18nTmbgPh1vLP
	 TuInkhClltPjHV2biDlqKeN8fKkfvwGNxIFhMTlwgA9AeNahma/EH1VDx49zm9pcV32ya
	 gYd1JPJKXMLnYgM9Q1v5qvMqVKcMwMLKolwAAGzKgceaVnd+zhxN+WhcGhPaiVST1Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcmDkV3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E31606D83C;
	Sat,  7 Nov 2026 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcmDkV3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC051F008A5;
	Sat,  7 Nov 2026 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062225;
	bh=6DQ7OfR8INOV6bYMDx4tyCj1E1nQdiJoOOQpKcdmktQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcmDkV3ImmItLnBN/E4Jwm0cwxjBwDHhX61BCrF61GC61lUzW1NaBZUs22Ksb9Py8
	 RSTE3QGFiauxSjFFETyjCtt6Mw52sZROYYtMk7mjiIH3v0/M9w6t+6BVLnv/UY3Szh
	 hC1pux9KPXUBWqNI8j/ELK/fLZeEKYWh2C4tBuSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ZW Tang <tangzw515@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1177/1536] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Sat,  7 Nov 2026 08:53:13 -0500
Message-ID: <20261107135030.799481379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6a3ed6b290513859bd27d9fcb67739347d6315fa ]

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before commit
550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb locks
and takes the never initialized l_lock in ocfs2_mark_lockres_freeing().
With lockdep enabled this triggers:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock resources
without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never touched.

Link: https://lore.kernel.org/20260903104744.2164235-1-joseph.qi@linux.alibaba.com
Fixes: 550842cc6098 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 84f481cf2ae7c..ec44ed33afdf4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3528,6 +3528,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
-- 
2.53.0



