Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FE31A08A6;
	Wed, 23 Apr 2025 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419655; cv=none; b=ONj5E4RFeky2Ou2e9Z9bhK0v9WYNmGG8EPuOalV/Z77GVJxOIoW/Ky711eSCreqPf9cwH6yTtf9JMN94ZAKkKunPoVZC5CrBOSRxg8v9M1H36wYPSIrFioSANmsY6HcFmh20GIG7FKlauq0YE3SSCLbYbG5naJi7P+qUPeuChxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419655; c=relaxed/simple;
	bh=adEQXxJiIhiAyc+L1PqiW8nnfvkeagTNWXvCidAzcX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmEPHn2lhQ+iZrp9TDWXiXkTxZPzKHavXN35Ymeqeg/pKtk9SLdhv3VTpQACD4aCN4lGWcuYBgfz9Gt6lnxIzvI1azK8Aye57NOZ5dmsxyFV9rBInpGd7UvgHbnZ3rG5PknQMdzBsHs7wmSGxw0SsJrYqKDH7TtqTNEEFLGRwkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ho3RAOF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ho3RAOF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2681C4CEE2;
	Wed, 23 Apr 2025 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419655;
	bh=adEQXxJiIhiAyc+L1PqiW8nnfvkeagTNWXvCidAzcX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ho3RAOF49TBScEDJSqp0h9z9DCoJtQfBtT2pLxiRvI83Kc54rGtDM+z2t3kVaLuTO
	 Qp8Ji/FSDwwMfGAWm8Hfzwtb2/DbnDuH7zr5w3MZwbQJxjqiE9+oY0xfIJ1NbLt4d5
	 5otYqDCnSNCSfoUxZ5lxzj3+38xEzYDis4uODeTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Christopher S M Hall <christopher.s.hall@intel.com>,
	Corinna Vinschen <vinschen@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/223] igc: move ktime snapshot into PTM retry loop
Date: Wed, 23 Apr 2025 16:41:47 +0200
Message-ID: <20250423142618.555808318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit cd7f7328d691937102732f39f97ead35b15bf803 ]

Move ktime_get_snapshot() into the loop. If a retry does occur, a more
recent snapshot will result in a more accurate cross-timestamp.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Christopher S M Hall <christopher.s.hall@intel.com>
Reviewed-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index c640e346342be..516abe7405dee 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1011,16 +1011,16 @@ static int igc_phc_get_syncdevicetime(ktime_t *device,
 	int err, count = 100;
 	ktime_t t1, t2_curr;
 
-	/* Get a snapshot of system clocks to use as historic value. */
-	ktime_get_snapshot(&adapter->snapshot);
-
+	/* Doing this in a loop because in the event of a
+	 * badly timed (ha!) system clock adjustment, we may
+	 * get PTM errors from the PCI root, but these errors
+	 * are transitory. Repeating the process returns valid
+	 * data eventually.
+	 */
 	do {
-		/* Doing this in a loop because in the event of a
-		 * badly timed (ha!) system clock adjustment, we may
-		 * get PTM errors from the PCI root, but these errors
-		 * are transitory. Repeating the process returns valid
-		 * data eventually.
-		 */
+		/* Get a snapshot of system clocks to use as historic value. */
+		ktime_get_snapshot(&adapter->snapshot);
+
 		igc_ptm_trigger(hw);
 
 		err = readx_poll_timeout(rd32, IGC_PTM_STAT, stat,
-- 
2.39.5



