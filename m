Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217029;
	b=fes1+xoRGp3jzfulrmTPLk/RZBZe/7X379SYnPX299+RL4n/hwhicC4ro5kjQJZbIGvf
	 ZH9TfSd8+ApwlJBux/QEWAJa5wuxa+iaoZggFe+nvne/zZj/4N2arsmesodJZkzSL8ecl
	 3YS8hQUZXG2tDFbRI6aOZUs7QwGCuhrCIut25lUjKDPSCj876ARdfmjVGhnb1gCeMlsV2
	 8whgrZEuZMcbchpsn5h66p5DNRybR9DfZeV+BRAhYa1B7y+LCOoiDJPo50wjfXb1mvxno
	 88e5CEG+Z+bBfm7NkuXv4rKPl18zd8+J5etI7N6jsdy/Ap/MIHs/Glgp8Zge62i2cyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k2RTfmYz+FR0ku8ymVvJ5xMZoCwCYEToCbzdZkx8Ygw=;
	b=jKvyx9RFB/glAybmTIKYTEPyR0Gpz5DHYPSQfg0Gdrwwj6rOLTHQlHKsAjy53jlVLKFZ
	 gmlR5CmcrsebWQ82Zyq994QmWDdU7aICGbK6+lIHAuZFR9BXDI/P932clrBQgVV4PaVn0
	 b/hTrKLfBudSvybZmDexfzzw7vL4B4HMKoIMov/B2ab1UXPbQbRiC31pHEoj+idXxtISv
	 /1E2R5GnIKXgzJ8CSTgEuNNbnj68uGam2eiQZ7dQjkw9UaqvXm4s61bD/IagZVRUU6WuY
	 QhLsIKr2f/5pJGcTtm61caU4smCXIPi3mkvwFxe1zi2xxrw13tdZg+GDGOMLhMNe5ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jtcmnkb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82F860A2602;
	Wed, 28 Oct 2026 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtcmnkb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4801F01825;
	Wed, 28 Oct 2026 19:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217028;
	bh=k2RTfmYz+FR0ku8ymVvJ5xMZoCwCYEToCbzdZkx8Ygw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtcmnkb/4nZjy6DZIIu0dq7mxOndC3WpI03mOqt18FGlut1fMg4ujYrYl/6QKjZOZ
	 6a3nont9Y4pnrFk1G65grVKK9Keb02Tw+u52TTZRb/GCu23jlI2KW1j5hRLnd+Zecm
	 9Zf0uHlrG2kHqEycake0Q/TM2teV/XEhP+BG6JAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 1763/1887] s390/ctcm: Prevent XID null dereference
Date: Wed, 28 Oct 2026 18:04:19 +0100
Message-ID: <20261028170539.575707633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -824,7 +824,7 @@ static void mpc_action_go_ready(fsm_inst
 
 	fsm_deltimer(&grp->timer);
 
-	if (grp->saved_xid2->xid2_flag2 == 0x40) {
+	if (priv->xid->xid2_flag2 == 0x40) {
 		priv->xid->xid2_flag2 = 0x00;
 		if (grp->estconnfunc) {
 			grp->estconnfunc(grp->port_num, 1,
@@ -1633,7 +1633,6 @@ done:
 			"The XID used in the MPC protocol is not valid, "
 			"rc = %d\n", rc);
 		priv->xid->xid2_flag2 = 0x40;
-		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
 
 	return rc;


