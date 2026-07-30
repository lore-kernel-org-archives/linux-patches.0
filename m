Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEB37883C;
	Thu, 30 Jul 2026 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423192; cv=none; b=VBmIO4uRx4D3acB9K+93UMZessXDejtwWu/kOGl/R4ezbchVmeU9TmHC+EaJku9iMztL20/TMflCBZz3d1qk8qNv+Ar4XiRhFy3icMwF1e5hh3l5uVtVu8FCfr5zTM6bmQd5KgBXyAydEFU48sjosO7sMrIw7G2bR5ACC/dqCiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423192; c=relaxed/simple;
	bh=CmvkaLQnX35676EFuufX2a5cndH6fp6/NfGArMjSpyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsXdugCCWkk0y/0nFz7zYP3yQ8sXEJ1V4B8stVXBtoouEm4ZozL8QXIKzfXZEp+J4kt0YbqsaXunaQDuLHhRf8wpWBQfo2KGmpBuDt5ms0jHPtyENmrru23F9yc/n0wZUiwlRdAwilgbBZSxmI2kWTClT+ffZ/qfjEOhsSa4WFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi/uIbIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi/uIbIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4671F000E9;
	Thu, 30 Jul 2026 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423191;
	bh=KkHqY16p+GI7KBZaVF3M613tAGg/90Zqy5GIj1bL7n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zi/uIbIwdKcYWn9RRN39bDyKhqJq5dJnXui0S72EBUZqq+bxPHs/FESIcu1CYIATX
	 VzT6LeuGTPsmZdP0K8AQK+3vO9WByeREkm1ALetUU0HOGAA8QHK4wxPszCfynGkE4/
	 Y2Y8jBgZj7vJ1+VDuTP8fWfcrjNal/oATiTF0KZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 653/744] phonet: pep: fix use-after-free in pep_get_sb()
Date: Thu, 30 Jul 2026 16:15:26 +0200
Message-ID: <20260730141458.149588658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 0f71f852a96af9685858ce59fda34ecbf85c283d upstream.

pep_get_sb() doesn't consider that pskb_may_pull() might have relocated
the skb data, and continue to access the older pointer, causing UAF.

Reproduced under KASAN:

  BUG: KASAN: slab-use-after-free in pep_get_sb+0x234/0x3b0
  Read of size 1 at addr ff11000105510f50 by task repro/157
   pep_get_sb+0x234/0x3b0
   pipe_handler_do_rcv+0x5f7/0xa10
   pep_do_rcv+0x203/0x410
   __sk_receive_skb+0x471/0x4a0
   phonet_rcv+0x5b3/0x6c0
   __netif_receive_skb+0xcc/0x1d0

Refetch the header with skb_header_pointer() after pskb_may_pull(), so
the possibly stale pointer is no longer dereferenced. There are better
ways to solve this, but, this is the less instrusive one.

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260721-phonet_get_sb_uaf-v1-1-95fd7881cc4e@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -55,6 +55,8 @@ static unsigned char *pep_get_sb(struct
 	ph = skb_header_pointer(skb, 0, 2, &h);
 	if (ph == NULL || ph->sb_len < 2 || !pskb_may_pull(skb, ph->sb_len))
 		return NULL;
+	/* pskb_may_pull() may have reallocated the head; refetch ph. */
+	ph = skb_header_pointer(skb, 0, 2, &h);
 	ph->sb_len -= 2;
 	*ptype = ph->sb_type;
 	*plen = ph->sb_len;


