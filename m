Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88BE387362;
	Tue, 21 Jul 2026 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657548; cv=none; b=BR0uemTeWkyYClqBwkCcu0DQH5XdDsCKPEYmTkrxw7QHEsCHUUXW1UoPAdjLGpQBJ4PbDEyYBh6gbmybo1z1y6PQcXc2+fKStgid4i3gAKKlk+n1B61D0Ena/icGjMAH83MwrN09ce800HS6QmeKXiYXj/y/ungDfETZLJXL7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657548; c=relaxed/simple;
	bh=KostkaWRXbY9ooaRDdZtXq0qTd8E2h0YPRoddM3SZxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Acj2+4FnXyh9YzzA/w60iYh+Yf8hLY1krbrhEiEhiGpWgJQiNwY2xOhjQiw1LIpzi4DEKMWKq3lSFGgfg2dcF8fjofHfkkGUemqYw3M1fWfhCTpxNVh6TB1vSbX0VGH3kPg3CQdrQXXsPBRsVoB3klvgCTG4MWTh+wTghoj4ePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y8FJ7Tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y8FJ7Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098481F00A3A;
	Tue, 21 Jul 2026 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657547;
	bh=xt3hRFsBCizpyGVBnE6cQ+SbqcOj/F//Tn0hmCY9JWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Y8FJ7TlIsRIH0fy2y0UZrDOVKbwq6hHfGQiE9/4e/IYtty4OPVk96j4v7aoVgLIC
	 dYdSepYoMyCS3uendNRMnjavh6vpubaYCr4wqLW//ahkE8kntd49mRC7dU9ryPbUe4
	 WPVTNTzQPGsH9seoyNS1X356KgieecYn52gz6WG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0807/1611] net: psample: fix info leak in PSAMPLE_ATTR_DATA
Date: Tue, 21 Jul 2026 17:15:23 +0200
Message-ID: <20260721152533.538175186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



