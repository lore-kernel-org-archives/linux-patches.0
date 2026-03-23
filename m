Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863323B8D5C;
	Mon, 23 Mar 2026 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282296; cv=none; b=I54I2PC6RSF7So9HN6Rlsj8z9R1bRlGtdD8GOXCCEpiF6YQn3aHUDm5iZQQbUrjSpMSR53aVdX+1NSOipB7x+zRJbjYwYwsiLxF321VtL8lqOn3AZyqAZIWQQQHPXzGfRfIi8PtVw5epk2d6O/28F8Ijy5Bp0VlhGXyroV1xQJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282296; c=relaxed/simple;
	bh=nnWTnAJtlyfG78eji2umdyfxxRZaAhDO5xwJSvCsNTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDMf77Nmk+siKe29nbHlB+vOicFC4AsUApT/353ZfHXsfh/2aylW69RJBHUNL9abNCrTPHLNIb9qHDYyIiobXhfLqYViQxz3sTjsi9gZUJfClE3yn283WdWlNJew/+Of26DAXaDdMmJzfpKwD9vvQwogSp8YbQdie2l88hMgGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jP9LoStL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jP9LoStL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A95C4CEF7;
	Mon, 23 Mar 2026 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282296;
	bh=nnWTnAJtlyfG78eji2umdyfxxRZaAhDO5xwJSvCsNTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jP9LoStL8x3FELlpULCVgveF8HdWpb8pzg1m2ZoSljRwTivYpSjhtV1Htp17ySgJJ
	 AQzQXrT/XmyGJHnQsz26HE+CAbi0/ZyVUVhD0Ne3dbNoXHuhM2em99kSM254tJgo95
	 LJsTacR80QH0Ec/sMksnMIso9ZE9kYFQNfKiF4Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72e3ea390c305de0e259@syzkaller.appspotmail.com,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/481] atm: lec: fix null-ptr-deref in lec_arp_clear_vccs
Date: Mon, 23 Mar 2026 14:41:27 +0100
Message-ID: <20260323134527.844931840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 101bacb303e89dc2e0640ae6a5e0fb97c4eb45bb ]

syzkaller reported a null-ptr-deref in lec_arp_clear_vccs().
This issue can be easily reproduced using the syzkaller reproducer.

In the ATM LANE (LAN Emulation) module, the same atm_vcc can be shared by
multiple lec_arp_table entries (e.g., via entry->vcc or entry->recv_vcc).
When the underlying VCC is closed, lec_vcc_close() iterates over all
ARP entries and calls lec_arp_clear_vccs() for each matched entry.

For example, when lec_vcc_close() iterates through the hlists in
priv->lec_arp_empty_ones or other ARP tables:

1. In the first iteration, for the first matched ARP entry sharing the VCC,
lec_arp_clear_vccs() frees the associated vpriv (which is vcc->user_back)
and sets vcc->user_back to NULL.
2. In the second iteration, for the next matched ARP entry sharing the same
VCC, lec_arp_clear_vccs() is called again. It obtains a NULL vpriv from
vcc->user_back (via LEC_VCC_PRIV(vcc)) and then attempts to dereference it
via `vcc->pop = vpriv->old_pop`, leading to a null-ptr-deref crash.

Fix this by adding a null check for vpriv before dereferencing
it. If vpriv is already NULL, it means the VCC has been cleared
by a previous call, so we can safely skip the cleanup and just
clear the entry's vcc/recv_vcc pointers.

The entire cleanup block (including vcc_release_async()) is placed inside
the vpriv guard because a NULL vpriv indicates the VCC has already been
fully released by a prior iteration — repeating the teardown would
redundantly set flags and trigger callbacks on an already-closing socket.

The Fixes tag points to the initial commit because the entry->vcc path has
been vulnerable since the original code. The entry->recv_vcc path was later
added by commit 8d9f73c0ad2f ("atm: fix a memory leak of vcc->user_back")
with the same pattern, and both paths are fixed here.

Reported-by: syzbot+72e3ea390c305de0e259@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68c95a83.050a0220.3c6139.0e5c.GAE@google.com/T/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260225123250.189289-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index b7fa48a9b7205..0d4b8e5936dcf 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1260,24 +1260,28 @@ static void lec_arp_clear_vccs(struct lec_arp_table *entry)
 		struct lec_vcc_priv *vpriv = LEC_VCC_PRIV(vcc);
 		struct net_device *dev = (struct net_device *)vcc->proto_data;
 
-		vcc->pop = vpriv->old_pop;
-		if (vpriv->xoff)
-			netif_wake_queue(dev);
-		kfree(vpriv);
-		vcc->user_back = NULL;
-		vcc->push = entry->old_push;
-		vcc_release_async(vcc, -EPIPE);
+		if (vpriv) {
+			vcc->pop = vpriv->old_pop;
+			if (vpriv->xoff)
+				netif_wake_queue(dev);
+			kfree(vpriv);
+			vcc->user_back = NULL;
+			vcc->push = entry->old_push;
+			vcc_release_async(vcc, -EPIPE);
+		}
 		entry->vcc = NULL;
 	}
 	if (entry->recv_vcc) {
 		struct atm_vcc *vcc = entry->recv_vcc;
 		struct lec_vcc_priv *vpriv = LEC_VCC_PRIV(vcc);
 
-		kfree(vpriv);
-		vcc->user_back = NULL;
+		if (vpriv) {
+			kfree(vpriv);
+			vcc->user_back = NULL;
 
-		entry->recv_vcc->push = entry->old_recv_push;
-		vcc_release_async(entry->recv_vcc, -EPIPE);
+			entry->recv_vcc->push = entry->old_recv_push;
+			vcc_release_async(entry->recv_vcc, -EPIPE);
+		}
 		entry->recv_vcc = NULL;
 	}
 }
-- 
2.51.0



