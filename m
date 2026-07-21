Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9399046D544;
	Tue, 21 Jul 2026 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662783; cv=none; b=UAma7/M7Y+Gl481CVO3W4nXGpG7TohaO4uE7iTlLjc1Tq4ZNoOMYNmcW4d2W8fJSJxPKbrf2rBNF1LFnj0UTDibaDEECvJ4EYpIv72uJIbqxGH4lqoLILPd+ET937QCirKscMh6NprlDy1RCjBzzCPT2UEorn+satQq9kPZk2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662783; c=relaxed/simple;
	bh=k0DS+8y/ya6NVEsSmdaoczTunxM2MaK1+AW9V2qfroY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPTrugSqzAkNOpJpA/YyxD7FXoh5EiZ9riViAgZchK9fAdoMfLd4MSOVO1W81DnKDauHpVarXOf3H/LSIVDJRHYl9VcBJo7J1Af0pyzKP2nDvKgbkAIHYSMbtXqVJhQlXfBpyjEsFhd2nNFt3827MjQZ6fcWFqH5oh8hU/w7E2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usMnpL1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usMnpL1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0583D1F000E9;
	Tue, 21 Jul 2026 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662782;
	bh=BBPnFJnqxOTf/znciMbBmRJnGj0QOVQHQnP80AYymeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usMnpL1Wx51l3m1Aujuj1GOgO76quDBUyw4WLsZ1abeghoCyB3tvEvsaUgky4L106
	 9BkYdXrAI2BN0Rx917Gmv9WM5PFRUZ1RDMr6x4eT9A4hYe6zAaC4qB8fRpGSTSuPpN
	 bzx9Qqw3Y4Ks3SRWMsb90Uwz/wkN4+1OtbrzAqyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0575/1276] net: psample: fix info leak in PSAMPLE_ATTR_DATA
Date: Tue, 21 Jul 2026 17:16:58 +0200
Message-ID: <20260721152458.982528038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit aedd02af1f8b0bceb7f42f5a21c41634ca9ed390 ]

psample open codes nla_put() presumably to avoid wiping
the data with 0s just to override it with packet data.
This open coding is missing clearing the pad, however,
each netlink attr is padded to 4B and data_len may
not be divisible by 4B.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260616003046.1099490-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psample/psample.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index 25f92ba0840c67..2d3bda59fa0d21 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -476,15 +476,17 @@ void psample_sample_packet(struct psample_group *group,
 		goto error;
 
 	if (data_len) {
-		int nla_len = nla_total_size(data_len);
+		int nla_len = nla_attr_size(data_len);
 		struct nlattr *nla;
 
 		nla = skb_put(nl_skb, nla_len);
 		nla->nla_type = PSAMPLE_ATTR_DATA;
-		nla->nla_len = nla_attr_size(data_len);
+		nla->nla_len = nla_len;
 
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			goto error;
+
+		skb_put_zero(nl_skb, nla_padlen(data_len));
 	}
 
 #ifdef CONFIG_INET
-- 
2.53.0



