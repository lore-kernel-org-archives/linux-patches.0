Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036342;
	b=fvOPv8durmqkh04xupGVrN1nxOJxX4ZIkfArOIWzeW78Jr8hKXIPzEajRb8Q3GGGwATh
	 IcjEi6pLPk9nHMcbHT1MNarVXnwixRuIgpD8C3fjR9I1tkqRNC+xdjP0rTSEyzV0QlftJ
	 3Ww3v5iJ5DbNa4RZOazFk4ovkBmJMKuRXOqG6iaYu5WpHVJZ03oilQ5P+SgRVCxpWaO0i
	 r6oKXtqf8qpOCmRWXfGC9wUzch86ZvwmoKYJpsyOP0h/CyW9WcbNKI856maIIxFCOg0Tx
	 gql+2rYAmA89NIEkm/7eAVMqjhE7+QItc7146T0xDmzlAPqjE3YbaccGJrhxcGtNqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GVoqetpeypvqt6TSeM/K4XHP9QQT1IMm0AWRAWtimFY=;
	b=Yu+j00v8uuPxo1ZwJ4gQ4IwHyrnQiESYRT3j5IuRfebqhWcIrEzWlbIB4VGNgubOfL8K
	 bR2oQVIusRj21VSV2JY1g4/8gIjYzlUDTqJCha1BHblxiEAv+jY0s934N2Jni0CpieByW
	 7adRTZ8cjXsPR2vxXG6r+yzyRVCQ0X1gd0eWHYdQjOMGsqMkIrPOzgW1exBUsB/ibPZuT
	 XDNn+15aQPE3LeXdPNyqKIrxk75wusJKGs5cuca4nlvD5eFwOMv/CJjs+JvhROnFAYL+f
	 zBLEbhrse0DkjFj35NF2ZkCV4eqEu2jll0YFbAy2SFlEt+QDLx+6gQN+R2+j6lmRDWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POtDg4Cb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8AB606A320;
	Wed, 18 Nov 2026 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POtDg4Cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A261F000C5;
	Wed, 18 Nov 2026 21:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036342;
	bh=GVoqetpeypvqt6TSeM/K4XHP9QQT1IMm0AWRAWtimFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POtDg4CbN1ofdVeAiuY3vK6DYqApmevmTTGxLWUxPISWjKWjIX2OC+O5SZDIEr/XR
	 4KTduuMkTrfiFvyOGkJr8G0yw6wTOV5TrOz2mV0BDbINEc5+xQiK3W04ND3mMXvQoA
	 aCN4oZeYWzgpMyOuxSCWdRyev3piSPTUreB1fA5E=
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
Subject: [PATCH 6.6 1026/3318] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Wed, 18 Nov 2026 15:27:28 +0100
Message-ID: <20261118150350.664672043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 168c56a5e9086..cbeb4c4bd044c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3531,6 +3531,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
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



