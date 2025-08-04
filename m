Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F3F1F12E9;
	Mon,  4 Aug 2025 00:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267949; cv=none; b=MPeMxS0WyoyHjy+7viZYKwxMCfG3CBYjvx8u1SyPssmkQV4/244iYPvJGQ293B+LbViWEmejOV8UTEimEAyrzUw3D3ZL7InY45q3Wm4JRryqiEYPb7tFuJq8jFG6x4s+LsPna3sPzDH6JUApDKd8GlANl7K+pI1DggCzEEyn9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267949; c=relaxed/simple;
	bh=vn5B/nlYeIT/KGZ2Ot9hFMcviyAq9HQ6SdWYMh0Hhj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MtHJnJofSR/Glql//oTbUOl3H9+DYH3SPd3rvWtWt6Nhmo24aVytnJLbrKb1sZu2VUAt16wXcrT+qSAE/letPRMaoUkEZSiWgTZPPT1jYJpqP/76w21it8Y/4rfD9EYEvjJclOh7L3KiHNlXfO/q876J6qpRqmQirejP25D2qm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfYhCN40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfYhCN40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8797C4CEF0;
	Mon,  4 Aug 2025 00:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267949;
	bh=vn5B/nlYeIT/KGZ2Ot9hFMcviyAq9HQ6SdWYMh0Hhj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfYhCN40PHdyMhgd4/lF/2Smvj7epHtU0554a4o7uj/BF5VQC4dXjREbcEbOFY5HM
	 cDoIW086nEA9EFdIrIT+4f+EH3RUZdop7scyhhceDl7Q+pVwxv7Ew5jiHp7YL4h0YD
	 VV/4emdDJVtCncI3FgYrF7r3WWXANSuQ2HqHlQ+N4gRmB8y3Fw6GoykVnVdvOrQExT
	 deL/1QUuMuchefuQBC/QSoggZobbFy24SmJtQJXM6/LuFln7CjRR6R1XpwolHOyb4C
	 AJ5nDD07NDLxyQ6mJW9nbU7Em/kkoLXXvu0ySlru+B0wHnvM8kKFgwuZellQ8cNgI/
	 Z1BObwBq6gaQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jay Chen <shawn2000100@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/44] usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command
Date: Sun,  3 Aug 2025 20:38:12 -0400
Message-Id: <20250804003849.3627024-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003849.3627024-1-sashal@kernel.org>
References: <20250804003849.3627024-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
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
index 149128b89100..43cbaadf933d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1209,6 +1209,8 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 	ep0_ctx->deq = cpu_to_le64(dev->eps[0].ring->first_seg->dma |
 				   dev->eps[0].ring->cycle_state);
 
+	ep0_ctx->tx_info = cpu_to_le32(EP_AVG_TRB_LENGTH(8));
+
 	trace_xhci_setup_addressable_virt_device(dev);
 
 	/* Steps 7 and 8 were done in xhci_alloc_virt_device() */
-- 
2.39.5

