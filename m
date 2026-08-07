Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE78C29AB1A;
	Fri,  7 Aug 2026 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116718; cv=none; b=mcxRjR9ekAJvIFbW8CcP77oou/j7aReK1cCYrzggf7o3HtxeRnzt1wF+/iIpGcZh5R6ga/E2fJT87WEryu1qGm2CYlhDoFdnqvE11hpGrDZgasgJbTsV7bPikucYP9uNUX1cdBbH9OpmuPrHstoEQpczQbr2VJ0es8lA50/PiJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116718; c=relaxed/simple;
	bh=OwLhW0ainlihnJ6j/GDOXVw9wGLPDEHg+r0/sifxTcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P21zZHzwHLvaS+Puf3QAWxu6E3voDzdVuHSX6gXYRk/2dSXP3ePC7ju5AU27OZFDB7InUu338sdfnA7Fdnl9F6WBToY7pW/9at6fhvU03FyCiDXEmWT86G1IPdjRqxrW29P0yQT9uXyjQegxL9qa/efyX4ir60c8t1JT7XgfQsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7QAU3M9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7QAU3M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573641F000E9;
	Fri,  7 Aug 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116716;
	bh=p62I8dAbYWPNrQRxFzIQoSBDRFvvIAgp2bRAIjkbkZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7QAU3M9zTMmYQjKp8r9IejL21Y7qseSOlbqWdr7tb/pkFso/+kgQZIMY8kxp3xpH
	 /YhnLdOYpqjho9eKwbG2fznhkkD+6ttCJwcQyH6VAAK9A7KYkDAH+BdsxZTG8mWUJO
	 PcHiLcTEJNZluAYsJqFbbNcjQf8IibhUJiccgPvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 064/438] ASoC: SDCA: Correct pointer passed to devm_acpi_table_put
Date: Fri,  7 Aug 2026 16:34:20 +0200
Message-ID: <20260807143429.355257755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6a50332e194f58b562d396ab772c34e8c9890c0f ]

devm_acpi_table_put() takes a struct acpi_table_header * but the value
passed in is struct acpi_table_header ** so the value passed to
acpi_put_table() is actually the pointer not the table itself.

Remove the extra reference to correct the passed value.

Fixes: c4d096c3ca42 ("ASoC: SDCA: Add SDCA FDL data parsing")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260722103500.872714-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_device.c b/sound/soc/sdca/sdca_device.c
index 405e80b979de8..4bcd8d1fdff82 100644
--- a/sound/soc/sdca/sdca_device.c
+++ b/sound/soc/sdca/sdca_device.c
@@ -43,7 +43,7 @@ void sdca_lookup_swft(struct sdw_slave *slave)
 		dev_info(&slave->dev, "SWFT not available\n");
 	else
 		devm_add_action_or_reset(&slave->dev, devm_acpi_table_put,
-					 &slave->sdca_data.swft);
+					 slave->sdca_data.swft);
 }
 EXPORT_SYMBOL_NS(sdca_lookup_swft, "SND_SOC_SDCA");
 
-- 
2.53.0



