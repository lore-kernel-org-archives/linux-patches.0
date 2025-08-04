Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5343D69;
	Mon,  4 Aug 2025 00:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268062; cv=none; b=Y7CxzcuYUKkOaXys5rHA1DfYz/kHWklu1atj4E7BXmiy7hcTAy2J6s3Qr1QhcOIsvhzBRKI7+DB1x6zDVKa+9USeZEAMb5cP1wY4wYzmosxN/jzesalsAo4ZPa2T9nBtdScFpo2UEHC5ULgRy6UPRm1UrrY+mxCsEujn6Zuk9RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268062; c=relaxed/simple;
	bh=pMSqnSgppfWhCoAk0NCvhx/PNb0siTnkxu4FrA0M+Y0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tjidm68HZM5yTHznNDDK51rqA86Od+Vt2vNF0DdKPk4ojpR9EQFPNdUXW+mKAt7i0/n3bHTSVteURX/4+TxSFkrk8d8ebmH55+arsPZknSf7EDe5kNGKeWQLbPe+lYH0Qeah58coMjmwJT55RmVTfDfv1NE0IKcuBpNMQOgp3+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqzxJTTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqzxJTTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3610C4CEEB;
	Mon,  4 Aug 2025 00:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268061;
	bh=pMSqnSgppfWhCoAk0NCvhx/PNb0siTnkxu4FrA0M+Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqzxJTTRIPlH3gJdp862Dsqjnqy6NYBhaIN/uDp1/6N4BAOk32wAVvZsGNZjuzV2p
	 /kPgKXMqCdbRfirAy6UHb5lmnZSZuDH/tdn/M0GHWBsRlaV3BslUfkpY5zo2jESzGv
	 HDX140uam5ATQuPhq4XP0BIjLQcCmGkrx1VnVOSkhkCLWB4uInT9IOFL7VunJapZkg
	 z3/X8e0jehoy/osxhfzQjRbEB+wbUG2fSNjteZfPNoA1VhemQgNMtXxAZr6im71GQn
	 d9W8/oSczx8HP3PtfXm7P4b7BTU0cNEHY32saK/u2q05K+pYbd83wR6RLIYTZY4rqT
	 OuA5GmU+FrZEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jay Chen <shawn2000100@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/39] usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command
Date: Sun,  3 Aug 2025 20:40:09 -0400
Message-Id: <20250804004041.3628812-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Transfer-Encoding: 8bit

From: Jay Chen <shawn2000100@gmail.com>

[ Upstream commit f72b9aa821a2bfe4b6dfec4be19f264d0673b008 ]

There is a subtle contradiction between sections of the xHCI 1.2 spec
regarding the initialization of Input Endpoint Context fields. Section
4.8.2 ("Endpoint Context Initialization") states that all fields should
be initialized to 0. However, Section 6.2.3 ("Endpoint Context", p.453)
specifies that the Average TRB Length (avg_trb_len) field shall be
greater than 0, and explicitly notes (p.454): "Software shall set
Average TRB Length to '8' for control endpoints."

Strictly setting all fields to 0 during initialization conflicts with
the specific recommendation for control endpoints. In practice, setting
avg_trb_len = 0 is not meaningful for the hardware/firmware, as the
value is used for bandwidth calculation.

Motivation: Our company is developing a custom Virtual xHC hardware
platform that strictly follows the xHCI spec and its recommendations.
During validation, we observed that enumeration fails and a parameter
error (TRB Completion Code = 5) is reported if avg_trb_len for EP0 is
not set to 8 as recommended by Section 6.2.3. This demonstrates the
importance of assigning a meaningful, non-zero value to avg_trb_len,
even in virtualized or emulated environments.

This patch explicitly sets avg_trb_len to 8 for EP0 in
xhci_setup_addressable_virt_dev(), as recommended in Section 6.2.3, to
prevent potential issues with xHCI host controllers that enforce the
spec strictly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220033
Signed-off-by: Jay Chen <shawn2000100@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and code, here's my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug**: The commit addresses a specification compliance
   issue where setting `avg_trb_len = 0` for EP0 (control endpoint)
   violates the xHCI 1.2 specification. Section 6.2.3 explicitly states
   that Average TRB Length shall be greater than 0 and specifically
   recommends setting it to 8 for control endpoints.

2. **Small and contained fix**: The change is minimal - just adding a
   single line:
  ```c
  ep0_ctx->tx_info = cpu_to_le32(EP_AVG_TRB_LENGTH(8));
  ```
  This sets the average TRB length field to 8 as recommended by the
  spec.

3. **Prevents hardware failures**: The commit message indicates this
   causes actual enumeration failures with parameter errors (TRB
   Completion Code = 5) on hardware that strictly follows the xHCI
   specification. This means real devices can fail to enumerate without
   this fix.

4. **No architectural changes**: This is a simple initialization fix
   that doesn't change any architectural aspects of the driver. It only
   ensures proper initialization of a field that was previously left at
   0.

5. **Low regression risk**: Setting avg_trb_len to 8 for control
   endpoints follows the xHCI specification recommendation. Existing
   hardware that doesn't strictly check this value will continue to
   work, while hardware that does enforce the spec will now work
   correctly.

6. **Clear bug with clear fix**: The contradiction between spec sections
   is well-documented in the commit message, and the fix directly
   addresses this by following the more specific recommendation for
   control endpoints.

The commit fixes a specification compliance bug that can cause real
hardware failures during USB device enumeration. The fix is minimal,
follows the xHCI specification, and has very low risk of causing
regressions, making it an ideal candidate for stable backporting.

 drivers/usb/host/xhci-mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5b0e00978322..1874a81d9766 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1227,6 +1227,8 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 	ep0_ctx->deq = cpu_to_le64(dev->eps[0].ring->first_seg->dma |
 				   dev->eps[0].ring->cycle_state);
 
+	ep0_ctx->tx_info = cpu_to_le32(EP_AVG_TRB_LENGTH(8));
+
 	trace_xhci_setup_addressable_virt_device(dev);
 
 	/* Steps 7 and 8 were done in xhci_alloc_virt_device() */
-- 
2.39.5

