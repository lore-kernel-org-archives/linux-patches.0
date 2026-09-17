Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11F94E06E5;
	Thu, 17 Sep 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667627; cv=none; b=VoEPDgvTZBsYPXsKT6YpDmzkn2zzpNUKCHLERgh53hctEGFsC6AUf0j5/XKpXyc7F85Ar1LGUhRYA5s9zdaSpb3iW0k1GiihUGbG0z586iS1a5nCSUrM7TwWuAYZo8A3vECIXYHn2riNphQgANpsN5FZZ8GovYMN03srlO1x9Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667627; c=relaxed/simple;
	bh=ivYrFP3Jt93MPqXy61qdCqS6ppKIAZtTJQDK4TP2gCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlIHexDtb5AX233YZhTFWTLz7hrxYRBlk1QeghO08WdNYtONCdDJsMtN4RWM2GudYIQotU3PyV2MDvAMeKaRMdlrwJvNrLdwX3yT/r4n8Gm8B5UKn2vkBk3jW4R50iXKI6p6+N6k8jicA1579zFMjmpxXrTUzE7xiBXydd/wpx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajE8M0tu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajE8M0tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD781F000FF;
	Thu, 17 Sep 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667625;
	bh=cJ4krXhRIxKiNbzm2UgBo5VmKU/0g0CK4i66ETp2BEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajE8M0tuRaaZpFrlN5LYGfweqtBVDWcYIF08QdC5gxMLcjnD9/nIOOHtBHZmu82OW
	 7fUMDD2ltQS3w2pJuCfuiy0T7n7jI0BX9pMz5wzECXpuRI+LAspQgYPU3q4mxNCt3p
	 E6nFzswP3oS4K57vCjqO4nbUhnKUs7Klcun8tYA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0155/1102] net: hsr: require valid EOT supervision TLV
Date: Thu, 17 Sep 2026 16:01:38 +0100
Message-ID: <20260917151543.423109163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit 46d111a3ef3b5972804dcdce0833767143a12192 ]

Supervision frames are only valid if terminated with a zero-length EOT
TLV. The current check fails to reject non-EOT entries as the terminal
TLV, potentially allowing malformed supervision traffic.

Fix this by strictly requiring the terminal TLV to be HSR_TLV_EOT with
a length of zero.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260523130420.62144-1-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index e3037741a7489..0a938dc5ae157 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -110,7 +110,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	}
 
 	/* end of tlvs must follow at the end */
-	if (hsr_sup_tlv->HSR_TLV_type == HSR_TLV_EOT &&
+	if (hsr_sup_tlv->HSR_TLV_type != HSR_TLV_EOT ||
 	    hsr_sup_tlv->HSR_TLV_length != 0)
 		return false;
 
-- 
2.53.0



