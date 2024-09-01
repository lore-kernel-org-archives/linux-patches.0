Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E75E155A24;
	Sun,  1 Sep 2024 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207672; cv=none; b=RA2WkD9YySixrJZnfRVSyb9u5nI4sB4Wc8DokWR4URCQtE0ugWbz27Y8brXw5aYD1Z+IqGRMiwXmSD1WTmSxJOdBQShhN5mDIbDPPGQtt5yOk7ht/RYmMvs0sZ+OVxS1dyYwX0q8FVpOCddo6h6N4YaSfJ56vWDuNeKbb11pPdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207672; c=relaxed/simple;
	bh=s0D3repaL939DupniR4g+5qt66BPDck7myl9FXk10VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csVXpHBRpWtV+Wpw8cpGAKwEj1CbeQ6sMuHk+lh6MaNhYmmXV0QgSN4rmCSWOf/MfOetVw9k/Rhm2MhbrxQZxL3Nv3NNSoi08mjSxgvmajoFLOkS8SX13fdzuhb47OXkr3F9KOCUQX00/7uTRVQ/XaRLOqLf72lkJNym/4t8KYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0W4kAhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0W4kAhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278E6C4CEC3;
	Sun,  1 Sep 2024 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207671;
	bh=s0D3repaL939DupniR4g+5qt66BPDck7myl9FXk10VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0W4kAhy1xHUFqb/5u1kIAdXrIRckBVASBTXvDjOqGIDoSzjCo7wed00+M5MzwAUX
	 in51l0L4+4ttoyXtxDSwxDaX2j/avUEuhImt1jB5sdp0TE3h+n/wYLiIvTSKkwSk8f
	 ZOj7a79kaA4eocmVuFeS6ZxncK90fy7clqUfSWK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/98] Bluetooth: bnep: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:16:12 +0200
Message-ID: <20240901160805.287388141@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0f0639b4d6f649338ce29c62da3ec0787fa08cd1 ]

This fixes attempting to access past ethhdr.h_source, although it seems
intentional to copy also the contents of h_proto this triggers
out-of-bound access problems with the likes of static analyzer, so this
instead just copy ETH_ALEN and then proceed to use put_unaligned to copy
h_proto separetely.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 7b3965861013c..a16d584a6c0d0 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -385,7 +385,8 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 
 	case BNEP_COMPRESSED_DST_ONLY:
 		__skb_put_data(nskb, skb_mac_header(skb), ETH_ALEN);
-		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN + 2);
+		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN);
+		put_unaligned(s->eh.h_proto, (__be16 *)__skb_put(nskb, 2));
 		break;
 
 	case BNEP_GENERAL:
-- 
2.43.0



