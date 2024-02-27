Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1913AA43;
	Tue, 27 Feb 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042934; cv=none; b=H7NPy4bnZV6OB5GXXeRRmRUyTKb2915euTBRJpMyvQj8VnraWCQmtCNzO/Df7XTBC9q14MMxEs9dcurqz9+WupPi7aUl2OKL2iZFhKBLe3v4skhd/WsO4Zh9Y/w2VSPnZuzQH1I590+wsuSsVl6SAaYSV783e3uOcQxMdaE2VL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042934; c=relaxed/simple;
	bh=5fF8TzDugn2BDbLOI50RwUpYGh+gPzxITF3/CREyfLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceccHUMduIBCZrH491GZ+P00j+k9R4mIY05TwhzibOc+WaJjYd0RZynzBdlp3U3VtNvp0nnZNUHGWLBKURJPLmKFzVT2Ap4q6AqfC5sEcE92VkEeTrvzoMKvDV8iCLXQHxZt/M3ni07PkId5tDyV3kSTwW/k0sKIpkL+7cUi52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jad901kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jad901kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F07C433F1;
	Tue, 27 Feb 2024 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042934;
	bh=5fF8TzDugn2BDbLOI50RwUpYGh+gPzxITF3/CREyfLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jad901kVdlbc19ZaRGI9/chFAAFbb5zVEd53SW59BOWqWEOFVcgcBFh+gcECwnW7A
	 /BKQGros30LFjAHKR0yZP+STWSxbtVeJwtmpq4M4VWNyErDkP9nOUhiExIsY6sGQ1Z
	 ZcqgaqszCr+mB7Ujb2IujbrMCF/8tRVd+SUCy7C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/245] ACPI: video: Add backlight=native DMI quirk for Lenovo ThinkPad X131e (3371 AMD version)
Date: Tue, 27 Feb 2024 14:26:01 +0100
Message-ID: <20240227131620.835435140@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

[ Upstream commit bd5d93df86a7ddf98a2a37e9c3751e3cb334a66c ]

Linux defaults to picking the non-working ACPI video backlight interface
on the Lenovo ThinkPad X131e (3371 AMD version).

Add a DMI quirk to pick the working native radeon_bl0 interface instead.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index be923911e87c1..28e816be4753e 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -341,6 +341,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "82BK"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Lenovo ThinkPad X131e (3371 AMD version) */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "3371"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Apple iMac11,3 */
-- 
2.43.0



