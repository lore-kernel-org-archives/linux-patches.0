Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210102;
	b=BLUQZQQB/NP5SUJSD3j2VvzIArqoHOlpOkO2RPnARFg0isnNcioi8VDAVvxtJ23adjXC
	 dPc+X+VZMmcKzwjOahSOnkQOfABO8Ehh+3WfJNMvUKGUuiW3Hxu3OptRKRN4OJC7ZeQLo
	 pMtl9zk32/p2EYPt3C9U6o69r4dLCS4olIqtovZWc/PkY4EKIVVmLHUq7jYghxN7gjL/Q
	 9RY4V6ahbKt1dq+5qwvFjyDyarOzaHa/Rcphyx9cj8v4YDzbE9CNxmm5AbO9eaYISUCZl
	 I9RcsQH8uZ3wpMasnHlq+GyVZOifFm5LD2ATg2iS7uaPmvXtYGvnYMB5PZJm3nPVZ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ix5qKRpS47xNU5dLszbh5fMDUvF0T0Ms7zywr+w/IAA=;
	b=hBpX9rZRWnALdI3kwCEGAdKUDVfulfQKVV/p77aCFtnnWd6g6sO54wBASGP89FdvGDiF
	 Gvu4IIDYUdMQKND+lquUlgCN0ZI6YzQLnDc/CZssnb/qZBDc8178Lmpw1uSoc85FaQQSJ
	 tg4oH3OsCACJZYeQEbtHWZ7LDe/owCaMcrIi6dC2kjsvww7Lq7zup7GRcRg7sjk/Qz9wN
	 oIoi976ufGNZENL2aFuodTVr1u0gyQj262TolpL1TpM8JcBvvrMzQAZDbTNL8LUwIm80C
	 +hgIr9g768YrmhUxyZf0shalVnGSO8a6diPBYY8qlZUNdPTU4iT5tWZydWh0hVICR0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rN0qzjeW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9DC606A31C;
	Wed, 28 Oct 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rN0qzjeW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF911F01825;
	Wed, 28 Oct 2026 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210102;
	bh=ix5qKRpS47xNU5dLszbh5fMDUvF0T0Ms7zywr+w/IAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rN0qzjeWnRvRY/qwrM8t/J6F0aB4InNVbAprAobwvoGqxR3pxd3N0uPD162b8LlFv
	 mM74mFyQL7fzAAkIUXLISW2BWsgin4MWTCbd5uNRuz0FdLwOk8pw7t9RfHYBoVs6v8
	 er5E/LWUqwjq9aM0xzaaS6X7h0x5UxIaHtRtm3qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 077/168] s390/ctcm: Prevent XID null dereference
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028165944.907406753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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


