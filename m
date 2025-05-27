Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C470831;
	Tue, 27 May 2025 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365693; cv=none; b=jR+C992dbQdlV+2jIALmrglyw2sSBbW8gCz1iZNW/BzzNGyDjWc0HsQZXUuplcdd5G2cEL3PvmrdE9Ch+M5VBjt4i897f8eHD+Q1wzqcsyF4r/AoFo6O6UHX+BimW93bmbvpeUV/aSh7+Vn/wLXghRAINTIDhaQ+D2tlMiBN1Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365693; c=relaxed/simple;
	bh=a1Qc5RSVs2Q0Y8P5AL/HZNKs3ZjbMRz3oKBYPTI4RQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ms3N4VqQci9kZevPS8Vr2FW0eY702dt6pcPLl4PP68QWLr4kDzMpsVvlOfF9+JRFyGzofQ+Ve7I360QIS6wGSPz/NWX6nlUAgHkU2C3cBU+Ju2tFHP3GeORiNwiS8QDb7PzR5FMa6b8ShhXQSF3J0zv74ebb/jLUpjJNchlnTKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUOTFh17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUOTFh17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF105C4CEE9;
	Tue, 27 May 2025 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365693;
	bh=a1Qc5RSVs2Q0Y8P5AL/HZNKs3ZjbMRz3oKBYPTI4RQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUOTFh17kA8ssPyW84JyqtQGQHpxFTtH3fm+k0+c9+7UJ0bFuZsjl7DKEKNCfIyle
	 gyGtWiVSxXcGraRNVAnY/vIq4lJLSbwztk1hFnpOBjdEzx+ZmfkunNzHL1uX0AkhYY
	 IeJMMVeyA0y76gk788h4PhYSu/XWO0muI8rY0sc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/626] ice: count combined queues using Rx/Tx count
Date: Tue, 27 May 2025 18:25:52 +0200
Message-ID: <20250527162503.641880691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d1feeb317be3..2a2acbeb57221 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3817,8 +3817,7 @@ static u32 ice_get_combined_cnt(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
-		if (q_vector->rx.rx_ring && q_vector->tx.tx_ring)
-			combined++;
+		combined += min(q_vector->num_ring_tx, q_vector->num_ring_rx);
 	}
 
 	return combined;
-- 
2.39.5



