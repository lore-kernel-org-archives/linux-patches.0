Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EFC387598;
	Tue, 10 Mar 2026 11:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141213; cv=none; b=n8PLBUUpQHFdDZs22WxwOjkrNl5JRLu0zddzNNQ8qhmhWWSpGz2KEzUmsiOzH6Rp1O4Mdd3OPkrYh/qtyko3PK/bpYSD/idafPinblEf4bZqFLDsUx2N0ILVOM1/qImHgmke+YqcHfnCqrem/idZgQnD5BL48ufLbbV8NibZDTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141213; c=relaxed/simple;
	bh=GLcZAwVq1HhxEbPElbLqNMb/kFqyXsCVM3R6Z2T+W/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3GZSVY8M+YYuEFqrfYEaS9ZSIJA2Ff4RrPXwJbRBI8Dqe3eaXTJLpCCMlqu/f4AYW1+beqSUYt2r6FSSOVBgv6ZEWDVh4570Vt1y8V7OgYliPmXZrzGrUpFymy7QxRc+ahtwo9YQsn4FWyAV/+pqWXciOvHVWIKNcvBov5nW0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6x0nUV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6x0nUV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE51C2BCAF;
	Tue, 10 Mar 2026 11:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141213;
	bh=GLcZAwVq1HhxEbPElbLqNMb/kFqyXsCVM3R6Z2T+W/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6x0nUV0W7t33366ypiTuT9iS7yIDqRevTYRQz2BuxZa3rKgGQjG939TjLbQI29bl
	 oJZaQYyIWFtvojUzyGUv/2ozS0KQPI54gfqNZ4SV/YOF1CuKKmZhnDjxvl0mOXmrxf
	 Ex8djHx0U0s3D+eBH5QUnkRege//Y3s7FqrIyXmXuyGvHhPtHLdnqipNULql9awc5/
	 aXviB6yBtRI2CcDEA02QKDBWjvi76dYotq0zpPiw5IQs3gUm6AB2d39FGxO04XJCTI
	 zsuSbpKYKqLISMI8mMkuixl5wkk2lQohve3Q7Jxfr6Qt3RF48XgCRFcdY0+9MRPzh+
	 WFYmaYGt3wCXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+72e3ea390c305de0e259@syzkaller.appspotmail.com,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 214/311] atm: lec: fix null-ptr-deref in lec_arp_clear_vccs
Date: Tue, 10 Mar 2026 07:04:21 -0400
Message-ID: <2b9488d06eb0bc62bcd93d5c3fc1a11f48622a31.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index afb8d3eb21850..c39dc5d367979 100644
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

