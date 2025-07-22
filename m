Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFB32ED14B;
	Tue, 22 Jul 2025 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193383; cv=none; b=Mv0URFtZQLsldbQsAuuX+GOlPDtsY9ZQ7ECRxFK1aG2ip9e0IFA+kYt/8YJf3lK2c5oJps6cd/sCaVgqN8M/3EFR8Y1JWb3hkn6I9KpcCGQ8KlYf9sVX6keE+WI1tH6u9HstJUgwt437g/uPSipci9KPJyGpabunzE5JdrOTdEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193383; c=relaxed/simple;
	bh=mnTKtQkJdynSk0q3MxANx9v+4v2c2G23g9g3z3zoUmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBPZLEQkJSlpVepeFrmKoaN7ft1TS0Y1VIB78gPFWAWNBlOux8GK14+C4WBwOqrDp6Xt/NHXAl3zmrd90HVQLFfKAMZShtVbwP2u2EslBs8RbIFetsPwXOiaomEgMLLHj+YmOepxi608NI0WS2z/gdWSaqdactvG/yUg+dlckzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wijFaw0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wijFaw0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D979DC4CEF9;
	Tue, 22 Jul 2025 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193383;
	bh=mnTKtQkJdynSk0q3MxANx9v+4v2c2G23g9g3z3zoUmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wijFaw0QIJcG3qvMbliK2/fudoZFG/jec72PY+Ru+aeLoDO3Iym41gLT+0IZ6h+yW
	 QHvHvi5hzMJ27y2gm42LEYUXy5z3sHDtk9W5uZ0EVFPuuT+qwY4b/g9oDlbhNA8n9q
	 35dvz/j5zkCSXKUWx0QoLUx10gwkuY6wDqXcrehs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus@blochl.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 068/187] net: stmmac: intel: populate entire system_counterval_t in get_time_fn() callback
Date: Tue, 22 Jul 2025 15:43:58 +0200
Message-ID: <20250722134348.274619009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,6 +433,12 @@ static int intel_crosststamp(ktime_t *de
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
@@ -448,7 +454,7 @@ static int intel_crosststamp(ktime_t *de
 	}
 
 	system->cycles *= intel_priv->crossts_adj;
-	system->cs_id = CSID_X86_ART;
+
 	priv->plat->flags &= ~STMMAC_FLAG_INT_SNAPSHOT_EN;
 
 	return 0;


