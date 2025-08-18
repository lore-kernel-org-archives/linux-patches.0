Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A067322540;
	Mon, 18 Aug 2025 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523489; cv=none; b=gvp4iFvJgL6a/1j8s78dB/YnKJFt/Rb8SR6oAp/HvEOcwQNukV6s3PzsgAKze6CNDYPzOYuV6Lkd+B6W/LDrTELSb7qx9CPl9YhiXL02CR5sXiOIZ9tvqd+VHo1g+m2psn+wuMIE5lHugiLdAYVJL16evQ1J+0kaojSmRU0zTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523489; c=relaxed/simple;
	bh=mBtZonrs8yDPaVv6WhWcZK2fiLxlk7mg7fVqg7/kI44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+3k3FWZ3LH4ohoW4IqPijcffNC2Nf04y545Zv9rGGgX3gz2oqNsdc7KTPvrkoe51JtcKRUh/dVbAsyERibeH+GtGMfoOmYzFPaJ6COrMkceu9mlLgjxnHcIvxI7nM2hBazFfR8NNbUqD2qqz3/i3gs4IrRrCSiVHznqIlcYGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsDHeDaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsDHeDaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E2EC4CEEB;
	Mon, 18 Aug 2025 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523489;
	bh=mBtZonrs8yDPaVv6WhWcZK2fiLxlk7mg7fVqg7/kI44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsDHeDaOCnjoqaarv9dXs4TPl6Syu5DHWnTFRS51hX2SzO2PTAsR1r7yKoLnY+LUv
	 wP7ES+sml6+A3LsTY0/bko4ffl9ztfYCq7TylJlAdFxFJYedOyNrB1Gi9wdFMtDY5e
	 4pNBmrKRwKQAd+wKpH4aLaZxkDvP+NiwbOwFDeHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 154/515] ACPI: processor: fix acpi_object initialization
Date: Mon, 18 Aug 2025 14:42:20 +0200
Message-ID: <20250818124504.318060830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

[ Upstream commit 13edf7539211d8f7d0068ce3ed143005f1da3547 ]

Initialization of the local acpi_object in acpi_processor_get_info()
only sets the first 4 bytes to zero and is thus incomplete. This is
indicated by messages like:
	acpi ACPI0007:be: Invalid PBLK length [166288104]

Fix this by initializing all 16 bytes of the processor member of that
union.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Link: https://patch.msgid.link/20250703124215.12522-1-sebott@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 7cf6101cb4c7..2a99f5eb6962 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -275,7 +275,7 @@ static inline int acpi_processor_hotadd_init(struct acpi_processor *pr,
 
 static int acpi_processor_get_info(struct acpi_device *device)
 {
-	union acpi_object object = { 0 };
+	union acpi_object object = { .processor = { 0 } };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
 	int device_declaration = 0;
-- 
2.39.5



