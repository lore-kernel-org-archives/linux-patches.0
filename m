Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D336228CA5;
	Mon,  2 Jun 2025 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877199; cv=none; b=jNru3Fim0YRe+aN104WJ0Ksm1itlTseHLOXEhENET6dtkmUpnOY5Hy0Gc0kaIYxYNUWRd2Qhg6HS9zcll0SqT8HqH6oRy26DFWmjJrJAndCxUVgoDodtYHocg4UCHaE9bsDAqINPsu1G1/4ydSMPciv7mh+0aGjf3lAMaT7gEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877199; c=relaxed/simple;
	bh=Ubpzr/p84I9E+mJQIQWEKk59IvHPEn/Fr6WlJx2NgDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikA1Zmvqmj20uQzQZKrgF1kehoTJMU32luaPWeVRf4hZ4560MZgl0VuI5JEBVx1/AwUOfEKgm5b5lZS09jhaPql7hrTergufUfJvcIzk/EwQ8johHVEz/5vaoBWHJxPnpiy7A1iQq+9kXozVh7yteajKPE3zttn1GbH9X8s+wJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eupp8r5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eupp8r5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7987C4CEEB;
	Mon,  2 Jun 2025 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877199;
	bh=Ubpzr/p84I9E+mJQIQWEKk59IvHPEn/Fr6WlJx2NgDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eupp8r5J5UqwbSE/RFef07i+4YwwFk0ptgBz7cHSTCBDxlZhBr2+Y4NRUMUVU1tA4
	 5fPSp1MDPFufJRz0WUxcgzGJzL/RWuqz8Iz0OeXG8fg53wMyUes1hm7ulqrUB4FdDs
	 i8Oa+7u/r6RfWypVEKyRJCe6NaLxH0nHUgkTRCwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/325] ice: count combined queues using Rx/Tx count
Date: Mon,  2 Jun 2025 15:47:57 +0200
Message-ID: <20250602134327.965247771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit c3a392bdd31adc474f1009ee85c13fdd01fe800d ]

Previous implementation assumes that there is 1:1 matching between
vectors and queues. It isn't always true.

Get minimum value from Rx/Tx queues to determine combined queues number.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a163e7717a534..1f62d11831567 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3373,8 +3373,7 @@ static u32 ice_get_combined_cnt(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
-		if (q_vector->rx.rx_ring && q_vector->tx.tx_ring)
-			combined++;
+		combined += min(q_vector->num_ring_tx, q_vector->num_ring_rx);
 	}
 
 	return combined;
-- 
2.39.5



