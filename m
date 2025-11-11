Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C38A246768;
	Tue, 11 Nov 2025 01:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822937; cv=none; b=UFCkFxjWLiN71Q6f44B+liWXuaPHH6n5f0r2RKVUGdF3x0HhHkc8NZyz4gwnJxTg43l5GitJ5MWFvMfQKtPuGNNrqpVtKm9poL3Tj+VDvgNqnrdnc3b2Z/Q1OIBfH1zlicaPWCCiDNXVT9LGFqCKQMt0poAmqDKlrbbcKEtP4e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822937; c=relaxed/simple;
	bh=P0t8p6eWvdkCo3kJUJ9tX5F3vr8NtVtg09zxCFGxP4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZGHpC3yz6kcEmFPoswjIIOdLnWOjmHsNYzQzYW6H0glEzNgozYTM+dXWZ9ARBeyYEBjBVFg6IGDwefnAsrcBA4iTeaglRflZ59qd/yvwJmvFlaUcWubb5BL0ice272nNEM4fmZ4df5Evmp9e7pzX2wBUMuv8C68i2OmSbCbyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fF75vBtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fF75vBtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E4FC16AAE;
	Tue, 11 Nov 2025 01:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822936;
	bh=P0t8p6eWvdkCo3kJUJ9tX5F3vr8NtVtg09zxCFGxP4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF75vBtCmST4Xu+C0dvBIbJBoTMeQ+nwUK5xu9/RIvrWQJD1kGM2LP3rH7hoqleO1
	 rJp1MhsVuIjwWd4DGk9SQKu6MXL5f3abmo7ISiFM/ecwGf+tykYsqu940h1j40KFWp
	 4wS+ttkWKDUTm/sPX3jRsZ6qLV2tzNNbyp6FT7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 199/849] ACPI: SPCR: Support Precise Baud Rate field
Date: Tue, 11 Nov 2025 09:36:09 +0900
Message-ID: <20251111004541.250277650@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 4d330fe54145ecfbb657ac01a554fdedf3c1927e ]

The Microsoft Serial Port Console Redirection (SPCR) specification
revision 1.09 comprises additional field: Precise Baud Rate [1].

It is used to describe non-traditional baud rates (such as those
used by high-speed UARTs).

It contains a specific non-zero baud rate which overrides the value
of the Configured Baud Rate field. If this field is zero or not
present, Configured Baud Rate is used.

Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/serports/serial-port-console-redirection-table [1]
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://patch.msgid.link/20250913070815.16758-1-cp0613@linux.alibaba.com
[ rjw: Corrected typo in the subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/spcr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/spcr.c b/drivers/acpi/spcr.c
index cd36a97b0ea2c..fa12e740386de 100644
--- a/drivers/acpi/spcr.c
+++ b/drivers/acpi/spcr.c
@@ -146,7 +146,15 @@ int __init acpi_parse_spcr(bool enable_earlycon, bool enable_console)
 		goto done;
 	}
 
-	switch (table->baud_rate) {
+	/*
+	 * SPCR 1.09 defines Precise Baud Rate Filed contains a specific
+	 * non-zero baud rate which overrides the value of the Configured
+	 * Baud Rate field. If this field is zero or not present, Configured
+	 * Baud Rate is used.
+	 */
+	if (table->precise_baudrate)
+		baud_rate = table->precise_baudrate;
+	else switch (table->baud_rate) {
 	case 0:
 		/*
 		 * SPCR 1.04 defines 0 as a preconfigured state of UART.
-- 
2.51.0



