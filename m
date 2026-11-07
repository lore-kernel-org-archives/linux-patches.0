Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063269;
	b=GvKEFXloNk2knulHXtA9vFmypfz6+y4v8X4x5Viv2tIX1Jo7Mmk8zfbcl1LDmS2jCMdd
	 eC3+8UNE5koZPN9/oPWex/RC4/LuhlQyftvqrW0bLvivkhPZp0f9MzrkW7LP40Q0ieAtr
	 S6DNYc+Beckg8wnMPfdZvdHoJsx54NA3uvjyN4cWar1yAdbVDfl0nCRat7CpqluZ1RmUJ
	 Qdg5ODBRQwpR9z4P7kBxbB5C/yhixHjgy30Yawayi9npVSMwrQiFufK1A4GVuILilk4pI
	 2cvYNZo1EKh3OTGwW+b5Otw0ADtGYx6tbCfOuIhV85mhwvM2NIUHFXkwC7QzZ4KiZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bsL/ckJ85uZ4OW4uZLv6l/sIGgY5eOLA+eFYMICFBI=;
	b=D7n872+PY5vEbSQ4iDn+ZB0Gt/6nUdIspjNL5Vosd0Hh0u2bJLHsabCK1xhj7Lmz6xKk
	 hMvK4nocpaZ59xWw1B/hL+0i+SUOq8uQJU19sp96QDrTl/BaYqUaq5eHsd2ZtTngNx/pX
	 DdFQE4XtkZk7JvCyOtuHxsOYZ6f8Pnnl5hbxMLkqQ9jqWDEXBtWZE+Uw7NuhewHcdBsHo
	 hdIwscn1ZlrONkEu5wA1QUnlodDrGuLGLy3jBgE05F34JbWjd1dsEpvkGliKJk8y9dy0n
	 ffc1u1egwz7OvXvuzmN/RTii9sAGV9SY+61TAno2i4O5k/7tU3EVq+Cw2elNbiVqb8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwPxMw8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0992F606A331;
	Sat,  7 Nov 2026 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwPxMw8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D3F1F0089F;
	Sat,  7 Nov 2026 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063268;
	bh=1bsL/ckJ85uZ4OW4uZLv6l/sIGgY5eOLA+eFYMICFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwPxMw8p/8y7zDIZl8xtQVlnGIGbJJEFXTmeg2zkPpOz1yg0WPO4z/cf+ljaXTcR4
	 EtDLB+QgnDhq4B96XmW7wV9MO5i87C3zRKdU1vw83ZaoQDhCcmJHP4AMmks45QMYmO
	 7BfjhIpq32A8lGQl2E8Hy4Gpk84qVaiE55reTNbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 466/869] mailbox: mtk-cmdq: Fix runtime PM leak in cmdq_mbox_flush()
Date: Sat,  7 Nov 2026 08:52:28 -0500
Message-ID: <20261107134909.455259684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 18e3e979826795b62e8916743bec4de660e7cb22 ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented
even when it fails, but cmdq_mbox_flush() returns the error without
dropping it.  The same happens when the GCE thread does not drain in
time and the function bails out with -EFAULT.

Undo the reference on both error paths.

Fixes: b0524f7c9635 ("mailbox: mediatek: implement flush function")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index a1360b70b83fb..6e915ec5deaae 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -506,8 +506,10 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 	int ret;
 
 	ret = pm_runtime_get_sync(cmdq->mbox.dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(cmdq->mbox.dev);
 		return ret;
+	}
 
 	spin_lock_irqsave(&thread->chan->lock, flags);
 	if (list_empty(&thread->task_busy_list))
@@ -544,6 +546,9 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 		dev_err(cmdq->mbox.dev, "Fail to wait GCE thread 0x%x done\n",
 			(u32)(thread->base - cmdq->base));
 
+		pm_runtime_mark_last_busy(cmdq->mbox.dev);
+		pm_runtime_put_autosuspend(cmdq->mbox.dev);
+
 		return -EFAULT;
 	}
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-- 
2.53.0



