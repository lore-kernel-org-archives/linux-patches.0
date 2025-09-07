Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BA54315A;
	Sun,  7 Sep 2025 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277609; cv=none; b=us9q0LmdhqmheMGR7AjWMYHBq/M2oO60a9hKxb37gYQwq9QEPofGXmsoMCfWaqDXZmhxuzzzKaokN3OKB8jsAkNKa/mWihBwGqRATIQEUfHKYSN/Lem+MxID38cU32YgRnremH2kUo5TFNfqWedV82V4MqlWD/l6hydlTegzK+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277609; c=relaxed/simple;
	bh=BZW0VxspeSrWz+QopmwwzyqsmFgo9F6cOWgfn1ThB+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZrKocqJUycpvW9XdxTGt+HvvUc08pdseFzHuiaxe7CLf+c/Ohaq6vSkmZrqFqW1rIxQTxmjy8Bv7+PQmooY6Ne7qV4ONmEo2YFA5wU/nsm3CD8n4J6vFPQU6j0r1zEITnBWA+910SJS8DGzj1Jlvwi3c84uT74nMSPbmeL+GZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNynWODK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNynWODK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F342BC4CEF0;
	Sun,  7 Sep 2025 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277609;
	bh=BZW0VxspeSrWz+QopmwwzyqsmFgo9F6cOWgfn1ThB+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNynWODKJfbslnBfSJFZhooUXtXNHNqLyHfRq7UjI8a7HEg+3A/E66Pg212BBTzcm
	 P5HEznL22CoWGFJcBFPc8pgY3Ug731OnzjpyP7tm24ri3ZcXOHtVXCdB/oeaoFZ9Xf
	 gcnaEscv6m1lCwMpy1kMlAKLVvT0TX/i8UGVvKfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 066/183] ice: fix NULL access of tx->in_use in ice_ll_ts_intr
Date: Sun,  7 Sep 2025 21:58:13 +0200
Message-ID: <20250907195617.362824884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit f6486338fde3f04ed0ec59fe67a69a208c32734f ]

Recent versions of the E810 firmware have support for an extra interrupt to
handle report of the "low latency" Tx timestamps coming from the
specialized low latency firmware interface. Instead of polling the
registers, software can wait until the low latency interrupt is fired.

This logic makes use of the Tx timestamp tracking structure, ice_ptp_tx, as
it uses the same "ready" bitmap to track which Tx timestamps complete.

Unfortunately, the ice_ll_ts_intr() function does not check if the
tracker is initialized before its first access. This results in NULL
dereference or use-after-free bugs similar to the issues fixed in the
ice_ptp_ts_irq() function.

Fix this by only checking the in_use bitmap (and other fields) if the
tracker is marked as initialized. The reset flow will clear the init field
under lock before it tears the tracker down, thus preventing any
use-after-free or NULL access.

Fixes: 82e71b226e0e ("ice: Enable SW interrupt from FW for LL TS")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d42892c8c5a12..a34faa4894739 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3172,12 +3172,14 @@ static irqreturn_t ice_ll_ts_intr(int __always_unused irq, void *data)
 	hw = &pf->hw;
 	tx = &pf->ptp.port.tx;
 	spin_lock_irqsave(&tx->lock, flags);
-	ice_ptp_complete_tx_single_tstamp(tx);
+	if (tx->init) {
+		ice_ptp_complete_tx_single_tstamp(tx);
 
-	idx = find_next_bit_wrap(tx->in_use, tx->len,
-				 tx->last_ll_ts_idx_read + 1);
-	if (idx != tx->len)
-		ice_ptp_req_tx_single_tstamp(tx, idx);
+		idx = find_next_bit_wrap(tx->in_use, tx->len,
+					 tx->last_ll_ts_idx_read + 1);
+		if (idx != tx->len)
+			ice_ptp_req_tx_single_tstamp(tx, idx);
+	}
 	spin_unlock_irqrestore(&tx->lock, flags);
 
 	val = GLINT_DYN_CTL_INTENA_M | GLINT_DYN_CTL_CLEARPBA_M |
-- 
2.50.1



