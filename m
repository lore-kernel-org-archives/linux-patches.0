Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7245945;
	Wed,  3 Jul 2024 11:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005697; cv=none; b=acnXBhImj07TXi9w6VtipjIHd/wrhFUKuab7ScljFtKOxsQN0RIo3bO7rwtfFUgvT0V/3Dkp5w0tGpMmBEgYQlCvZb3ywv6a59eWcv0kfg19tr0oO48X66HENJhfTeUxthWghMJKxvagIA+SLN5Sf6k8X3VpW5TOBrOYwju4iFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005697; c=relaxed/simple;
	bh=nchOhLu6Rp70ae6SpCC5IYQYBbk76aRr1yqF1HPnnYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlVB0Llu1WxW1yAHVyn2zcKypqH1I/cyxWgIf106KRMSjMV6bOyNgP3DHLiWlaYzRd5YDnsPh+ZrTHc3whN5skeDFY26tkGOrix48G9IkPHaeSZU6jbbONs5pHsJ6Sd3ANcrn4ie1s+wB4hEzFIpCIeaHhxVudGVWXWgJYz+/Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ttjK61O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ttjK61O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4708AC2BD10;
	Wed,  3 Jul 2024 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005697;
	bh=nchOhLu6Rp70ae6SpCC5IYQYBbk76aRr1yqF1HPnnYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ttjK61OqhTq5sLtu1cNrFOAqGZrlcWaUmLxoDyUMFJTfxWJKFbQrvUTCR13AE8Bi
	 IHCV8rBdFfd9en98uAZW9Be9DibRb+hhKGIxnqYCKQNMG2vcRvJYeBzfOSNxuMAUNi
	 zJcX1lxq6ox7jyD7IFPsyu3B01zE7JHtB6UsSezI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/356] ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7
Date: Wed,  3 Jul 2024 12:38:22 +0200
Message-ID: <20240703102919.385328656@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c901f63dc142c48326931f164f787dfff69273d9 ]

Lenovo Slim 7 16ARH7 is a machine with switchable graphics between AMD
and Nvidia, and the backlight can't be adjusted properly unless
acpi_backlight=native is passed.  Although nvidia-wmi-backlight is
present and loaded, this doesn't work as expected at all.

For making it working as default, add the corresponding quirk entry
with a DMI matching "LENOVO" "82UX".

Link: https://bugzilla.suse.com/show_bug.cgi?id=1217750
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index a5cb9e1d48bcc..338e1f44906a9 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -341,6 +341,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "82BK"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Lenovo Slim 7 16ARH7 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "82UX"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Lenovo ThinkPad X131e (3371 AMD version) */
-- 
2.43.0



