Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C439265CAD;
	Tue, 25 Mar 2025 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905589; cv=none; b=Sa8xH+N0+Im8sCrqTJ9pdhveDjhE/IW8pVrr6YK4f3/AnR6ETdXbxJd2e094hUhY2m473yB6g/pVrNfA31UFYFYtDO50laOYcfr9kvrhugndAJYQcXVBgLBM34/neVP6VW6ARvWxxHSlRqw7G1x60u+xkFcuooMuOTsSAjTm+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905589; c=relaxed/simple;
	bh=w6GFT7a00If2IArktORgzzHuDH9heKiST7QRLfYWQvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1xRzpDl5xj2vO2JJPij3GbFmZHiQ8IpHPrRJCblBKa+rffvGkYVnxfwSk3X6+wQFstjkP1ljLv6hYJREgUNKpmUxM5Bz1eRka+/S+VLZqBLQwUOJ0rlWz7IKil/pochY5QDRLSkOmp/9/tgkXQDwpblNkcHtffwS/O+DvvqdoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/G7A+9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/G7A+9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4BBC4CEED;
	Tue, 25 Mar 2025 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905589;
	bh=w6GFT7a00If2IArktORgzzHuDH9heKiST7QRLfYWQvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/G7A+9Bh5uHPi9gzzTvq9PUVwE6ckNW9tZBQtnXoNZjGSBUck3UyUD/LuduouXZL
	 SXoSzAXjwVnldFDLlz3QWsBUbu+9JW/vSRKsIkH+Grf5FHulFHFqQSsLX45UJdBQhZ
	 +CnFbO5k+5yLHG31f0Y5lWuA0gjojNGPIUYFgBz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Loic Poulain <loic.poulain@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/198] net: wwan: mhi_wwan_mbim: Silence sequence number glitch errors
Date: Tue, 25 Mar 2025 08:20:19 -0400
Message-ID: <20250325122158.130184760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 0d1fac6d26aff5df21bb4ec980d9b7a11c410b96 ]

When using the Qualcomm X55 modem on the ThinkPad X13s, the kernel log is
constantly being filled with errors related to a "sequence number glitch",
e.g.:

	[ 1903.284538] sequence number glitch prev=16 curr=0
	[ 1913.812205] sequence number glitch prev=50 curr=0
	[ 1923.698219] sequence number glitch prev=142 curr=0
	[ 2029.248276] sequence number glitch prev=1555 curr=0
	[ 2046.333059] sequence number glitch prev=70 curr=0
	[ 2076.520067] sequence number glitch prev=272 curr=0
	[ 2158.704202] sequence number glitch prev=2655 curr=0
	[ 2218.530776] sequence number glitch prev=2349 curr=0
	[ 2225.579092] sequence number glitch prev=6 curr=0

Internet connectivity is working fine, so this error seems harmless. It
looks like modem does not preserve the sequence number when entering low
power state; the amount of errors depends on how actively the modem is
being used.

A similar issue has also been seen on USB-based MBIM modems [1]. However,
in cdc_ncm.c the "sequence number glitch" message is a debug message
instead of an error. Apply the same to the mhi_wwan_mbim.c driver to
silence these errors when using the modem.

[1]: https://lists.freedesktop.org/archives/libmbim-devel/2016-November/000781.html

Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250212-mhi-wwan-mbim-sequence-glitch-v1-1-503735977cbd@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index ef70bb7c88ad6..43c20deab3189 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -209,7 +209,7 @@ static int mbim_rx_verify_nth16(struct mhi_mbim_context *mbim, struct sk_buff *s
 	if (mbim->rx_seq + 1 != le16_to_cpu(nth16->wSequence) &&
 	    (mbim->rx_seq || le16_to_cpu(nth16->wSequence)) &&
 	    !(mbim->rx_seq == 0xffff && !le16_to_cpu(nth16->wSequence))) {
-		net_err_ratelimited("sequence number glitch prev=%d curr=%d\n",
+		net_dbg_ratelimited("sequence number glitch prev=%d curr=%d\n",
 				    mbim->rx_seq, le16_to_cpu(nth16->wSequence));
 	}
 	mbim->rx_seq = le16_to_cpu(nth16->wSequence);
-- 
2.39.5



