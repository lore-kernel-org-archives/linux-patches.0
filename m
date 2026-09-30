Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252E1A683D;
	Wed, 30 Sep 2026 18:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794039; cv=none; b=ACkxrEV2hHjpn7uHgA3DRAsMAxem+u1d/hKQK9wgRXx5CRNwHqNg+tSd3V4qYD2NOJlf8GGsgAUGUXUA8BT/DS0y8pG0XjJCeh09mU1+9WRXmkTqiP2JnasZLQZAe8lxg7N+U0UzxCTxpLrFLdLqdTzj6CJkHDNqtdcPg90XbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794039; c=relaxed/simple;
	bh=OnHjkdweaaErofczsPzePEtgwbv/YBiB8MIEf2JumI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRfrR/3ghA/Hhc1uKemHGFEDxLZnyZJ09FDUxSrt6ni/ASShBCuMsyQASBi0tWiHiYKzcK/eTrh5pB8iarGIj1KGIJ5xa3pH+jrSOQvR1aZWwKtti6VSdKfD1rSdz8gB9v2bveZssqSFTrJGJdFTkVGe1SMX3S4mubd2iEcaTRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXsNPFIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXsNPFIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D731F000FF;
	Wed, 30 Sep 2026 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794037;
	bh=f1B71cE5E50CI9MKXev6gx0GTspMDiuJEOoE1tqtG5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXsNPFIBVKFIgfCGrnJ77oZSO0l4ZaZNKr3UhCBcSlZN4wZd4iNzFkeDL0t+rSGnm
	 uonuLGGORF3HgrNI+txjMaxN/umqYBRQPqOEB0RWY2VAeengOLvCW7cx7sB10D7TZk
	 TNiWwVEs4mGbgxo64f98hspLwaRnUu8zMSfv2eFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0071/1193] thunderbolt: Improve multi-display DisplayPort tunnel allocation
Date: Wed, 30 Sep 2026 17:12:35 +0200
Message-ID: <20260930152435.843964230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit afe9021d63b46233f5c87d52b820fa26e7f562cd ]

When 3 monitors are connected through Thunderbolt dock to the system at
once, one of the monitors might fail to establish DisplayPort tunnel.
This happens during DP bandwidth negotiation - each monitor takes
maximum bandwidth that is supported and there might not be enough for
3rd display. In this case Thunderbolt driver drops DP tunnel and
'forgets' about it but with DP bandwidth allocation mode, that comes in
later, some bandwidth might be freed.

Make Thunderbolt driver check again if DP tunnel can be established
after DP bandwidth consumption changed.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index dc9b7aac45682..9a7208f1a2835 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2543,6 +2543,9 @@ static void tb_handle_dp_bandwidth_request(struct work_struct *work)
 
 		/* Update other clients about the allocation change */
 		tb_recalc_estimated_bandwidth(tb);
+
+		tb_dbg(tb, "checking if more DP tunnels can be established now\n");
+		tb_tunnel_dp(tb);
 	}
 
 put_sw:
-- 
2.53.0



