Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BF043AD1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cjdhc2jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5608BC4E758;
	Wed, 15 Nov 2023 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081510;
	bh=Rq3DHxlXqnIJKzkF3a8QJASzYbOC0p3TN0I5tcXGEOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cjdhc2jwsTKQPQAAQDcj4RkXg4sIqKy47xNA7avyb1C1PTIZski6mqLM6YpWmnbG+
	 VI7PlZA4O53MUJnFIjNr+iK2XtKUp9OVH+x2WpbdDIofjRpwLlAwjtOX0u7uD5sBdx
	 9HYjvLbXJJ4iIlTbwHxKOlFhOQ4Fkxxr9TpJrZ4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/244] mfd: arizona-spi: Set pdata.hpdet_channel for ACPI enumerated devs
Date: Wed, 15 Nov 2023 15:35:54 -0500
Message-ID: <20231115203558.064598086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 831d1af85133e1763d41e20414912d9a1058ea72 ]

Commit 9e86b2ad4c11 changed the channel used for HPDET detection
(headphones vs lineout detection) from being hardcoded to
ARIZONA_ACCDET_MODE_HPL (HP left channel) to it being configurable
through arizona_pdata.hpdet_channel the DT/OF parsing added for
filling arizona_pdata on devicetree platforms ensures that
arizona_pdata.hpdet_channel gets set to ARIZONA_ACCDET_MODE_HPL
when not specified in the devicetree-node.

But on ACPI platforms where arizona_pdata is filled by
arizona_spi_acpi_probe() arizona_pdata.hpdet_channel was not
getting set, causing it to default to 0 aka ARIZONA_ACCDET_MODE_MIC.

This causes headphones to get misdetected as line-out on some models.
Fix this by setting hpdet_channel = ARIZONA_ACCDET_MODE_HPL.

Fixes: e933836744a2 ("mfd: arizona: Add support for ACPI enumeration of WM5102 connected over SPI")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231014205414.59415-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index aa1d6f94ae532..8d826b58732dc 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -118,6 +118,9 @@ static int arizona_spi_acpi_probe(struct arizona *arizona)
 	arizona->pdata.micd_ranges = arizona_micd_aosp_ranges;
 	arizona->pdata.num_micd_ranges = ARRAY_SIZE(arizona_micd_aosp_ranges);
 
+	/* Use left headphone speaker for HP vs line-out detection */
+	arizona->pdata.hpdet_channel = ARIZONA_ACCDET_MODE_HPL;
+
 	return 0;
 }
 
-- 
2.42.0



