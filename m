Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF07319CCEE;
	Thu,  6 Jun 2024 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683421; cv=none; b=P9I/j5CsWr2tRiCq7eynmZ9qvyVNcdFbTzirwVu2k49mk3NO+XVMHFRRDWe+gQUQXuYuR8CEqsdi0Pjy5JFSgSjS6JzYoxMYOLRsh2V3lBAan/G/FfRDPrzSTBrlM/BOBgGTAFWZOYC5YoJJRBlXhWY0dOtfTBglc3Y0X3rg6cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683421; c=relaxed/simple;
	bh=ssHofhTWnlmdSd8nYId4DtXlHqEL3beq5nK43VkFPEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1bLK0Kg+Vgd3ZfLeJgK2nsj2J0wAw1+BqY4wToa5Pd7arjgC/V/G8nheVRFZv1YbN6uTLsOMnzTgu2WhdqooWhD8EscbqLbIGkJFNHa5/KVwj1pbxXLnADcjDT9uoamu/pyKDQgcxX5vrmAyUOL715jNtScb2mE6RLbxl22hIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbHdW9DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbHdW9DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD26C2BD10;
	Thu,  6 Jun 2024 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683421;
	bh=ssHofhTWnlmdSd8nYId4DtXlHqEL3beq5nK43VkFPEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbHdW9DNKKqwOmttT254onzVAM/PyWWW+kEzTop+wgu7yZj5NbdQb6vzOABtN3YU1
	 H0XmH82HoUydFyu7runO+ssBDufKQVxcEM8vTRI+ZjBO+Z7c6T1Q5oUNQruWHQk3R3
	 lCozCnQ9r+01uPXq0Fwh5ORY0BM2RJiTqs6Cg2qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 275/473] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Thu,  6 Jun 2024 16:03:24 +0200
Message-ID: <20240606131709.008967431@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 581073f626e387d3e7eed55c48c8495584ead7ba ]

trafgen performance considerably sank on hosts with many cores
after the blamed commit.

packet_read_pending() is very expensive, and calling it
in af_packet fast path defeats Daniel intent in commit
b013840810c2 ("packet: use percpu mmap tx frame pending refcount")

tpacket_destruct_skb() makes room for one packet, we can immediately
wakeup a producer, no need to completely drain the tx ring.

Fixes: 89ed5b519004 ("af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240515163358.4105915-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7188ca8d84693..8888c09931ce3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2528,8 +2528,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



