Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA64B374C4;
	Tue,  8 Apr 2025 11:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110862; cv=none; b=bFePhBGOPAEzt3OfrMKM9zO7B3Dna89y1jl5PlUavEIgnhsI8AN9aHK8fXo0fr8ENxB3E/0TKx2ple5ve9I9e1IHLQ3jeUmzVgT2tMxyg7czmdc3nD5UDcv/jUPunXKWLslnQzO0mcRLRuPD7IxMBsVxS/ry6bx1Nier169BI08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110862; c=relaxed/simple;
	bh=e1q5VnEyiUQllJq2QqB60NI3f+hg6P25Rb1e4oCAtUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/v3jBESqtrWSYY5+Cnbf3UyZOGzFhqdxWnxlbslr5zPmfmU1sjQ0GRuhHq6RI05YySQ13l8RgvOGBsCwG3gv0OdNh15eZB1bhc+9aYy1tQPTERprfymtcLLhLw8e3oFmh/0xragA9nucjici4XQgLcfG+2majFcwYCLKhdoSxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1clgNNTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1clgNNTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7CDC4CEE5;
	Tue,  8 Apr 2025 11:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110862;
	bh=e1q5VnEyiUQllJq2QqB60NI3f+hg6P25Rb1e4oCAtUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1clgNNTrK5CU8Wpbet1INZ2UGefxffA1jopzjqb6f9ddD1xppBBTMTis/WOQN/ZTL
	 J3s5rWvLNAMDhiUE6Cl6mzpYY+oy6ulTNPRIpPDP3dOhVaOSpFYdN2f79cj417ws+f
	 aO2PgCPE1SZnYbHt7LrSSqU3UBSRUKFZUf1T80Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 223/731] broadcom: fix supported flag check in periodic output function
Date: Tue,  8 Apr 2025 12:42:00 +0200
Message-ID: <20250408104919.468566238@linuxfoundation.org>
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

[ Upstream commit af2b428f7992c07b0767c9a3c341b54d9069542e ]

In bcm_ptp_perout_locked, the driver rejects requests which have
PTP_PEROUT_PHASE set. This appears to be an attempt to reject any
unsupported flags. Unfortunately, this only checks one flag, but does not
protect against PTP_PEROUT_ONE_SHOT, or any future flags which may be
added.

Fix the check to ensure that no flag other than the supported
PTP_PEROUT_DUTY_CYCLE is set.

Fixes: 7bfe91efd525 ("net: phy: Add support for 1PPS out and external timestamps")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250312-jk-net-fixes-supported-extts-flags-v2-4-ea930ba82459@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-ptp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm-phy-ptp.c b/drivers/net/phy/bcm-phy-ptp.c
index 208e8f561e069..eba8b5fb1365f 100644
--- a/drivers/net/phy/bcm-phy-ptp.c
+++ b/drivers/net/phy/bcm-phy-ptp.c
@@ -597,7 +597,8 @@ static int bcm_ptp_perout_locked(struct bcm_ptp_private *priv,
 
 	period = BCM_MAX_PERIOD_8NS;	/* write nonzero value */
 
-	if (req->flags & PTP_PEROUT_PHASE)
+	/* Reject unsupported flags */
+	if (req->flags & ~PTP_PEROUT_DUTY_CYCLE)
 		return -EOPNOTSUPP;
 
 	if (req->flags & PTP_PEROUT_DUTY_CYCLE)
-- 
2.39.5



