Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774268;
	b=n936XL9lwP8lmhkur7xB5JxKMI4yZ86K7N84d/wTQgr3bh9DB2zLgRMKiHHKfgmQZUjU
	 BoncU8ww+h/iidyS3WkC0wrryYvFMOokNmABT2DL6bxJ5koXWOon0+5wXQQMRJP9OwCZz
	 91K2lrDEpr9jb7+6d0B8XDqI55cZ4fv5E5X2pVfyosagkveYktYuWuwJ++pFi4l6wFEIO
	 OahhkXLcJVhG/xgUDsIuPZSVoZjDzMO6zuoOwGlkYQE8xlvaoXbqpbYhST3zuvAHo+8f0
	 lCbOGqcNpl9Z/BNEpcAZ1EPkNUSJiT8iVMZSAzbuEi8utJuJ9yKKg7AQTdyIx8ecchg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yxN4heFFK0dHkPTfyYHikIG1D8uHn7AIdaCXgjaHZPY=;
	b=Va5Yk6+yPiRRJF6G7H3UYuvNk6hsM5uSNZVZzPnqpxXiQVnUz0Ga3GqC3fjFtwXKrUdW
	 wcVS7Pkt3tCDC8i60NsOLFqlee85ziOZhiTp3r8ZrYlLBkEdyjNmbDeId0RFhUA/VehRo
	 lDrf7dAn0hkvHUpg/7zkzD7aiCvV2KMjvU6SRTEDSxAiedqGq1o96Ww8yI54fh6Tenwe+
	 vZ7jdDnVGB3X3uuZG5fdjROrJ/QzF5cjqzVn6UfzRBQ4QZTvSV3Qxhb1fuNuatdBtINQx
	 exC9TmVz0n0h8A1lC2tvZM09Q3/XsRbVLcrwAfFR3FbTeywnDkZl/kDCDlaU9jL8k/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dl+hrW5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBFD606A31A;
	Fri, 23 Oct 2026 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dl+hrW5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2491F01825;
	Fri, 23 Oct 2026 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774267;
	bh=yxN4heFFK0dHkPTfyYHikIG1D8uHn7AIdaCXgjaHZPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dl+hrW5pTyA9E7LqUT2YL4Ex5l4K+4/OvaPYWYAJHhclx6HTkZHtUjE9rx6zb2hiU
	 7AueEMzhY03xUNhx0y9qywHi1R++pO8uYNHds8nhlYsCDdrDNlIpWOzm4vMznempht
	 Y4XG1iFVY75NdALQpmtRxCC1sqBN9uRJAJhpLyf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 139/193] s390/ctcm: Prevent XID null dereference
Date: Fri, 23 Oct 2026 18:36:56 +0200
Message-ID: <20261023163717.495796608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -827,7 +827,7 @@ static void mpc_action_go_ready(fsm_inst
 
 	fsm_deltimer(&grp->timer);
 
-	if (grp->saved_xid2->xid2_flag2 == 0x40) {
+	if (priv->xid->xid2_flag2 == 0x40) {
 		priv->xid->xid2_flag2 = 0x00;
 		if (grp->estconnfunc) {
 			grp->estconnfunc(grp->port_num, 1,
@@ -1637,7 +1637,6 @@ done:
 			"The XID used in the MPC protocol is not valid, "
 			"rc = %d\n", rc);
 		priv->xid->xid2_flag2 = 0x40;
-		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
 
 	return rc;


