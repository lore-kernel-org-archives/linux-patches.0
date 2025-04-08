Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E1525FA04;
	Tue,  8 Apr 2025 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110855; cv=none; b=HEdaLDQf+nn3zFiUnAgXprb88AKOktoiqEUNkFVc0poAlblGoKOYUw1a/4c5o921AjcxT3IWxt4tcN7HOVOQy4FK9A5W+yq7j2sL12KZrxYNV91Uzwr8NZFPHD6Ybj4b5vihsk1QIoaNXdjkda6qYuuvUWXrs7bwG3sYGLkP/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110855; c=relaxed/simple;
	bh=7LrGV1EQgEmIEf+jXIg1MKOVb6vo9A8baLFEy586G4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdxCrykK0EMQx3VOrw57M1yXOFHdYHjQBaUlriNF5UGtjQWUiX67FUaIL93PGWyOJ0PJE81WvTVk3s6BZyYpFEmNkGMWEO8Ykm9fZ+0qeqHRjUiH9FjmVVbeBK644yRLRZDQtjqO5RhpgaWeigDNQ+lqLXn9+MtmbnCs89sMa8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACFGk9gI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACFGk9gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F977C4CEE5;
	Tue,  8 Apr 2025 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110854;
	bh=7LrGV1EQgEmIEf+jXIg1MKOVb6vo9A8baLFEy586G4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACFGk9gIBGuDRV/TtM4imiytkYUxhAPzYKiswPsD+7WkL7YWutRvyHdLRmNyxvGHP
	 5mu2syMRqJHQ+vZCxkryTpxz+XqHUK2bS0im3rQrHA79B6zPghJJoAaxVAqdPlkiIp
	 MOX6RWECc0FtsQxmotkYgNCaW/mZLDmkW+x1UZPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 220/731] igb: reject invalid external timestamp requests for 82580-based HW
Date: Tue,  8 Apr 2025 12:41:57 +0200
Message-ID: <20250408104919.398415446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 5eada2aabf13dcc4574b0a281b963b8cc55a52cc ]

The igb_ptp_feature_enable_82580 function correctly checks that unknown
flags are not passed to the function. However, it does not actually check
PTP_RISING_EDGE or PTP_FALLING_EDGE when configuring the external timestamp
function.

The data sheet for the 82580 product says:

  Upon a change in the input level of one of the SDP pins that was
  configured to detect Time stamp events using the TSSDP register, a time
  stamp of the system time is captured into one of the two auxiliary time
  stamp registers (AUXSTMPL/H0 or AUXSTMPL/H1).

  For example to define timestamping of events in the AUXSTMPL0 and
  AUXSTMPH0 registers, Software should:

  1. Set the TSSDP.AUX0_SDP_SEL field to select the SDP pin that detects
     the level change and set the TSSDP.AUX0_TS_SDP_EN bit to 1.

  2. Set the TSAUXC.EN_TS0 bit to 1 to enable timestamping

The same paragraph is in the i350 and i354 data sheets.

The wording implies that the time stamps are captured at any level change.
There does not appear to be any way to only timestamp one edge of the
signal.

Reject requests which do not set both PTP_RISING_EDGE and PTP_FALLING_EDGE
when operating under PTP_STRICT_FLAGS mode via PTP_EXTTS_REQUEST2.

Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250312-jk-net-fixes-supported-extts-flags-v2-1-ea930ba82459@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index f945705561200..f323e1c1989f1 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -509,6 +509,12 @@ static int igb_ptp_feature_enable_82580(struct ptp_clock_info *ptp,
 					PTP_STRICT_FLAGS))
 			return -EOPNOTSUPP;
 
+		/* Both the rising and falling edge are timestamped */
+		if (rq->extts.flags & PTP_STRICT_FLAGS &&
+		    (rq->extts.flags & PTP_ENABLE_FEATURE) &&
+		    (rq->extts.flags & PTP_EXTTS_EDGES) != PTP_EXTTS_EDGES)
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
 					   rq->extts.index);
-- 
2.39.5



