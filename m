Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905DC3F20E5;
	Wed, 20 May 2026 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298174; cv=none; b=dXzkRbC2vrrvbE9ZfsRyj1ppZA3uUE9OjlfdO5gJjDfgJExnxx99FrDBnsuBF2KseOz1ZUTNlmNEwg7RjFIxhUBQrjTjD6PYSkmNLH6f2D5pH0IW82DNHIv6TxvjZwk3lo+hHaJkq0f7gMEIGURoHl1kjhV6c6Fd0k8dTLy135M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298174; c=relaxed/simple;
	bh=YreQBlgvjak0IxUcRmWVp4Qbo+5sfAmr1XMUNQpMIq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dq2ibZ4OwjjkYTJqzbxLv5c1hkO2guW4dVf/5vjYqvIkhR+tXzOzeQwvJdCv3RVANdWPPLRsOx4JULMDdXqn7ccmRUivpoeU8jIhcxuDa0OczA4EDba8aZR23P1fUD37ffZSphAddZz4RiGKHZl7u+rS2/Tb11ikYL8+wPT+jbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZbbKqn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZbbKqn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2A11F000E9;
	Wed, 20 May 2026 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298173;
	bh=e72PnilymQniNxPMNvYkGP4vmIuuyRD13NFhbSJW130=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZbbKqn4IM5ATzZMDW5BxQkUR+dP9qSl9XO6GUZa4pTVGyasL1kOtTPUuhxbUbZ+7
	 48dH0oSC1H/slVkrawAyEAnINjUt7blSxYTHkGVha8ITmpHOjZHL8T7G8Sm/fOOAG/
	 Z8A4AcF15yMrCd7v3OXIxrMIPnT6SVN7dX/sD+kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Goudar Manjunath Ramanagouda <manjunath.ramanagouda.goudar@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/957] PCI/DPC: Log AER error info for DPC/EDR uncorrectable errors
Date: Wed, 20 May 2026 18:12:31 +0200
Message-ID: <20260520162140.355421386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 97970e7c694356e3386a10e3b936d61eafd06bce ]

aer_print_error() skips printing if ratelimit_print[i] is not set.  In the
native AER path, ratelimit_print is initialized by add_error_device()
during source device discovery, and is set to 1 for fatal errors to bypass
rate limiting since fatal errors should always be logged.

The DPC/EDR path uses the DPC-capable port as the error source and reads
its AER uncorrectable error status registers directly in
dpc_get_aer_uncorrect_severity(). Since it does not go through
add_error_device(), ratelimit_print[0] is left uninitialized and zero.  As
a result, aer_print_error() silently drops all AER error messages for
DPC/EDR triggered events.

Set ratelimit_print[0] to 1 to bypass rate limiting and always print AER
logs for uncorrectable errors detected by the DPC port.

Fixes: a57f2bfb4a58 ("PCI/AER: Ratelimit correctable and non-fatal error logging")
Co-developed-by: Goudar Manjunath Ramanagouda <manjunath.ramanagouda.goudar@intel.com>
Signed-off-by: Goudar Manjunath Ramanagouda <manjunath.ramanagouda.goudar@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260318170449.2733581-1-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index fc18349614d7c..7605ddd9f0ba8 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -256,6 +256,7 @@ static int dpc_get_aer_uncorrect_severity(struct pci_dev *dev,
 
 	info->dev[0] = dev;
 	info->error_dev_num = 1;
+	info->ratelimit_print[0] = 1;
 
 	return 1;
 }
-- 
2.53.0



