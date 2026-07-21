Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8552F3B47E2;
	Tue, 21 Jul 2026 20:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666700; cv=none; b=LnSvIG+g7KbOZs+5JBN8qn3YaOa3JD74CIdIrxzd2wICSgoQyV6pwKx3mQkbPmIi31KglGnTvXaV6OJ6mJ4F601yPT0pNJ2g5JzuPNBrKD1yEke42mRNbQBW6kAjhdYiBvJDXEgWMtdI2wlRHNCIUrzBwFqNnovCUfpERv7cKYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666700; c=relaxed/simple;
	bh=48RROYUQm6M7savw4BSRbrQ+Fu+z1volxP/7ZgOJmyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuwzyOsm8Vwb1sDSWPZtjqsVEx4f2joLwt0bAjJlk8pEZX0+x7xLwIUj6ttRE1UydohMv6JXiF5RFJDa43g/U2MB3cefdnyJs0v92A/EHZobQ2DyTsiRbgO0p7KAGQrM/hT0keL9uup4CuuUP+BfjKLFnN7U8DkiD9vTfbdPx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTyCouwn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTyCouwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA32E1F000E9;
	Tue, 21 Jul 2026 20:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666699;
	bh=sJwn9e2KbSGJXDgGGNqQNDhZCaUUtP2Lcz28ux60EMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTyCouwn1CGHawv+CJosYB41vuE34g+Dmh+WgKbEynSKIuhf11+KXiT+gAd8VKRt+
	 j+SztvFJk54deVP36FqKJydJnpAbjweLFSMkWmMgR9R42shkYZGzTvjG0yN6es4noI
	 zXT7LRkY+68QeigczjZWWk/0wHNQmkQrcLAyGG/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0739/1266] ieee802154: fix kernel-infoleak in dgram_recvmsg()
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152458.409419800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 4db86f8ab11b5a41bfc36680be837e6ac1375ec6 ]

KMSAN reported a kernel-infoleak in move_addr_to_user():

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user
include/linux/instrumented.h:131 [inline]
BUG: KMSAN: kernel-infoleak in _inline_copy_to_user
include/linux/uaccess.h:205 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_user+0xcc/0x120
lib/usercopy.c:26
 instrument_copy_to_user include/linux/instrumented.h:131 [inline]
 _inline_copy_to_user include/linux/uaccess.h:205 [inline]
 _copy_to_user+0xcc/0x120 lib/usercopy.c:26
 copy_to_user include/linux/uaccess.h:236 [inline]
 move_addr_to_user+0x2e7/0x440 net/socket.c:302
 ____sys_recvmsg+0x232/0x610 net/socket.c:2925
 ...
 Uninit was stored to memory at:
 ieee802154_addr_to_sa include/net/ieee802154_netdev.h:369 [inline]
 dgram_recvmsg+0xa09/0xbe0 net/ieee802154/socket.c:739

The issue occurs because the `pan_id` field of `struct ieee802154_addr`
is left uninitialized when the address mode is `IEEE802154_ADDR_NONE`.
The execution flow is as follows:

1. `__ieee802154_rx_handle_packet()` declares a local `struct
ieee802154_hdr hdr` on the stack.
2. `ieee802154_hdr_pull()` calls `ieee802154_hdr_get_addr()` to parse
the source and destination addresses into this structure.
3. If the address mode is `IEEE802154_ADDR_NONE`,
`ieee802154_hdr_get_addr()` previously only set the `mode` field,
leaving the `pan_id` field containing uninitialized stack memory.
4. This uninitialized `pan_id` is later copied into a `struct
sockaddr_ieee802154` in `dgram_recvmsg()` via `ieee802154_addr_to_sa()`.
5. Finally, `move_addr_to_user()` copies the socket address structure to
user space, leaking the uninitialized bytes.

Fix this by using `memset` to zero out the address structure in
`ieee802154_hdr_get_addr()` when the mode is `IEEE802154_ADDR_NONE`.

Fixes: 94b4f6c21cf5 ("ieee802154: add header structs with endiannes and operations")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=346474e3bf0b26bd3090
Link: https://syzkaller.appspot.com/ai_job?id=a507a109-d683-4a2c-bc03-93394f491b17
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/62795fd9-fc0c-48eb-bb82-05ffc5a57104@mail.kernel.org
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/header_ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index 41a556be101790..a9f0c8df5ae4ac 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -173,10 +173,13 @@ ieee802154_hdr_get_addr(const u8 *buf, int mode, bool omit_pan,
 {
 	int pos = 0;
 
-	addr->mode = mode;
-
-	if (mode == IEEE802154_ADDR_NONE)
+	if (mode == IEEE802154_ADDR_NONE) {
+		memset(addr, 0, sizeof(*addr));
+		addr->mode = IEEE802154_ADDR_NONE;
 		return 0;
+	}
+
+	addr->mode = mode;
 
 	if (!omit_pan) {
 		memcpy(&addr->pan_id, buf + pos, 2);
-- 
2.53.0



