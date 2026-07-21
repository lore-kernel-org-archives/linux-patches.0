Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5F347125C;
	Tue, 21 Jul 2026 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657615; cv=none; b=SoD8Z5E9Zai5DZsjAMGPB1WI4utOWlelpFZ1E5T3AEnKCfL7WBMFwZL8c2odhNhY6V3O8vVVNAEcBj9GJQT00kj8rV3RhTSYxBkziZsUUqTCmBhetgypw7qcvKUYuGqAy9B3JFS5pDfVEFnn2eVFuOXFJt/cI86QX9xQo3A49sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657615; c=relaxed/simple;
	bh=bXwHCyvaidy6jKnNCgWVTpJiso+MkyJm81U6RuYucFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdZU/oBtq8kDPGQJGPQwq+BZF0x0kSpNpKlgRLLP+lSShFnOYaxZYzuN4zmFRIplM7/1vbJI2vb0+BN2j0/acF8sODOt9dtLYwaLQ/PcfCAU+Gu2dkU5H79S8OUuFgIwEuRd9OULCxr/E3Th1CRLg/O78VR76RauAJE8DkOdjKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2deGMaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2deGMaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3FB1F000E9;
	Tue, 21 Jul 2026 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657613;
	bh=ASUYAw9jSx7XbakVzXaSRfKCKNPSzrSdZigyemYY3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2deGMaJaEf7WJemWmvFsbVN891p5dxIyRTIQSI6Yu+WdYJruy3KwL+tiILPaaYqL
	 GrLjs7Re89owybfxU23kwAej7VH0nvHWH+LjjhwWleeikh1WISWkjh6Z8f/XNFY6AB
	 TuUpKPaD80fFwjyvjwvPnbysdmfbVJMSv0vx4hY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0829/1611] ieee802154: fix kernel-infoleak in dgram_recvmsg()
Date: Tue, 21 Jul 2026 17:15:45 +0200
Message-ID: <20260721152534.035246270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



