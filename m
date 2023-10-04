Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF651D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2734C433C8;
	Wed,  4 Oct 2023 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443194;
	bh=K1RfelspRm3VziNrwn3sTyPgYs+rRjjozt7GZeXWwPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIHZLUOO5xUqucFrWR5k9Y8+u5VLgxLilPKxapu8DRANzVqcek5ZgV9T61X8HBOLd
	 wmScYN58DxoZPlZAHF1Kssa+oIM9PcFuRGl7ayyjYbrXx53fnPxh0suQTFc9wPBBDt
	 nG/wN9xA1xC3pD5sKxH5EmzlIZAovBWAeKhdAv2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram.Ha@microchip.com,
	Lukasz Majewski <lukma@denx.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/259] net: hsr: Properly parse HSRv1 supervisor frames.
Date: Wed,  4 Oct 2023 19:53:55 +0200
Message-ID: <20231004175220.262200672@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 295de650d3aaf9e50258465c5f1c84b465d836f6 ]

While adding support for parsing the redbox supervision frames, the
author added `pull_size' and `total_pull_size' to track the amount of
bytes that were pulled from the skb during while parsing the skb so it
can be reverted/ pushed back at the end.
In the process probably copy&paste error occurred and for the HSRv1 case
the ethhdr was used instead of the hsr_tag. Later the hsr_tag was used
instead of hsr_sup_tag. The later error didn't matter because both
structs have the size so HSRv0 was still working. It broke however HSRv1
parsing because struct ethhdr is larger than struct hsr_tag.

Reinstate the old pulling flow and pull first ethhdr, hsr_tag in v1 case
followed by hsr_sup_tag.

[bigeasy: commit message]

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")'
Suggested-by: Tristram.Ha@microchip.com
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index a16f0445023aa..0b01998780952 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -295,13 +295,13 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 
 	/* And leave the HSR tag. */
 	if (ethhdr->h_proto == htons(ETH_P_HSR)) {
-		pull_size = sizeof(struct ethhdr);
+		pull_size = sizeof(struct hsr_tag);
 		skb_pull(skb, pull_size);
 		total_pull_size += pull_size;
 	}
 
 	/* And leave the HSR sup tag. */
-	pull_size = sizeof(struct hsr_tag);
+	pull_size = sizeof(struct hsr_sup_tag);
 	skb_pull(skb, pull_size);
 	total_pull_size += pull_size;
 
-- 
2.40.1



