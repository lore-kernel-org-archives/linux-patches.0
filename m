Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B27421890;
	Wed,  4 Feb 2026 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217158; cv=none; b=E/GJWZgznbE4CdXcOIqqevf+7W451taLt9ZhsHiZ1+sOk19ttmJNmIMQlUIJTLMQVff4j7b8oXh7N8DH2hdm5SCyUebeINsOg6rq9M9VzcDgBmC4qkc2e0bMfvDt75ys2H6EF4J/kcJYv0Nul/Aky5fCx05o00oLE4SJjuhZqEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217158; c=relaxed/simple;
	bh=VMpboJwLIRmyD2GV3kNW3P+AIycb951z1/sueT8vRWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ8/qQhNhyZRLHRn9+9OJeAMelhXWkKRwLFQPxizTSN+AE/7X+jPHpJNxcdu4jKJ17KRvu/x57gerJ8UKt24w3VwdLVvisfK6cffUTq7dEDWUrlTPSb3YPyCnWgU9Oo47Mz2FYtLybidWnaiYxC6eFGL5QrWd2nKsxvCDWt828g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/U6Ply1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/U6Ply1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278D1C4CEF7;
	Wed,  4 Feb 2026 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217157;
	bh=VMpboJwLIRmyD2GV3kNW3P+AIycb951z1/sueT8vRWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/U6Ply1FqwQYnmtAohNhj5vAOvgHfH7JIJGmTRiBrDIjuSBDsQDQ9izTE4fqQFr7
	 3yOvjHRKuCv708LQqIWWEtFvuefeYVzWghNRmrgSe2XpSf/baeb0qWk36/cMzCO2hh
	 E60vQAE0RJzj98Q6kZew68ioOJu5/EagzywRFtko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jake Keller <jacob.e.keller@intel.com>,
	IWL <intel-wired-lan@lists.osuosl.org>,
	Jesse Brandeburg <jbrandeburg@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/206] ice: stop counting UDP csum mismatch as rx_errors
Date: Wed,  4 Feb 2026 15:39:32 +0100
Message-ID: <20260204143903.284706192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jbrandeburg@cloudflare.com>

[ Upstream commit 05faf2c0a76581d0a7fdbb8ec46477ba183df95b ]

Since the beginning, the Intel ice driver has counted receive checksum
offload mismatches into the rx_errors member of the rtnl_link_stats64
struct. In ethtool -S these show up as rx_csum_bad.nic.

I believe counting these in rx_errors is fundamentally wrong, as it's
pretty clear from the comments in if_link.h and from every other statistic
the driver is summing into rx_errors, that all of them would cause a
"hardware drop" except for the UDP checksum mismatch, as well as the fact
that all the other causes for rx_errors are L2 reasons, and this L4 UDP
"mismatch" is an outlier.

A last nail in the coffin is that rx_errors is monitored in production and
can indicate a bad NIC/cable/Switch port, but instead some random series of
UDP packets with bad checksums will now trigger this alert. This false
positive makes the alert useless and affects us as well as other companies.

This packet with presumably a bad UDP checksum is *already* passed to the
stack, just not marked as offloaded by the hardware/driver. If it is
dropped by the stack it will show up as UDP_MIB_CSUMERRORS.

And one more thing, none of the other Intel drivers, and at least bnxt_en
and mlx5 both don't appear to count UDP offload mismatches as rx_errors.

Here is a related customer complaint:
https://community.intel.com/t5/Ethernet-Products/ice-rx-errros-is-too-sensitive-to-IP-TCP-attack-packets-Intel/td-p/1662125

Fixes: 4f1fe43c920b ("ice: Add more Rx errors to netdev's rx_error counter")
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Jake Keller <jacob.e.keller@intel.com>
Cc: IWL <intel-wired-lan@lists.osuosl.org>
Signed-off-by: Jesse Brandeburg <jbrandeburg@cloudflare.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 04e3f6c424c0c..db5319a8eb241 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5841,7 +5841,6 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 				    pf->stats.illegal_bytes +
 				    pf->stats.rx_len_errors +
 				    pf->stats.rx_undersize +
-				    pf->hw_csum_rx_error +
 				    pf->stats.rx_jabber +
 				    pf->stats.rx_fragments +
 				    pf->stats.rx_oversize;
-- 
2.51.0



