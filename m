Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685A124DCF6;
	Mon, 13 Apr 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096867; cv=none; b=DHK6VB1d6Fw/1x98xVtz1hMfJ826HN4QftNSauXspno1Q26GqcLZN6/8wfZJR00vTD5iikO8AOTUCCNosNeMf/wThoiuabDbusXnFBssdvQphlriK5xAuC9WEhS0ddRXk8r8R27Xh6ced/l8Rp1/84yds5sUTo+srkvHM++Jqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096867; c=relaxed/simple;
	bh=s6lSJ2hpUb/LAVRcLDhbQTOeUMFeKroxmje3palhyck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAA+kU2XBNceq5dIXuilPY0f5lii/lCJTgHXXbrEyAUGq6zVJk5rVKe6m0q8+yn9W3Yxx4B2RZy9OgkLKDoGiCiteFb+q+MQ6R1uI4YYV190hrHxPnnBcg9voaZYSGQ8cma1oA1VGDY4Wa45ps4gxTzw582kqcAAo7NZZhr/ni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mg5qUmHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg5qUmHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007A1C2BCAF;
	Mon, 13 Apr 2026 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096867;
	bh=s6lSJ2hpUb/LAVRcLDhbQTOeUMFeKroxmje3palhyck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mg5qUmHz+iWUtn45aECAckskHsSQMrhungHhVHXtwh4ZGg6zSNCE5ZR3on/as4dI8
	 1Wgw2w04OqK6kEkceIP23jbgOeIY2n0qePn7WVNrEiug4uM3HMeGrmjqyASdte/QDN
	 FjDb8N1d837ZHPy676Ui+itmcCgP4SMKUfnQB80U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 22/50] tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG
Date: Mon, 13 Apr 2026 18:00:49 +0200
Message-ID: <20260413155725.342174745@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleh Konko <security@1seal.org>

commit 48a5fe38772b6f039522469ee6131a67838221a8 upstream.

The GRP_ACK_MSG handler in tipc_group_proto_rcv() currently decrements
bc_ackers on every inbound group ACK, even when the same member has
already acknowledged the current broadcast round.

Because bc_ackers is a u16, a duplicate ACK received after the last
legitimate ACK wraps the counter to 65535. Once wrapped,
tipc_group_bc_cong() keeps reporting congestion and later group
broadcasts on the affected socket stay blocked until the group is
recreated.

Fix this by ignoring duplicate or stale ACKs before touching bc_acked or
bc_ackers. This makes repeated GRP_ACK_MSG handling idempotent and
prevents the underflow path.

Fixes: 2f487712b893 ("tipc: guarantee that group broadcast doesn't bypass group unicast")
Cc: stable@vger.kernel.org
Signed-off-by: Oleh Konko <security@1seal.org>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/41a4833f368641218e444fdcff822039.security@1seal.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/group.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -746,6 +746,7 @@ void tipc_group_proto_rcv(struct tipc_gr
 	u32 port = msg_origport(hdr);
 	struct tipc_member *m, *pm;
 	u16 remitted, in_flight;
+	u16 acked;
 
 	if (!grp)
 		return;
@@ -798,7 +799,10 @@ void tipc_group_proto_rcv(struct tipc_gr
 	case GRP_ACK_MSG:
 		if (!m)
 			return;
-		m->bc_acked = msg_grp_bc_acked(hdr);
+		acked = msg_grp_bc_acked(hdr);
+		if (less_eq(acked, m->bc_acked))
+			return;
+		m->bc_acked = acked;
 		if (--grp->bc_ackers)
 			return;
 		list_del_init(&m->small_win);


