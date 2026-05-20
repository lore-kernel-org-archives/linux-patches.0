Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02623546D0;
	Wed, 20 May 2026 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295354; cv=none; b=EkM+VMZ8pOSPrO/NeYY13BfdszmoikjJEDegpEU01WjRdvbj2Hpy1ANknlCW/lLTxNESmNEjS+s+lQ0/F16zdz2wTqb+aqvXQQW76CuMqtg01899rFvu+mZlEsmw0lvdLhhqX4tUnL92Cq2CwznCO4JWk+zG8ocxFBLcTNeZWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295354; c=relaxed/simple;
	bh=2yv5u78NliBh9CUfUVDRThfYvWl4LRY7UJuS2cFxhts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J24OMDGS1oI5MGvwfEjkpZzEkS3OftI8SvnoWERiDny6WLG0Om7eabHwxaLeOcxmrCm+n0MhqHDwB+B+PJWdJWovjRjQO4pSgVWFHhUjpLelBXm1ly9tZMwsIUBxkffnnMDq/rvyWtl/b6XcqASNYXczhBZMAqivGQrbZwtfg2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFoLp9II; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFoLp9II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCB1F000E9;
	Wed, 20 May 2026 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295353;
	bh=3CR+VHW/xyWsIG5nBK1pUoqyXl4cjUGanRcG0pufPbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFoLp9II9thkS6PT4BTZ4XnwkcnoVk85W/N2nt5l4LlYXo6KmoYJTP1UHOt/mfcKo
	 CR4W4egZOimFuMyyKeT+tr14yiVhiy8M9+EBhaVLF+Kvr0SIQbVxh2ru0VX0v+0Q5J
	 kdp8e8sh2wu7FTQuCoOhRWtR3QHKRA+MP/LxTLxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Goudar Manjunath Ramanagouda <manjunath.ramanagouda.goudar@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0346/1146] PCI/DPC: Log AER error info for DPC/EDR uncorrectable errors
Date: Wed, 20 May 2026 18:09:56 +0200
Message-ID: <20260520162156.030804571@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



