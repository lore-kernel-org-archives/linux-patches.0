Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207713;
	b=zfi0uUNK3w71VQIiLTekhiyM4dOwkViEKIK4nkjdpTfonAAyAarPgFNGmUd9cWZb/+tv
	 twrRKcFeJGy8HXoocqtV3wNHz7T5tDbEIv/mat0NAPGGYQ4UGhyWwRZWBfK266wQDbvkk
	 Aai9UD1iEdrA7OoyknVreDgArOEffAsqE535j+WyJnA4dx7OYDhyQwcArtlVe9F9YOvBG
	 zvzucs0gW6pUfDx1CnKXje3EgHGtODr1+xlBAS/hAvfTiSyjXI0Ax+YQElm8xJBWIZjg4
	 wPanVyGbBNhAiurdxmHw49ONvNUzenJ6swqW8eQ38/4ytllndxugtmcaW+EKafyL3Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnKoXyGVxrc5j/gzGxnniyUSHk5VwAV1BBI2yVbBQSA=;
	b=a6D9ghMoj55sitjgONdLG7xvp2S5z4oHg5NKO0DcDMhNsysreOWbm0ApIzWOyPJpLGz8
	 4Kexzc9D+wwHYFKBpXn+aKtGlbdcUryVv1wS6tRp0E1gIsHCyH8IAeD79+6kcczB5gWZE
	 1GxdiISacj722LjHh5+Af7k4HTt7zT+96TE2KZFoNkTA8f3cK28qbrBGRi1PglWP3/PpA
	 a61jTivlnS0e4poMzPUm8OYpd018kQdWcLtDT9shlQjSwzTa1lPOD5UL/LhVZTq6cuKWo
	 h3BY/BUzL2aQSvukOn8PNI5Lr3McPwgGe800406SP50NcNhS6sYX83AMz0SSJU9AnhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z7/UjCp0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DAE606A335;
	Wed, 28 Oct 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7/UjCp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FDF1F031E8;
	Wed, 28 Oct 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207713;
	bh=lnKoXyGVxrc5j/gzGxnniyUSHk5VwAV1BBI2yVbBQSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7/UjCp0mXBgGGJCdmxVW13UZylVQybZrZpM/V6H3SnpeXHAZjcloyUQktnGqtugb
	 p1U7JaUeELhCrMJgAK0/xgUcNgwhdcTkxiykbfHnTzdRzU/zjLFd/sGjpazLfTmhmX
	 2Aab4z4L/ORhhEJbCgwccDnURxicKo6wXpXmqseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 112/247] s390/ctcm: Prevent XID null dereference
Date: Wed, 28 Oct 2026 17:58:35 +0100
Message-ID: <20261028165950.051545834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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


