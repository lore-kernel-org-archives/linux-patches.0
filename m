Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B5985270;
	Wed,  7 Aug 2024 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043191; cv=none; b=Zr7/roSYxz9kx99I7oyNBvx2iNbEENlmqJzQpISb/ebX8Nttj5N1TF43TANbTUS1QMF1HBnXA/rbW63D26DlaSX1SgqyvXPQPR9CPLF11W0cf8VMR0nwYbjnbeTf3UtDYAywebL8sA6Ka1TeEU8yMOhdTeMojjmj4ELJB0v5cKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043191; c=relaxed/simple;
	bh=cVdY1qIlcVQYI50A4SA83wnZ9V9nbMeOHg+cpaOfAMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMRsMaVaHgQ7h16TDLN57JPnCD1KVpe6OIBPYr6gBeiCKsZvkT9AQ1Y9VwSs8EsyUx/a4OzukaD1i7KPqnjUHDDysSgPjlYUlNlaTgSoOpVeVULJX91GPv5Vhs4+zmln27UxUZjuhSXg8Pb9X2jBUkUwGXZnAGEMACN3tq2OgRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH2YRi7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH2YRi7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E94C32781;
	Wed,  7 Aug 2024 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043191;
	bh=cVdY1qIlcVQYI50A4SA83wnZ9V9nbMeOHg+cpaOfAMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VH2YRi7dQW1Mbs8NLKS/FRK6Zwo4KZE7kZ6KOpW1Gj8jHGfQZA+Lmd3ZP7Nq3nz0D
	 7V2kOYoke9g7wGetahZyC5yw7BNHWMbA3K4emM7wABLTqX+hbE6Cj+Pz8+uAo5/wrx
	 hq4muPZQqw/uUi/K6N6DNa1RzCInqJ+Wi30P7Ctg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.10 105/123] wifi: ath12k: fix soft lockup on suspend
Date: Wed,  7 Aug 2024 17:00:24 +0200
Message-ID: <20240807150024.251423826@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit a47f3320bb4ba6714abe8dddb36399367b491358 upstream.

The ext interrupts are enabled when the firmware has been started, but
this may never happen, for example, if the board configuration file is
missing.

When the system is later suspended, the driver unconditionally tries to
disable interrupts, which results in an irq disable imbalance and causes
the driver to spin indefinitely in napi_synchronize().

Make sure that the interrupts have been enabled before attempting to
disable them.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org	# 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20240709073132.9168-1-johan+linaro@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -472,7 +472,8 @@ static void __ath12k_pci_ext_irq_disable
 {
 	int i;
 
-	clear_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
+	if (!test_and_clear_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags))
+		return;
 
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];


