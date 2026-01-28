Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DE523E358;
	Wed, 28 Jan 2026 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614367; cv=none; b=szSxYDewgF1O+aOpwZXg23DGrp2LCe/trNtTaBnKgr7mdRTkTx+5eMuLZrUimCq5Rn0ZceEKTOfjR/bN6FY/igQ4Veab38oo+tm7/pTRZ4MHwijOgONmD1sCpx9PCi24n1+IbovgEJOc4BlpXxllN3/RvMwEYpbGZhR/2NDa/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614367; c=relaxed/simple;
	bh=FiHB6+mYOqJikbsQ/BlK8w3YWwdjKimpP7y2wFywWCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac/tZl2T1o1TW54E5sOkgOqMeIhBRw6UlJ1vgqqG2zvrVrfLJvhSPP0pKwhRubBSQsupjSdsJVholj6vQKwcN4tpO+mmiIWvk/7T4Lr0fmexLYsRc0gSSVFH9TfseYJIQD6PvJLl8Up4kke8YwSuRMTPXsJdHBTmWK4qWKPSgrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEEG6B80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEEG6B80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F47C16AAE;
	Wed, 28 Jan 2026 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614367;
	bh=FiHB6+mYOqJikbsQ/BlK8w3YWwdjKimpP7y2wFywWCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEEG6B80mrnSF2riHAM3aQEoh0NlM+kHoM7GSCyF82chv2XHzHl0n4xuqj38IPfN3
	 6099NL+lv1s37slYwEQW9qeoi5gDBWY/pl6iVgvd3mki4Y6CGZ2IrQPB0aNDUOi430
	 QfxQKfnJzr73TSVymIroSf3ZuzRGMy5B0t9IkZVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.6 115/254] ice: initialize ring_stats->syncp
Date: Wed, 28 Jan 2026 16:21:31 +0100
Message-ID: <20260128145348.961720753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 8439016c3b8b5ab687c2420317b1691585106611 ]

The u64_stats_sync structure is empty on 64-bit systems. However, on 32-bit
systems it contains a seqcount_t which needs to be initialized. While the
memory is zero-initialized, a lack of u64_stats_init means that lockdep
won't get initialized properly. Fix this by adding u64_stats_init() calls
to the rings just after allocation.

Fixes: 2b245cb29421 ("ice: Implement transmit and NAPI support")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a6a290514e548..972c515d8789f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -396,6 +396,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(tx_ring_stats[i], ring_stats);
 		}
 
@@ -415,6 +417,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(rx_ring_stats[i], ring_stats);
 		}
 
-- 
2.51.0



