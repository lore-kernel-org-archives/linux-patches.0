Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681C265CC5;
	Tue, 11 Nov 2025 01:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822990; cv=none; b=iIqVObEeiVZrfUbqgBPifs8nmjzfzDL620EoiNBOz6eayT73rxtHUXkL8QgXAnLa6eKEC7lUOYUaapezkjyK5bAxhyE0CZc108lwX5mMZZusowf/s9YKj0tds8NSZw9dPsb7LTh5PdH5EFcdZEOqGDe6qJkycOuGkDf/7Tgivww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822990; c=relaxed/simple;
	bh=0YUzorIgoAttoetr8+iSUBZ6tNuw1e6gSMlzjAdCwX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M02rbPwj8AeE/czX9sM2GP++4DQkWVA7RMGBRf9FCSJAXQYMhlZWbRLzx+c6T7dqijzuWjRck8blFFqZs2s1iFrqFEM4i+WkdG6SWy5/8Q5F8OVAwufzF/1Xca+Sie1SkNiiK0BcnqIKSIVPnKRucMv9AGIj+GSlO5By+P8N7yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXHAlhv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXHAlhv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44A1C4CEFB;
	Tue, 11 Nov 2025 01:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822990;
	bh=0YUzorIgoAttoetr8+iSUBZ6tNuw1e6gSMlzjAdCwX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXHAlhv5JDZSBCKHbFozyFNoF/baEVTB51Vxp9JZVhH7YIC13vtNSCLJB+1CtHB7D
	 9ISRdg/RhaEtyIZwGx6hVaRtesKiHtrkH+s5/qAxnFMgdztm+UJPjDRp2QgfYeA/Ho
	 0VjAd/4+Wg6V13z9X11i7EhPi+fqEUsZDhcMyQgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/565] ACPI: SPCR: Support Precise Baud Rate field
Date: Tue, 11 Nov 2025 09:40:06 +0900
Message-ID: <20251111004530.314647273@linuxfoundation.org>
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



