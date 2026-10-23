Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774923;
	b=Yf/dV1a9Vx900hTkLxDorc61GaBGyLxbRG6zemgCYnSTylMHjZ7mFnmWvu1XWpRPHWS/
	 acjTxj+Plq62rOMcR38nGwzBuG4aOF3v4wU9YEYE9hDzgVloLDI5UAP/XSVvcF4UFtwDD
	 5+MIO6OzURiH1LhvdB09F8qlizEIzu92b9DVNNqRer3n8U4ajb9+YSD6JMkTYejsp2y2+
	 Wt90yQr42g5a3QqDCEQxr2ZpHXPwLp5HQ2FCIcyrpNFNgN6WxJQvsfT9Qzdz8rLGc5nEH
	 ETFJ96LVT5JqJc6YBC3pCkebO1xRK8acwku0APmpmR9CrKF8pyZ9+rxqu0S8QNNoNCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEaviQyeFwc3quooAxZi8PG+Mtd7oToqW13khGrlnzU=;
	b=bJOxLPA4NLYcNgvkyljgHmDJVBnSBTdYoKZG6twb0YkbW6YIIL8NqGzz1wDfnYqtgN+x
	 lGcMdGH3Pd+px50jgMsgRxPrPRUrL0Uohnn7KY0b9BErg4uFhJs//BqutdgoYCoxC6ezG
	 bs2A7icTkZ+E/69GwTnhdgOC924nugJitW/72IpgpU+isDz4oVkOboSIhBqEolXrQfLje
	 D7/vptKryN3uHALNyKZl2eUAp1Z1tO048yEohIWrtY54mesYVqskpp53QzcSEn762VatA
	 iQApxXVLVkWOapdBGe1dCKUcHLESf1U/Qphg7aAf2YBKD4EPdihwwWIlenzt/MZDU8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOb5sHzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5646A606A31E;
	Fri, 23 Oct 2026 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOb5sHzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A08A1F01825;
	Fri, 23 Oct 2026 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774923;
	bh=qEaviQyeFwc3quooAxZi8PG+Mtd7oToqW13khGrlnzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOb5sHzvrEmrkFaAY2QabFqz99Efqk0CPPuaB+BNq6nymt561RMpDXo7MiMZpPW6t
	 xXSfHPh9J8xtYiCUO1Y9Hm3j08nBDdMU6OdUdnYkZ1GPO434AB+Jmo/gtozQ9IZFn9
	 CyU85s7p5bBB9tofGF+O8wxkW92HRuEByYfmF7J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 202/242] s390/ctcm: Prevent XID null dereference
Date: Fri, 23 Oct 2026 18:40:44 +0200
Message-ID: <20261023163718.570883738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aswin Karuvally <aswin@linux.ibm.com>

commit b264d8422779d69febce914efc47a92a85cc382c upstream.

The mpc_validate_xid() function sets grp->saved_xid2->xid2_flag2 to 0x40
to signal XID validation error. If peer XID is NULL or r/w channel
pairing mismatch happens, grp->saved_xid2 is never initialized. An
attempt to set the flag in such case leads to NULL dereference.

Fix this by using the always available priv->xid->xid2_flag2 instead of
grp->saved_xid2->xid2_flag2 for validation errors.

Fixes: 293d984f0e36 ("ctcm: infrastructure for replaced ctc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Aswin Karuvally <aswin@linux.ibm.com>
Link: https://patch.msgid.link/20260827063408.2168914-1-aswin@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/ctcm_mpc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -826,7 +826,7 @@ static void mpc_action_go_ready(fsm_inst
 
 	fsm_deltimer(&grp->timer);
 
-	if (grp->saved_xid2->xid2_flag2 == 0x40) {
+	if (priv->xid->xid2_flag2 == 0x40) {
 		priv->xid->xid2_flag2 = 0x00;
 		if (grp->estconnfunc) {
 			grp->estconnfunc(grp->port_num, 1,
@@ -1636,7 +1636,6 @@ done:
 			"The XID used in the MPC protocol is not valid, "
 			"rc = %d\n", rc);
 		priv->xid->xid2_flag2 = 0x40;
-		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
 
 	return rc;


