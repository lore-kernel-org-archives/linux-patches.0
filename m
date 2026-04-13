Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1CE313298;
	Mon, 13 Apr 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098995; cv=none; b=XXsqb3Td1Jw9zCDyh3ZQCMLN/QuKhsXimmq8eAjwkxCGRH3pZixBVgpaCAtvnb8p1JDlxkeui24TUs8eu8lMv60STrJJj6rpv3mJWp/IrB7FNdCaR1ksE+bhP0+BwQWWKiuXgwuRBmpwEpcRLMHZn3g4Ts88SqzptihAI8YP0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098995; c=relaxed/simple;
	bh=XUP5n2eM+snzg4RfOIa+PWeRqOZ79DmLmx09YKRtDBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2DyoGtbGHDFUH1m5nrb5cnd0qg2dfbeC9ZYmJ8Y/DCubDv/TprJPcHHMRWHe0EvUkmXND1F6KDDcHUy4XTiHEkBZvc1QSd7Ne+21e/3RMPuMbQfYAHmI0XqLuNWKk2kYkA7nRBGfcFCCQkjbRa5gFdSohTMZRSGWjFpHbvDptc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGmlZvqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGmlZvqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E7FC2BCAF;
	Mon, 13 Apr 2026 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098995;
	bh=XUP5n2eM+snzg4RfOIa+PWeRqOZ79DmLmx09YKRtDBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGmlZvqj6ldXKJOEawgKBIduC1tC6JRSbVHquBNdluP+ptMIoanoK/MqZ9W02qGsS
	 kE+zE0XZ8RqivPH/NKZ70isXetUaZRA38V4jMi9YeKNznnqtrD2jF+UAGKrcbiR+/v
	 cOMnuX6LxrKw9G1DOyN6IGj3tB0tC98crudmVMyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 142/491] Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()
Date: Mon, 13 Apr 2026 17:56:27 +0200
Message-ID: <20260413155824.353369944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Johannes Möller <research@johannes-moeller.dev>

commit 15145675690cab2de1056e7ed68e59cbd0452529 upstream.

l2cap_ecred_reconf_rsp() casts the incoming data to struct
l2cap_ecred_conn_rsp (the ECRED *connection* response, 8 bytes with
result at offset 6) instead of struct l2cap_ecred_reconf_rsp (2 bytes
with result at offset 0).

This causes two problems:

 - The sizeof(*rsp) length check requires 8 bytes instead of the
   correct 2, so valid L2CAP_ECRED_RECONF_RSP packets are rejected
   with -EPROTO.

 - rsp->result reads from offset 6 instead of offset 0, returning
   wrong data when the packet is large enough to pass the check.

Fix by using the correct type.  Also pass the already byte-swapped
result variable to BT_DBG instead of the raw __le16 field.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Cc: stable@vger.kernel.org
Signed-off-by: Lukas Johannes Möller <research@johannes-moeller.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6407,7 +6407,7 @@ static inline int l2cap_ecred_reconf_rsp
 					 u8 *data)
 {
 	struct l2cap_chan *chan, *tmp;
-	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
+	struct l2cap_ecred_reconf_rsp *rsp = (void *)data;
 	u16 result;
 
 	if (cmd_len < sizeof(*rsp))
@@ -6415,7 +6415,7 @@ static inline int l2cap_ecred_reconf_rsp
 
 	result = __le16_to_cpu(rsp->result);
 
-	BT_DBG("result 0x%4.4x", rsp->result);
+	BT_DBG("result 0x%4.4x", result);
 
 	if (!result)
 		return 0;


