Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A241265630;
	Tue,  8 Apr 2025 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110857; cv=none; b=FplN9zb1EpxfSi4ok/cpEquOW8jr+sXFh+TZiEDO5z2foPzgZfWkUlUU89VJ9Y2heKXyjMb2ttgGY0u8JDBm8KUbmDXNqN0oZy9kH7QuvfRNN/Nh36YyRpfpgvmMN1FeXxic1ECgC+dCCayrm1RCUpKf2iNX+ATbUglQHwza5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110857; c=relaxed/simple;
	bh=yRnAcIF0WDo6bXT960nqB18hDlpOzT+LWUg2j+Or1fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cslpi/0QsVGAGwQMR8CfQyVENUODC0UwUj+kmSDF+7NAr6SRJtleDhkqPJPSqbw0ZuCFXC9qvbimyumxuV8MdTDjpY+OCv01BNLD2CraTRbJ/MDq91r0n0RBwcyfBmOiHSVrB8Phe30qCA5tcM/QbH5jK+OV6LzSFDYZRnP0OaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG79IeFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG79IeFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2773EC4CEE5;
	Tue,  8 Apr 2025 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110857;
	bh=yRnAcIF0WDo6bXT960nqB18hDlpOzT+LWUg2j+Or1fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YG79IeFYU8MLjq5U4DoZrchMKc8n2XhnaSfNM9wBhx/2VP991g2zkSckp5+HHl3TJ
	 Al1xyYrThG+pRy7NycA7P6rghojPaSMcIHPN6BIgoopQrTTrhlBXVhV/Cf9ZLf81BM
	 VQ+GsayTcIm0uwbHrVV6aHTEgE6eTNV/2nWeXOcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 221/731] renesas: reject PTP_STRICT_FLAGS as unsupported
Date: Tue,  8 Apr 2025 12:41:58 +0200
Message-ID: <20250408104919.420723314@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 51d58c0c7921d3c93c44099b90dc46720d095bde ]

The ravb_ptp_extts() function checks the flags coming from the
PTP_EXTTS_REQUEST ioctl, to ensure that future flags are not accepted on
accident.

This was updated to 'honor' the PTP_STRICT_FLAGS in commit 6138e687c7b6
("ptp: Introduce strict checking of external time stamp options.").
However, the driver does not *actually* validate the flags.

I originally fixed this driver to reject future flags in commit
592025a03b34 ("renesas: reject unsupported external timestamp flags"). It
is still unclear whether this hardware timestamps the rising, falling, or
both edges of the input signal.

Accepting requests with PTP_STRICT_FLAGS is a bug, as this could lead to
users mistakenly assuming a request with PTP_RISING_EDGE actually
timestamps the rising edge only.

Reject requests with PTP_STRICT_FLAGS (and hence all PTP_EXTTS_REQUEST2
requests) until someone with access to the datasheet or hardware knowledge
can confirm the timestamping behavior and update this driver.

Fixes: 6138e687c7b6 ("ptp: Introduce strict checking of external time stamp options.")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250312-jk-net-fixes-supported-extts-flags-v2-2-ea930ba82459@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_ptp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 6e4ef7af27bf3..b4365906669f3 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -179,8 +179,7 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	/* Reject requests with unsupported flags */
 	if (req->flags & ~(PTP_ENABLE_FEATURE |
 			   PTP_RISING_EDGE |
-			   PTP_FALLING_EDGE |
-			   PTP_STRICT_FLAGS))
+			   PTP_FALLING_EDGE))
 		return -EOPNOTSUPP;
 
 	if (req->index)
-- 
2.39.5



