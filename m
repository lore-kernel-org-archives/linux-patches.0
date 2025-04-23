Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D99429C334;
	Wed, 23 Apr 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422000; cv=none; b=EvWWVohMEwgCDnETXIFfWrRVIs/rZzKuMwOQuPuGKZYs9hWykHWk4RnIAhCmcFblpSy8SumO+tJS5OHX0geKKWE/Qemz8Od48YKvVm4N1ALIzxYpkX4p0AIkPFpnc9Go8To5SgNcXt10WQHwlJmZ5MKd0H/Kl1LhWk4jmGLvrks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422000; c=relaxed/simple;
	bh=xztWfE4kLQObHW9V7CD2CpYnXMziOBWkp5ef3bYbjRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfnvWbzrqyJ8Wx7vUgn0KQyfvwypxiOYIgU/mk08Z6FFbp+G3ghkFAjGJJXrTHOELWmxbD0E2Yo+mqBF29tOODEbXVEYsup35CJeyYHr9Siyn4uoiDERnBOIDdL9741zTy+e8XuedV1IHywxOWCY1mbJHc9gXgKnTZ/AjFZkzBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euCRuUUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euCRuUUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94150C4CEE2;
	Wed, 23 Apr 2025 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421999;
	bh=xztWfE4kLQObHW9V7CD2CpYnXMziOBWkp5ef3bYbjRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euCRuUUaGF03BEa1K3XrcUSpZRasCXPkwLlWsyCs1FCZmK371k1NLIYpDK7xCGtnt
	 98ol2QQ7geKf4llmOoZS8kp+kbC42jKAjWos1Uij1RflkuhkELBVHOQ09wFwGU8b85
	 24dHGWZUe2c5Q6JgSuYM651Er5IuyHpMP9fQYZm4=
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
Subject: [PATCH 6.6 260/393] igc: increase wait time before retrying PTM
Date: Wed, 23 Apr 2025 16:42:36 +0200
Message-ID: <20250423142654.109975003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit 714cd033da6fea4cf54a11b3cfd070afde3f31df ]

The i225/i226 hardware retries if it receives an inappropriate response
from the upstream device. If the device retries too quickly, the root
port does not respond.

The wait between attempts was reduced from 10us to 1us in commit
6b8aa753a9f9 ("igc: Decrease PTM short interval from 10 us to 1 us"), which
said:

  With the 10us interval, we were seeing PTM transactions take around
  12us. Hardware team suggested this interval could be lowered to 1us
  which was confirmed with PCIe sniffer. With the 1us interval, PTM
  dialogs took around 2us.

While a 1us short cycle time was thought to be theoretically sufficient, it
turns out in practice it is not quite long enough. It is unclear if the
problem is in the root port or an issue in i225/i226.

Increase the wait from 1us to 4us. Increasing to 2us appeared to work in
practice on the setups we have available. A value of 4us was chosen due to
the limited hardware available for testing, with a goal of ensuring we wait
long enough without overly penalizing the response time when unnecessary.

The issue can be reproduced with the following:

$ sudo phc2sys -R 1000 -O 0 -i tsn0 -m

Note: 1000 Hz (-R 1000) is unrealistically large, but provides a way to
quickly reproduce the issue.

PHC2SYS exits with:

"ioctl PTP_OFFSET_PRECISE: Connection timed out" when the PTM transaction
  fails

Fixes: 6b8aa753a9f9 ("igc: Decrease PTM short interval from 10 us to 1 us")
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
 drivers/net/ethernet/intel/igc/igc_defines.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 2a84beaf5e680..cf8b5ac51caaa 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -562,7 +562,10 @@
 #define IGC_PTM_CTRL_SHRT_CYC(usec)	(((usec) & 0x3f) << 2)
 #define IGC_PTM_CTRL_PTM_TO(usec)	(((usec) & 0xff) << 8)
 
-#define IGC_PTM_SHORT_CYC_DEFAULT	1   /* Default short cycle interval */
+/* A short cycle time of 1us theoretically should work, but appears to be too
+ * short in practice.
+ */
+#define IGC_PTM_SHORT_CYC_DEFAULT	4   /* Default short cycle interval */
 #define IGC_PTM_CYC_TIME_DEFAULT	5   /* Default PTM cycle time */
 #define IGC_PTM_TIMEOUT_DEFAULT		255 /* Default timeout for PTM errors */
 
-- 
2.39.5



