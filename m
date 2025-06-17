Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637062FA626;
	Tue, 17 Jun 2025 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179261; cv=none; b=QH6wR0pEV/o9Qz+YDa0tK5Ywy3qhKFG881JCZtOJlATM5xyKlwOmd09j6hiFqf2kcdpwAz0+TV6zj1OiV0fXunw7dyftVTpk7YPpw6vH6aD5UFb6zGT/LHhzn1BaxDn3hjIvS2kCc4ZeRGtAtEoac1/WO3D2oU5mHAFBJ5GSQ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179261; c=relaxed/simple;
	bh=+iiJAHBdMUvFqPXLqNOwr1D0pImetcAIXRVU9m2Odww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8XG3x8A9n64feeciJu9XCG8wEb2qb6n02MTD5/4fRC7IoUkmH5s55LjuQ/cpAfSSpF6TFqVjViMuxFu1QgifNIw7X9Z65HLZp7+wg8IsUx26yuy+1n6NPHSVY5NxEO+yHud/OJXWRTJWl6oRHotYuT5aS39t1OACOr2TtL+pr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkSmNMXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkSmNMXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BBDC4CEE3;
	Tue, 17 Jun 2025 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179261;
	bh=+iiJAHBdMUvFqPXLqNOwr1D0pImetcAIXRVU9m2Odww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkSmNMXTkWbhocSZo1dfw3v1bWPMyOUfdeSDK0hphMnfYBGWsWd7w/ff0LKohYwyW
	 rhrQsb58qnTL/K7hvsyz5WCa4Mxm7ITt/PflQ4TwG/7pmodXc+uF6Kgd5E2AnWr1Vs
	 BTvEvPzOLCiNyFwg7dmdDHi1tHD1yvk938DcFBQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Nadezhdin <anton.nadezhdin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.15 697/780] ice/ptp: fix crosstimestamp reporting
Date: Tue, 17 Jun 2025 17:26:45 +0200
Message-ID: <20250617152519.878420591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Nadezhdin <anton.nadezhdin@intel.com>

[ Upstream commit a5a441ae283d54ec329aadc7426991dc32786d52 ]

Set use_nsecs=true as timestamp is reported in ns. Lack of this result
in smaller timestamp error window which cause error during phc2sys
execution on E825 NICs:
phc2sys[1768.256]: ioctl PTP_SYS_OFFSET_PRECISE: Invalid argument

This problem was introduced in the cited commit which omitted setting
use_nsecs to true when converting the ice driver to use
convert_base_to_cs().

Testing hints (ethX is PF netdev):
phc2sys -s ethX -c CLOCK_REALTIME  -O 37 -m
phc2sys[1769.256]: CLOCK_REALTIME phc offset -5 s0 freq      -0 delay    0

Fixes: d4bea547ebb57 ("ice/ptp: Remove convert_art_to_tsc()")
Signed-off-by: Anton Nadezhdin <anton.nadezhdin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 1fd1ae03eb909..11ed48a62b536 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2307,6 +2307,7 @@ static int ice_capture_crosststamp(ktime_t *device,
 	ts = ((u64)ts_hi << 32) | ts_lo;
 	system->cycles = ts;
 	system->cs_id = CSID_X86_ART;
+	system->use_nsecs = true;
 
 	/* Read Device source clock time */
 	ts_lo = rd32(hw, cfg->dev_time_l[tmr_idx]);
-- 
2.39.5



