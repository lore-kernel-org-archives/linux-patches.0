Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F6484881;
	Thu, 17 Sep 2026 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659501; cv=none; b=a8j+dW4gMR2YJN5nmBooRovteyZ3GnvYgA/x+9qD0h3v5ufzvx3G8vyPXSa8y2MNkoFF4tZI1oo75M/M2eqjpF/RkW3B2Kc5hJGMj/smng0000ssr0COpDNtttq1DMJRxAUZqjzmnyFwK8iIvTHXIVAgzUTMbTy1pT4z61wVZlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659501; c=relaxed/simple;
	bh=Ow0YtyMH/InDFlHUBKm0ImzXo9i1B+sOXZHDWoW9oq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kctklb1dfkIsal0ZGcMe5JoQ4AktmATOXIyK7o4+yaStQ6BFz94KRRNfTo2907IQtP1p+bJKKnxvh27R5msQKAdN7i06pKJ4HmLH2QPWv+ueJfBab2FzTy5dhEagJnDDn7SurlspaXVq4PIwLID8MsbhgrsMdffoRacoyFjyvZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwjMVGIA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwjMVGIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF1B1F00899;
	Thu, 17 Sep 2026 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659493;
	bh=dc2cqHCgHGfnOSTCxDzLig2EWu1nR6oZzLCNryD5yuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwjMVGIAlhlwFxzqIXaTYTqZtPfwugNwno4VEF7LhA/Y2xGI40uCWsxmUKMg7DnPW
	 3KbrCNBBieLhLIuPqEN0HkgspOOYCkuPU7B9WUPnfKiU/pJw5lhBhkYr7n7cQv4+Eg
	 gT+lYn4+GDpC71DrexwhtNrmlRPL7u/Vt+TjaATQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 274/733] net: dsa: bcm_sf2: bound the CFP rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:09:42 +0100
Message-ID: <20260917151358.182865535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit cdb719f4b8596d9ccee2d56d204c2c4dce982f46 ]

bcm_sf2_cfp_rule_get_all() walks the whole cfp.unique bitmap into
rule_locs[] without consulting nfc->rule_cnt, which is how many entries
the caller had room for.  ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN
and the ioctl sizes the buffer from the rule_cnt userspace passes in, so
once an admin has installed CFP rules any user can ask for fewer slots
than there are rules and run off the end of the allocation.  A rule_cnt
of 0 leaves the buffer pointer NULL and the walk dereferences it.

Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 50d3a818eb1b7..84a086c3e99b4 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1088,6 +1088,8 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 	unsigned int index = 1, rules_cnt = 0;
 
 	for_each_set_bit_from(index, priv->cfp.unique, priv->num_cfp_rules) {
+		if (rules_cnt == nfc->rule_cnt)
+			return -EMSGSIZE;
 		rule_locs[rules_cnt] = index;
 		rules_cnt++;
 	}
-- 
2.53.0



