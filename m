Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FD33F9D2;
	Tue, 12 Aug 2025 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023038; cv=none; b=dJdcB8bvJ17W+xK6OHpjXFXoXL8PNislL1dgZYmcJStYppsJ8GbpeJ/6cQmQS4LRptbRnC245w5ZGDr4DJ6psXRtuPt7JQDX+Yb5gQ38YcU+pan3EFv4h7ZVaR3iQQ0Jq6RkIyYKjVuByWOjokKGgc9KMcKXEDWyUSVV8kMYYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023038; c=relaxed/simple;
	bh=pfkXZoRlE0JU1nPdnKwf0cRyFXMcO4U2N9gWATePm2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OcwJJymfcZSvx8Phs3tpKS98QQZVOB0QLO7cCcM0zmhSuIsLYMhVq/gtq7uHDxF3Aa8QxU38rw1cv5p12izV6RlxABMvVN/ET1F5ohjnY+9Bwpee9ozkWCTaLH8JiS9nJT/RV6UTEcWgm+IzCzRJ5ELd+LuZ4JyHkWTbiHQih/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8/uQTQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8/uQTQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E14C4CEF7;
	Tue, 12 Aug 2025 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023038;
	bh=pfkXZoRlE0JU1nPdnKwf0cRyFXMcO4U2N9gWATePm2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8/uQTQ84jMVbfYqzlkOqlOZ8Q2J9TeVPEcMmIZrjMQlbcGyT1OqmhcfQVHQtOYmt
	 6JNPI5fgykCdOpPNqBoS5MPvNe11l79e7vmfpFVBUfdyAToCvH4lfhkR7y2e4PF4Au
	 wGyX+X5CGvAWhFtDqRyx3w2UhOASAmNMBZ36+RdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Nadezhdin <anton.nadezhdin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	=?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus@blochl.de>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 332/369] ice/ptp: fix crosstimestamp reporting
Date: Tue, 12 Aug 2025 19:30:29 +0200
Message-ID: <20250812173029.196986272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Nadezhdin <anton.nadezhdin@intel.com>

commit a5a441ae283d54ec329aadc7426991dc32786d52 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Markus Blöchl <markus@blochl.de>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2226,6 +2226,7 @@ ice_ptp_get_syncdevicetime(ktime_t *devi
 			hh_ts = ((u64)hh_ts_hi << 32) | hh_ts_lo;
 			system->cycles = hh_ts;
 			system->cs_id = CSID_X86_ART;
+			system->use_nsecs = true;
 			/* Read Device source clock time */
 			hh_ts_lo = rd32(hw, GLTSYN_HHTIME_L(tmr_idx));
 			hh_ts_hi = rd32(hw, GLTSYN_HHTIME_H(tmr_idx));


