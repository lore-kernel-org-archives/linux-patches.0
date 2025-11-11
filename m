Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4AA305976;
	Tue, 11 Nov 2025 01:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825526; cv=none; b=t+3ElyhVEY7ZkCwE0Bgq9b3BM3TD9x1P7k1uo/pCNpigpvBNKTY5/dEK+npb6FRCGD1I0zcQz8CZPvrE7wgCroIX7t+jPth1VYpkoMKesqiU2UT/KLOFkqQnVSUHTwOupzSsUOgZ7i6uqAY7FKTCxmGYSJabE4dGBZDKZToe8KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825526; c=relaxed/simple;
	bh=9jmasd7OdOKUZQf/YUU1+tSh0ygoJkJzWawUqmFdoh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQS2juAkMQGtD+WyUCukVRu2JRHCT/hTGEopq8rJQnQKRv3CTg5OKxNzSr/k0H+2JtYdXycryxLMKh4T5iiHAa05twCAzGrdxCL2e3GO1DGnCuaR8szyy1x1paDacdGsreGC2oboMNBZaphJngABtM8njJZRFXX6Mm51wWttsLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKaTknC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKaTknC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B09C4CEF5;
	Tue, 11 Nov 2025 01:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825526;
	bh=9jmasd7OdOKUZQf/YUU1+tSh0ygoJkJzWawUqmFdoh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKaTknC4C4ByrQBLfUZoiZIP5SpnrKFx0jIjz+W/L6Wxh2rf+BQF1OSclaG7WjNNF
	 U32RB8yIBmNuZtFzczgKUrt2sgqVCohuPpnOxIkmtkDVV/uPrP5JpWfdiAZ9/eFSg8
	 XDEV3Sq+7zbrnia5kq3YGAxKRZv84BPavy6roya4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 839/849] ACPI: SPCR: Check for table version when using precise baudrate
Date: Tue, 11 Nov 2025 09:46:49 +0900
Message-ID: <20251111004556.706573958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Punit Agrawal <punit.agrawal@oss.qualcomm.com>

commit 543d35004007a06ef247acf2fc55efa8388aa741 upstream.

Commit 4d330fe54145 ("ACPI: SPCR: Support Precise Baud Rate field")
added support to use the precise baud rate available since SPCR 1.09
(revision 4) but failed to check the version of the table provided by
the firmware.

Accessing an older version of SPCR table causes accesses beyond the
end of the table and can lead to garbage data to be used for the baud
rate.

Check the version of the firmware provided SPCR to ensure that the
precise baudrate is vaild before using it.

Fixes: 4d330fe54145 ("ACPI: SPCR: Support Precise Baud Rate field")
Signed-off-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Link: https://patch.msgid.link/20251024123125.1081612-1-punit.agrawal@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/spcr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/spcr.c
+++ b/drivers/acpi/spcr.c
@@ -152,7 +152,7 @@ int __init acpi_parse_spcr(bool enable_e
 	 * Baud Rate field. If this field is zero or not present, Configured
 	 * Baud Rate is used.
 	 */
-	if (table->precise_baudrate)
+	if (table->header.revision >= 4 && table->precise_baudrate)
 		baud_rate = table->precise_baudrate;
 	else switch (table->baud_rate) {
 	case 0:


