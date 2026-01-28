Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B42F745C;
	Wed, 28 Jan 2026 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615479; cv=none; b=pjuNSAWRjOKfMfGwzDVrpIMmr2O+i85CdRFuJ4tEmIjIzkNnsRabOViT8pieEpgXQ966ajXazYYOIIWdQ7LmZWh8dFagBDHS3Js6t3d1upoefBCReayB+IzMziBuxMUEu3vENmLg3u6zjof6zI1J9KuUDBzV7SaVSome5JpbRlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615479; c=relaxed/simple;
	bh=wozlRA2EAFJzsPGoj9y+sgQf//51T0ETdrvnbN2M5Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM8mQ+pswfn3NlX2yKSXdx5JTXSabDWPW9caDGL+8zD3hhiJR3pmlmLB26gVztJOWprS//MNN9pbKZutYZml8ZYbV8RE7L4Kl6grh/4mGE3gjc/7umh10Z1MVT6T1wTp+eCoYfqw5IZBb5wSKG3z0/G1Vd1jsHKEyZOASSqK44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmsvJwoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmsvJwoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7FCC116C6;
	Wed, 28 Jan 2026 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615479;
	bh=wozlRA2EAFJzsPGoj9y+sgQf//51T0ETdrvnbN2M5Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmsvJwoJtPGNwoSz+Nw/8Y+om4RfRRXvJK9iKhsMmxZvWIF1IDxKYOdqWrG2fvXZY
	 EekzVrikQo4ptQZq4JJyNbvkuOKFGit/ui4Q9WXxJnRsl7oIzPBW4PABNeDCdi8dwK
	 FJUqnvXwWCQyzSosjhyL7Kb6f0WkNIQXXmLa1N1A=
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
Subject: [PATCH 6.18 021/227] ice: initialize ring_stats->syncp
Date: Wed, 28 Jan 2026 16:21:06 +0100
Message-ID: <20260128145345.105545245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4479c824561e9..c0d221d4b4f47 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -398,6 +398,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(tx_ring_stats[i], ring_stats);
 		}
 
@@ -417,6 +419,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(rx_ring_stats[i], ring_stats);
 		}
 
-- 
2.51.0



