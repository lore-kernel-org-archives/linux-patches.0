Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FB36D4E1;
	Wed, 30 Sep 2026 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791631; cv=none; b=XkJ4x0SppqFXm3NolGU3BysrlsT1wH+tcO52D/LjbyUVivypfcooWB9NBMf9mffBRh6KFMmA7e/LEODeS6o9HT0SH2iBtgPznVcFyw8ifdv+ENNZpyV7shx+dyXj8wmo78fUheuFIJhZpZAs9z9zac8gaTP/PDEUdGZtQbGLXgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791631; c=relaxed/simple;
	bh=9PtbVljgOO+jyYi7w5Z+g+OGZ+JMFCfr24+ZwNFVnUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyf08hreVNct8JcUWLt/hZRJfdGDRJofaUb/pQQAZKk+dySVRaIztcTqXpfkQWHezralNA4RZ5NjnQb+OQvdG4mr5y+UivdVCeg0/E9sREBhStpFivWa+FluiazaEz+asvV2xE3T92r8V9W2rmac1pd1ZnyTiIORGT4BIAqIXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQcKe4/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQcKe4/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0A1F000FF;
	Wed, 30 Sep 2026 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791630;
	bh=ZG175XpEsGfRlMKxhZWPUn90UHHbJwl+KWYsGZiHFtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQcKe4/XnlkobEUPiItjS/UdKGh7myLI4iP6P2VxbZLEoVR20TxTaj/pXWeKqcSUX
	 FfkoBOwKWSUS7vdMgGRAjXFXCZKChDxFxV09xLyOyG7f1iggex8Rm8eIsk5+FffUTQ
	 xC5XuiniOFHbu3EtC2F2lr9+X+SjjtAY0QUPbcpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/752] netfilter: nfnetlink_log: cope with concurrent instance destruction
Date: Wed, 30 Sep 2026 17:23:15 +0200
Message-ID: <20260930152405.329123960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 387d744fa7e499d2c3748a4e60e02ebb24e7fb16 ]

Instances are refcounted. However, only memory release happens on the
1 -> 0 transition; the unlink from hashes can occur with any refcount.

Uncooperative userspace can force a situation where a queue is pending
for destruction from netlink event while a different socket with same
portid processes an UNBIND request.

With right timing, this will unhash the instance again:

Oops: general protection fault, [..]
Call Trace:
 <TASK>
 nfulnl_recv_config+0x31a/0xd50
 nfnetlink_rcv_msg+0x7c2/0xeb0

Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7ad0cf0cb6935..c39d016619f4b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -217,13 +217,18 @@ static void __nfulnl_flush(struct nfulnl_instance *inst);
 static void
 __instance_destroy(struct nfulnl_instance *inst)
 {
+	spin_lock(&inst->lock);
+	if (inst->copy_mode == NFULNL_COPY_DISABLED) {
+		/* attempt to UNBIND a queue already pending
+		 * destruction via netlink close event. Ignore.
+		 */
+		spin_unlock(&inst->lock);
+		return;
+	}
+
 	/* first pull it out of the global list */
 	hlist_del_rcu(&inst->hlist);
 
-	/* then flush all pending packets from skb */
-
-	spin_lock(&inst->lock);
-
 	/* lockless readers wont be able to use us */
 	inst->copy_mode = NFULNL_COPY_DISABLED;
 
-- 
2.53.0



