Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C7B1494AF;
	Tue, 25 Jun 2024 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308203; cv=none; b=mEsf0nq+s0+SmmeemZ6R3Z2W1rj93RsexGIwfUQPj7O5aDWAlMHDiHz3SLDnDnP6LecjiN9bHw3YLxKG+INA3heauzLjarSkZLSZ6W3mETruom/5I/sROzTBo/2pDO3z5e+fxoBOGXUA1/5bl96LIJM2Tii9Q1yOlSzaI+i3wEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308203; c=relaxed/simple;
	bh=/HH7F9Gczy8DmftXSfsusmfGzk9w0lBnMgozKy69X4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apeKZ5Q9BeQi1NEP5HJ8JvmHC1P8kOJSVgq0o6MqGi50DtKluQNZhySzV5e3/8Jop0pegxHV7VWy2UnHcoxyCiBKVEuj+WZOSKbSp7pmVx2OtDlltXAXYlWMh31cpfheFebRXziql19TwqJlNN95DhvsLPDWE/wlowaiUG7CcWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ad/48XIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ad/48XIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D5C32781;
	Tue, 25 Jun 2024 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308203;
	bh=/HH7F9Gczy8DmftXSfsusmfGzk9w0lBnMgozKy69X4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ad/48XIQqgYn3L0ebN+fND2fiJmiJjGrpNL8R5Nuxs1dcX2Os1ZMq2SNTSWvc9+5q
	 9LbEHIgpkW53Fy0F5VNW4KRsmit8ePMMiR0xHT7LvgAeSFP1HCOxNfFU8RRS7naX/a
	 MN93J6TbEGaEoz4xgoB8CaBZOkIYnDAYm3JNcPTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 042/250] ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7
Date: Tue, 25 Jun 2024 11:30:00 +0200
Message-ID: <20240625085549.675537906@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9fdcc620c6524..2cc3821b2b16e 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -497,6 +497,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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



