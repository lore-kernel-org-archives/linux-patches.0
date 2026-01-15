Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C4242049;
	Thu, 15 Jan 2026 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495946; cv=none; b=Ar3ZmpZtsHm7hBlToZI5uqWlhBH0vJW/eFDHJcEWtFh9RO+tBhCSeE8EQD1AyyMcxO0VepJ21wOyQ9KvfkDglMeEJVhjDPmVxh1KmxfmsBv4bmXDbuejoeT00htmOrfql99OfJ5r+v1Pn4v3UahdOZ9jyf17JFaWRXZmEqmt2CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495946; c=relaxed/simple;
	bh=j9roTVcvsWbJ0AIkEU8g6FKMuf2XPu1DGUaEdH3GnGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okVSAkALQ+0+c1ozkuA1c1XnzsdKnCTVfgF59/QFcMn2Ubip9Mm5PwDuFG2JoXfDg2I3AslIMak+PXIuRb5XG6SUTGkgSb+JXhqhzjETYJuhvqV2y+wZcRUO1L5jdD5iMAVsNkhsaPVwaDY3u9kxSFmcapapsep7h0SWxzBI6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpCqjrN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpCqjrN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5710C116D0;
	Thu, 15 Jan 2026 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495946;
	bh=j9roTVcvsWbJ0AIkEU8g6FKMuf2XPu1DGUaEdH3GnGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpCqjrN7cbuwAysTfTiyJIPIVcbEhhrmaEysAQd+AOb63gG4TUhP9qoEWmU0quH2u
	 A4hOwPNsLvlcsREFkQXWzBIQKWD9nD3XhFO3BLERunAyFmq19V3SkKagC+owfdmHWL
	 0mHWtEF9Akq7ImBQGM1YkRic02SFQwtzIXpN2BSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	August Wikerfors <git@augustwikerfors.se>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 023/181] ALSA: hda/tas2781: properly initialize speaker_id for TAS2563
Date: Thu, 15 Jan 2026 17:46:00 +0100
Message-ID: <20260115164203.163665224@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: August Wikerfors <git@augustwikerfors.se>

commit e340663bbf2a75dae5d4fddf90b49281f5c9df3f upstream.

After speaker id retrieval was refactored to happen in tas2781_read_acpi,
devices that do not use a speaker id need a negative speaker_id value
instead of NULL, but no initialization was added to the TAS2563 code path.
This causes the driver to attempt to load a non-existent firmware file name
with a speaker id of 0 ("TAS2XXX38700.bin") instead of the correct file
name without a speaker id ("TAS2XXX3870.bin"), resulting in low volume and
these dmesg errors:

    tas2781-hda i2c-INT8866:00: Direct firmware load for TAS2XXX38700.bin failed with error -2
    tas2781-hda i2c-INT8866:00: tasdevice_dsp_parser: load TAS2XXX38700.bin error
    tas2781-hda i2c-INT8866:00: dspfw load TAS2XXX38700.bin error
    [...]
    tas2781-hda i2c-INT8866:00: tasdevice_prmg_load: Firmware is NULL

Fix this by setting speaker_id to -1 as is done for other models.

Fixes: 945865a0ddf3 ("ALSA: hda/tas2781: fix speaker id retrieval for multiple probes")
Cc: stable@vger.kernel.org
Signed-off-by: August Wikerfors <git@augustwikerfors.se>
Link: https://patch.msgid.link/20251222194704.87232-1-git@augustwikerfors.se
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -111,8 +111,10 @@ static int tas2781_read_acpi(struct tasd
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub)) {
 		/* No subsys id in older tas2563 projects. */
-		if (!strncmp(hid, "INT8866", sizeof("INT8866")))
+		if (!strncmp(hid, "INT8866", sizeof("INT8866"))) {
+			p->speaker_id = -1;
 			goto end_2563;
+		}
 		dev_err(p->dev, "Failed to get SUBSYS ID.\n");
 		ret = PTR_ERR(sub);
 		goto err;


