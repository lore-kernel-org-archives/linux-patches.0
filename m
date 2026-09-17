Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F239E6EB;
	Thu, 17 Sep 2026 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664003; cv=none; b=YQSB8aSAgMdEyzDcSg7Ci7jqDrJiF+u5vKBoVQaJHhe5WRxmiglXdcFfT/N6t5c8qYygVCg7Vf4Rk90sc4qCFMHCMdU+cLT9atiG1SGF0mRT3O3GE6WHn7GYNufkSriB1shkrps+2xhmEdPUvU0hr67vX79X1HTtcNRgaHPaU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664003; c=relaxed/simple;
	bh=DNcg2CHuDoBql3QpK3R+gpnuxbUwGu1/lVJroMMypjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVOmVsBHgWlWGWk/pdf6BBxBCfcmnN2IKq42L4qbfRPIQvudU3cnkg+IiA8zNuS0ALSfHBtU2Bo4lyeruDnX6pmF1eWJaaQ2U4ufHQwRZXL59Y3hEN8ENam+9pvF4i9jiYev9UbeCvoyhs37TKJGRT0SlYabJ9aKkqNkXxnbNAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngimvlpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngimvlpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0001F000FF;
	Thu, 17 Sep 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664001;
	bh=ajqhXCOnToL5BTtkjaOvPpkpsXUMOY/6yWectHBQLfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngimvlpQIup7uOR8MNTgYFqcya3ps4v1RzJw2Se87QnmGC8MKZZHNBLEm1I4TefZ5
	 A4eCBjX+9ea1A88boaYZ6XEzVIaw5JChZ38PMqQovEHXsM7zFCt6qvkmS5trIydWnj
	 oaV++qMWKkRvCCR7MHYrgGQUlXXOq348GzpmG7Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0227/1250] net: hsr: require valid EOT supervision TLV
Date: Thu, 17 Sep 2026 16:00:22 +0100
Message-ID: <20260917151558.293331165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 299de290ddaa5..901eb85c112d1 100644
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



