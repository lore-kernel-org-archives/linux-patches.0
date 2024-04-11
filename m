Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD071E48E;
	Thu, 11 Apr 2024 10:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832632; cv=none; b=X3bnXo5HtGN1rl44pYowgqdf3FhSy2sWlYyG+fNzQhY8LJevK7+H5oKPhGMTMMK07fe+idnmmwBu4eG69kad7RD4wqDwusIIqjTywZumq81K+9KUKgwRIvcSQriUUEO5whKaWrervmY9NqCtynDHwJ3AzeqQp8ExWfktQj53tjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832632; c=relaxed/simple;
	bh=x/jpc3qPs7/amMquVe3t4uiZm5rGK6cA8l79xuze/Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilgTwuKqPsCe1PS6YxEfjcA0Pe/MeTNRN0X+XaM/Vf53A/pOtdViKYxC3dUBdTbpncMvjJahf3JTFG9SAPH1pPi8JK8ikvAsu2h+Tbvu/1OzP7cCWLta3jy1DxLlFeYzfIeUB3aosbuYVttWRAlDT+7uoDMCU+zXxxSxe1p/ICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G/mDR3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G/mDR3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01039C433F1;
	Thu, 11 Apr 2024 10:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832632;
	bh=x/jpc3qPs7/amMquVe3t4uiZm5rGK6cA8l79xuze/Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0G/mDR3juTTBKTPhaDbqvvghPa8Tz3L5UasbSDZyU9t1bbPkbWo6/mJk6kPyAm1qA
	 wvN4o+1JSjKDFP1cG1lGDDY/5PKANqNbOyALqflfxe3FRl1k8aakZ6dFyPvzGLyykt
	 qs9XMEYSJeOImNexb3gjIbu194KXhH7sW5vgyMv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Drake <drake@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jian-Hong Pan <jhp@endlessos.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/57] Revert "ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default"
Date: Thu, 11 Apr 2024 11:57:39 +0200
Message-ID: <20240411095408.938567154@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Daniel Drake <drake@endlessos.org>

[ Upstream commit cb98555fcd8eee98c30165537c7e394f3a66e809 ]

This reverts commit d52848620de00cde4a3a5df908e231b8c8868250, which was
originally put in place to work around a s2idle failure on this platform
where the NVMe device was inaccessible upon resume.

After extended testing, we found that the firmware's implementation of S3
is buggy and intermittently fails to wake up the system. We need to revert
to s2idle mode.

The NVMe issue has now been solved more precisely in the commit titled
"PCI: Disable D3cold on Asus B1400 PCI-NVMe bridge"

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215742
Link: https://lore.kernel.org/r/20240228075316.7404-2-drake@endlessos.org
Signed-off-by: Daniel Drake <drake@endlessos.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jian-Hong Pan <jhp@endlessos.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index b277e25b276ce..95deb55fb9a8c 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -382,18 +382,6 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "20GGA00L00"),
 		},
 	},
-	/*
-	 * ASUS B1400CEAE hangs on resume from suspend (see
-	 * https://bugzilla.kernel.org/show_bug.cgi?id=215742).
-	 */
-	{
-	.callback = init_default_s3,
-	.ident = "ASUS B1400CEAE",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK B1400CEAE"),
-		},
-	},
 	{},
 };
 
-- 
2.43.0



