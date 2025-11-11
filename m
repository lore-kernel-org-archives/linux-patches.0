Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A90338918;
	Tue, 11 Nov 2025 01:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824978; cv=none; b=p75/fUMoih4BqVdw9g4eWb08nTM6zfyCt5IJ4jsMSsv0gnlIO+EUKtUILZX4i9odi0dTKNYFDfvYLHq177XMOq9UsyrBInPBVoKyy+cY6k5q7dMqOJXTwyv0d7w2eFPkeQL1hP5DYGT7ZyxNSXFWTBzoDmwFTWicXYqKzex6oyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824978; c=relaxed/simple;
	bh=RRz8tKsom8cWyH3XNmxPtltuPwaRACYlgS8RkC2fJ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A16QLGesl5XR0AJ0lzckoPos4C2VfPXy7tcyMoF1dgBjJXHaiGib4BaJObuM0yEat5tqNZvHC4TVolsRTkSFyHxaPXdDTFT1oE5XeOBFJfLCzfKpeDdTNrxUoVozPYAoZIoRMB/ffSFUjarsKidof4/eMk0o0kUGc3xTD32i2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHNSeKGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHNSeKGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C5BC4AF09;
	Tue, 11 Nov 2025 01:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824978;
	bh=RRz8tKsom8cWyH3XNmxPtltuPwaRACYlgS8RkC2fJ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHNSeKGEuS18/OpCopL9HkAgMbgosIqIovZEZOeD5KhbX3LbM2mtio/qv8PiPcQ7K
	 pEeoA7uASkaO3LlRUf7UBLL32SCU4bX7O7pdi7+77nycizf0O46r+TonUtEXkJMHYB
	 WaTNp5UVFYXo+/JdDE4m+aJHf0GYvSwKPB7cPRZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 561/565] ACPI: SPCR: Check for table version when using precise baudrate
Date: Tue, 11 Nov 2025 09:46:57 +0900
Message-ID: <20251111004539.637001376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


