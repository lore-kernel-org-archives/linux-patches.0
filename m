Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002DE3A961B;
	Mon, 23 Mar 2026 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273828; cv=none; b=qallW3NCqdRX6AP+7qWFhqi1g7XxpLX3B3ApYh59YD4DDYILaRDWVS7+xOJKq2l+hSNxTLy6A0JlPAGVjmSmkLaZWw00pG/t2DffINWASj8Ss0Neei7qFYhUodPfMX+SPPkHTRUYMbma2TFKJ3f7DGZA6QRE7QmK/YhsXwLiPlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273828; c=relaxed/simple;
	bh=q2gD661scyQkbKZ11AWgS0ZP3gQzomaw+OekK4pgcW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WuKwsHbGEm3s02aWmx8vSlBbHKxtB7nrk7GiMa4yVKr2cdX4bFhd+xX8tkUaWZOF7HfnBd/Ac3Uj+nevUBPlEQirrdHQ7+lMrj3XLfQ6MzEO1reTlQGTtFdT/9y5M/sM3OineQF8KgeKkuQGNjQf+qzj/iI3vA+lxlHK9scbIHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8YafWL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8YafWL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391DDC4CEF7;
	Mon, 23 Mar 2026 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273827;
	bh=q2gD661scyQkbKZ11AWgS0ZP3gQzomaw+OekK4pgcW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8YafWL4Kqawwa4R+617QxUcQWOlQRsiFNipOyNTR9PUCuf6FvodPslV78gpZTfUM
	 eRJBu1VYJoZf9ZI3+nzzJHWBjxjfhEikkdXROyc4K9YIZpEyVm4QrxVZMJ0JMg2kdF
	 LIBT0ULVLcJgQEFcwgBXJswkv9eVg1Gw/gvt+/G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.19 021/220] Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()
Date: Mon, 23 Mar 2026 14:43:18 +0100
Message-ID: <20260323134505.247631812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5408,7 +5408,7 @@ static inline int l2cap_ecred_reconf_rsp
 					 u8 *data)
 {
 	struct l2cap_chan *chan, *tmp;
-	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
+	struct l2cap_ecred_reconf_rsp *rsp = (void *)data;
 	u16 result;
 
 	if (cmd_len < sizeof(*rsp))
@@ -5416,7 +5416,7 @@ static inline int l2cap_ecred_reconf_rsp
 
 	result = __le16_to_cpu(rsp->result);
 
-	BT_DBG("result 0x%4.4x", rsp->result);
+	BT_DBG("result 0x%4.4x", result);
 
 	if (!result)
 		return 0;


