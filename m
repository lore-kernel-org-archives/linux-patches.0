Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17567464;
	Tue, 30 Apr 2024 10:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474700; cv=none; b=l7Z9vWBgGqpS5L76wA72f1QhjM18CDXm+JN0sWj0KBcbQuHbrOhBjgdPAwPG07lD3HDp0rQcBLnmvxCHHveTFW0uU3N85cbEI2JeyOJOf6J2xBmD1Gf+9h16XFJ0iTjM8XTngQHGmqWN7sI1QoPwF3OrAvZez8yH/8Cgc2O4el4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474700; c=relaxed/simple;
	bh=VaY7pxNAYLE4M6wueR1n0yDgvE3bSa+i00vZHnP52/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwLYdlGPLh6pUc1Qle9x2FI+79IlI+0/QI6h9y3sTu0Q/yKfvDsbK+H89J0leLGJUeJIEUFGLOQYDb5gR0gyaSmcRWFKCOz0x1s/38PWQ/aPUYe1aaGy0p58aHKKV0g21z4wHkV0JwuXfPKaTUdiYMeZWgfE1gI9BpspE1joIcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/V4C12b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/V4C12b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDBDC2BBFC;
	Tue, 30 Apr 2024 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474700;
	bh=VaY7pxNAYLE4M6wueR1n0yDgvE3bSa+i00vZHnP52/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/V4C12bLSp+SqwOPO8IXrZhcj0UOkD7Q1zslSfg8WD3PMFniOGZcYOODUqZQlbF8
	 yPZsuMw2ggUdjuuuVvSJBuuJTRP4O0Q4LAAcZRUFyf8OUSbeE5tyBtz0mY5RR1ycVp
	 Alg4eciG6NwKWLa8HIfEktp+iMA+4x58Rloun6j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 001/138] batman-adv: Avoid infinite loop trying to resize local TT
Date: Tue, 30 Apr 2024 12:38:06 +0200
Message-ID: <20240430103049.469038967@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b1f532a3b1e6d2e5559c7ace49322922637a28aa upstream.

If the MTU of one of an attached interface becomes too small to transmit
the local translation table then it must be resized to fit inside all
fragments (when enabled) or a single packet.

But if the MTU becomes too low to transmit even the header + the VLAN
specific part then the resizing of the local TT will never succeed. This
can for example happen when the usable space is 110 bytes and 11 VLANs are
on top of batman-adv. In this case, at least 116 byte would be needed.
There will just be an endless spam of

   batman_adv: batadv0: Forced to purge local tt entries to fit new maximum fragment MTU (110)

in the log but the function will never finish. Problem here is that the
timeout will be halved all the time and will then stagnate at 0 and
therefore never be able to reduce the table even more.

There are other scenarios possible with a similar result. The number of
BATADV_TT_CLIENT_NOPURGE entries in the local TT can for example be too
high to fit inside a packet. Such a scenario can therefore happen also with
only a single VLAN + 7 non-purgable addresses - requiring at least 120
bytes.

While this should be handled proactively when:

* interface with too low MTU is added
* VLAN is added
* non-purgeable local mac is added
* MTU of an attached interface is reduced
* fragmentation setting gets disabled (which most likely requires dropping
  attached interfaces)

not all of these scenarios can be prevented because batman-adv is only
consuming events without the the possibility to prevent these actions
(non-purgable MAC address added, MTU of an attached interface is reduced).
It is therefore necessary to also make sure that the code is able to handle
also the situations when there were already incompatible system
configuration are present.

Cc: stable@vger.kernel.org
Fixes: a19d3d85e1b8 ("batman-adv: limit local translation table max size")
Reported-by: syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4188,7 +4188,7 @@ void batadv_tt_local_resize_to_mtu(struc
 
 	spin_lock_bh(&bat_priv->tt.commit_lock);
 
-	while (true) {
+	while (timeout) {
 		table_size = batadv_tt_local_table_transmit_size(bat_priv);
 		if (packet_size_max >= table_size)
 			break;


