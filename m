Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3E6F519;
	Thu, 25 Jul 2024 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918899; cv=none; b=lfb9NwCIuGTwiSd+YTMkVdcQ5Po/5JlKgAZkR1bjhKxXiEDHL8DyhU7YL9MqBgLEiwISFq8/3QWT0adh2GAwgwn+Rip2OsDJ3WG6g3P1DQzvjX09r796WI9YNVPDkRw8coRnCYWni6ki6j6KFJC3Dbrj0UHNmsLCyxJIdVuRuI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918899; c=relaxed/simple;
	bh=GXpL1/I+I8Bj1mtoKGb43bVrJuw1Hsr9gtrHI91Y0KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMw9K3R9mV/chmnP6AQ6fyMJN0Q8E4tConZE5ehb/KwoGGOziuk6+LdkaSG9Za5JZR0hzhhKOoU5jCZhYALykobrDmqbomIYgd4V2ftMkjfneoftwKFJnMclXFgnEZ2BxeZCUQGXQhRtYvx0qGuOpHxqP0KaqeDyRmYi7yuCFI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJBPMUg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJBPMUg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B7C116B1;
	Thu, 25 Jul 2024 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918899;
	bh=GXpL1/I+I8Bj1mtoKGb43bVrJuw1Hsr9gtrHI91Y0KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJBPMUg/E2e7y115WgZBXTi/yO4QDvlhtFvy/8ciX8rlFbNKDGs9zLjUodGdWNRur
	 s+c9hoIGjs4HZaVNLdq5SweS0+wsVztOnLLEOXw9OTtXDQI+xt7TrGXzvK/4b4HjwU
	 mBRsKWFAv9wpnY1W6FdXTlBtkIbrbcxdrgzQntBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/59] ACPI: EC: Abort address space access upon error
Date: Thu, 25 Jul 2024 16:36:54 +0200
Message-ID: <20240725142733.430517336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f6f172dc6a6d7775b2df6adfd1350700e9a847ec ]

When a multi-byte address space access is requested, acpi_ec_read()/
acpi_ec_write() is being called multiple times.

Abort such operations if a single call to acpi_ec_read() /
acpi_ec_write() fails, as the data read from / written to the EC
might be incomplete.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 487884420fb0d..60f49ee161479 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1316,10 +1316,13 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_enable(ec);
 
-	for (i = 0; i < bytes; ++i, ++address, ++value)
+	for (i = 0; i < bytes; ++i, ++address, ++value) {
 		result = (function == ACPI_READ) ?
 			acpi_ec_read(ec, address, value) :
 			acpi_ec_write(ec, address, *value);
+		if (result < 0)
+			break;
+	}
 
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_disable(ec);
-- 
2.43.0



