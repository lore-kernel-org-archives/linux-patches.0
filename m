Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208C718C038;
	Tue, 10 Sep 2024 09:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961312; cv=none; b=RjwpB+nbTpehxH3rJxzwnmVkOdFgUxdbmyZErMMjngHfQNzeJqyilsqh0vAmXuk+VxHpubFwh8XZG5o4jkKUNMx+R99mcDf9Y/akenaJqwb+DiSdARHh3rKIN5CDvQpP7jowZKFRVBek6ufjbFSmw90U8FLHhF9Ad5tEEz5CTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961312; c=relaxed/simple;
	bh=HtTPsXEPlxMbQo7zVv0IraitIevDzdxyAI23zT6YZsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5coBTzP+pfZKbFgLhIVcUVxCSzfFatPasBrp79HgZsS8Y2NXDAGAErToRf7T1aobf+R39xfo5kciXAZfzq97ZNU+ftZ2zMORSTa8wpl77Q44okcca3LrdSF/PNrjmqZ0UIbqniUaDKyG0QiS0PM8oTPESy4t8nbC+kYwfofS6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHvO1aWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHvO1aWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9520CC4CEC3;
	Tue, 10 Sep 2024 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961312;
	bh=HtTPsXEPlxMbQo7zVv0IraitIevDzdxyAI23zT6YZsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHvO1aWqEo7i2MU4SuPY8Gnq1iUluS72Gf8zOs3MQZd8y4txYZ7ZrO9T2VU9XHHiS
	 XUL0/SjRfJERGTvP7MSusAzq3AO69EcYyT/wQx+wm6NC3rb5jagtg4fFxMhaz3pwfg
	 NhxCMnM9yvm0w/00UrkpSSftdb0riSSs7z+Swfyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.10 028/375] nvme-pci: Add sleep quirk for Samsung 990 Evo
Date: Tue, 10 Sep 2024 11:27:05 +0200
Message-ID: <20240910092623.199245332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit 61aa894e7a2fda4ee026523b01d07e83ce2abb72 upstream.

On some TUXEDO platforms, a Samsung 990 Evo NVMe leads to a high
power consumption in s2idle sleep (2-3 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a
sleep with a lower power consumption, typically around 0.5 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2931,6 +2931,17 @@ static unsigned long check_vendor_combin
 		    dmi_match(DMI_BOARD_NAME, "NS5x_7xPU") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1"))
 			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
+	} else if (pdev->vendor == 0x144d && pdev->device == 0xa80d) {
+		/*
+		 * Exclude Samsung 990 Evo from NVME_QUIRK_SIMPLE_SUSPEND
+		 * because of high power consumption (> 2 Watt) in s2idle
+		 * sleep. Only some boards with Intel CPU are affected.
+		 */
+		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
+		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
+		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))
+			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
 	}
 
 	/*


