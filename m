Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44CF28C2C4;
	Tue, 22 Jul 2025 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192795; cv=none; b=FpIEwUij7APG8NEKHRMeGCftbQ85lsr72S0cnmSChdZLXVIiQDsBtdkGDrMTpzQQxzXhDrkSvPNEmcTB/Gt8YHY5Tt7wT4cyZQOLbrY4/2Eo5GBS0iRSKpjEf2Bv1svozLQUnYtitGuhXzke9p4eXpeD+6t1Yshg5h6lD4o8O3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192795; c=relaxed/simple;
	bh=fY9ZI/ttRs/fS1EE77PMMgAYBgZOYfHniQEs+8vYIX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2ehYcHyj9wdlBo57RsMewiFpXdqLHWK5ZMkqPSBl/8lAUtoCNnnLqWNgiyN49SKDrXhEKCzMISLdtNkuCyqrU2YAVOja+C20ntI5gnwXVr+K01ryY0NHxZnleylbJc54uZSezMR2sM+f3mL3lBBvqDZPaP7uvPUnuSBA0f8Tyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrm6QpzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrm6QpzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1065EC4CEF1;
	Tue, 22 Jul 2025 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192795;
	bh=fY9ZI/ttRs/fS1EE77PMMgAYBgZOYfHniQEs+8vYIX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrm6QpzKhAtZNu3P2o5J3G1tRc93Ejaa0Wm+xoiLEg3I08qqKXynDl9+nIPcbZMqo
	 CnfGXlGpbfqE9jm4Mdran5K+EENXewixtEN/k0pgjdaM1nanwgv5slHpayICp1GStk
	 +xfYsXBe4ZRZ/vru67xnq2agCsAvSX/6Ms/PmSdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus@blochl.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 058/158] net: stmmac: intel: populate entire system_counterval_t in get_time_fn() callback
Date: Tue, 22 Jul 2025 15:44:02 +0200
Message-ID: <20250722134342.908950132@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Blöchl <markus@blochl.de>

commit e6176ab107ec6e57a752a97ba9f7c34a23034262 upstream.

get_time_fn() callback implementations are expected to fill out the
entire system_counterval_t struct as it may be initially uninitialized.

This broke with the removal of convert_art_to_tsc() helper functions
which left use_nsecs uninitialized.

Initially assign the entire struct with default values.

Fixes: f5e1d0db3f02 ("stmmac: intel: Remove convert_art_to_tsc()")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Blöchl <markus@blochl.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250713-stmmac_crossts-v1-1-31bfe051b5cb@blochl.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -379,6 +379,12 @@ static int intel_crosststamp(ktime_t *de
 		return -ETIMEDOUT;
 	}
 
+	*system = (struct system_counterval_t) {
+		.cycles = 0,
+		.cs_id = CSID_X86_ART,
+		.use_nsecs = false,
+	};
+
 	num_snapshot = (readl(ioaddr + GMAC_TIMESTAMP_STATUS) &
 			GMAC_TIMESTAMP_ATSNS_MASK) >>
 			GMAC_TIMESTAMP_ATSNS_SHIFT;
@@ -394,7 +400,7 @@ static int intel_crosststamp(ktime_t *de
 	}
 
 	system->cycles *= intel_priv->crossts_adj;
-	system->cs_id = CSID_X86_ART;
+
 	priv->plat->flags &= ~STMMAC_FLAG_INT_SNAPSHOT_EN;
 
 	return 0;


