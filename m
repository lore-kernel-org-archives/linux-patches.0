Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBA93A1B6;
	Mon, 14 Oct 2024 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919915; cv=none; b=Y1Bf4qakgW6LxLd8k2FhCblEALJxqqerz3QqG4VzIh5VIprSVMZSuUlZCVaE+Crgk1yLMxuNnFHlA6S5R70X3lCMRMHM2jZIEtPJ6g1+vMpZnvKGbyFCo4Hz8S5AWz6Z63bEVS4KmNTvjUxsdgqtFZOpZwjCjo4UbNrN63xzJlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919915; c=relaxed/simple;
	bh=/z2ooyVBq060Mfn+pu0EWs4yYmRy1HpqrI7ZhpS7hrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9GAueY1kpdYSQs/JLM5ZbAOMDXm6WtxER4BAw6BaA48+ZU7EpZ7oPts7CW46uUU5P4lYt/EfAcyXkqpEFgDBu44jUtURUiC0sbGWiwWgvaoUxvg6oZAk2yAoeSVzfmEkLpuZ8ipRCbc4GAYwACWfXtNCxCvNN+eefAdzfGE2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSOQ/Rti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSOQ/Rti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9DFC4CEC3;
	Mon, 14 Oct 2024 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919915;
	bh=/z2ooyVBq060Mfn+pu0EWs4yYmRy1HpqrI7ZhpS7hrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSOQ/Rtii4qO1Q0ano4HwMp0/IGMM4Q5PAoEcNEV0pMPA2o3wCeyt+fcTpdZDVYGA
	 CdGlNFdQmX07R/t0MxsJZKzILebRjcnnEmi3SU+66R9cq5jpokOH2sdGYlssUbmWUP
	 UqDbW/WEfgOnxEGMjY+wMmxCQ0xUuwmLV7M6qngQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 745/798] net: dsa: b53: allow lower MTUs on BCM5325/5365
Date: Mon, 14 Oct 2024 16:21:39 +0200
Message-ID: <20241014141247.338563905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e4b294f88a32438baf31762441f3dd1c996778be ]

While BCM5325/5365 do not support jumbo frames, they do support slightly
oversized frames, so do not error out if requesting a supported MTU for
them.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 28b58dee6b8cd..83f71c181a15c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2223,7 +2223,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	bool allow_10_100;
 
 	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
+		return 0;
 
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
-- 
2.43.0



