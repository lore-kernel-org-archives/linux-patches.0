Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3A335566;
	Thu, 28 May 2026 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999021; cv=none; b=uoSL+GGN2pMr20jX83ojvOf8mJAQQdGDwc7vGX7wULzmyApTRh3f5aSm7e+tiO8vpkzr1lQUHr5o4IwQr6Limz8EejQ23L1EijFHnEGO0ufI0/DEUbC2+Qnk1SC1HDPzktv7r/oHo2EAYrwBo7yjqja6d1mmyrEfZM3wUc2vCrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999021; c=relaxed/simple;
	bh=1iguIVk1R4sH2TCFL4dAx5dc8UGAAU9E0Bk0EjI/vHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbjvYdmYmb5L+UoWpWh3FCSlfFmM+3c8ey+MWlPPtXYEB54TjwlFYmPLvTtMspT+B8IQQdNRfqVCo6washLti2ZNxLpSAKOG+nAaeCEF+1sdTdccSL2pva5n/+fLXO+IgbTR4IVONrPL2IWrwuJF/nUW4ucxRp7KXIZUWhxCUwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/nXzPVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/nXzPVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCFC1F000E9;
	Thu, 28 May 2026 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999020;
	bh=S08I7WceO1PlrjIk3ObGyQqPs1kRBMWWKPE/U3hJrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/nXzPVeFDNKTnYb3lVCIHetWLbwrFWyqPEYPGitQihp+F6T/8+LjzmwNh65V5l1L
	 3f+9tgXOc5C2DIOz37Y0cqTip+UTWokZ9oQl30nuM4C/wONX7YMn7eBlaDa8kKxR54
	 Edce+HZEytPjWGXZtpgPgEsfie8KYy6k2sUmQQlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 380/461] igc: set tx buffer type for SMD frames
Date: Thu, 28 May 2026 21:48:29 +0200
Message-ID: <20260528194658.454129657@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 5acc641e590e008caaed480ed9ffae47cf7ecbdf ]

Sashiko pointed out that igc_fpe_init_smd_frame() initializes
igc_tx_buffer fields for an SMD skb, but does not set the buffer type:
https://sashiko.dev/#/patchset/20260415025226.114115-1-kohei%40enjuk.jp

Since igc_tx_buffer entries are reused, a stale XDP or XSK type can
remain and make TX completion use the wrong cleanup path.

Set the buffer type to IGC_TX_BUFFER_TYPE_SKB.

Fixes: 5422570c0010 ("igc: add support for frame preemption verification")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-9-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 02dd9f0290a34..52de2bcbadbec 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -34,6 +34,7 @@ static int igc_fpe_init_smd_frame(struct igc_ring *ring,
 		return -ENOMEM;
 	}
 
+	buffer->type = IGC_TX_BUFFER_TYPE_SKB;
 	buffer->skb = skb;
 	buffer->protocol = 0;
 	buffer->bytecount = skb->len;
-- 
2.53.0



