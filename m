Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FC63ACF03;
	Mon, 23 Mar 2026 13:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274301; cv=none; b=fHWcGPMuPIAMhOPjlhRoRA1KGL9/vPitnyX4Bpt4SLQYdCDszzNF0xGXXhCJvhO0Al860w4V5uvqvPqqn5H4zC4IHQHoIx7iiUyRd8S3yEY+zbhgOH6ORe7vCBtwHDSQln4j8o/kCwBEJ6awHlZbbUrbXDG1yc586eoz3PgPsUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274301; c=relaxed/simple;
	bh=B7JeFZjmn5LziKaFJzqQdrXP0uCYXpbzpUJIyLrYqJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0scV/lH0qw6RfC0uOT9XuWrEmc/LpkED/6ddW823X58CuJq3Ib1tN064rRbzCvpG+0d3sggIHV7Y5IpEGnlk5ds3tViSxpqsBc2WBGSOK1GAxCJRm4fFLPbmJZ7oZlQajdI4uuFCRzsntXqjwX2jQ6ml0ArS9qSCmZ4Ljxel9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5FFipqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5FFipqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACBBC4CEF7;
	Mon, 23 Mar 2026 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274301;
	bh=B7JeFZjmn5LziKaFJzqQdrXP0uCYXpbzpUJIyLrYqJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5FFipqoRFPCfqN3P2IoEwuwx9oM6JdDBoqdlawUu3Yvticj/1aeMejFxGcmO0CI7
	 FF1JC7o1XgyqkOf/jq7maoONbupHWwlJounJov/QE3BkPOt196vnrWO22vpLhN2GO/
	 4SMXe0hjYQh6MrcHKB9R+SYvIiI6+qVzw7NshR6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 119/220] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 23 Mar 2026 14:44:56 +0100
Message-ID: <20260323134508.362251090@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit b6a2bf43aa37670432843bc73ae2a6288ba4d6f8 ]

Core 6.0, Vol 3, Part A, 3.4.3:
"... If the sum of the payload sizes for the K-frames exceeds the
specified SDU length, the receiver shall disconnect the channel."

This fixes L2CAP/LE/CFC/BV-27-C (running together with 'l2test -r -P
0x0027 -V le_public').

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1618fe98dce71..05acc2e98f58f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6721,6 +6721,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



