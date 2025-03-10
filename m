Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CC230BC5;
	Mon, 10 Mar 2025 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628435; cv=none; b=j/P/N93NnoGqUNQ3s7bj3cy5jLgfelobZLbiHT23NWeJnnMiFq3pDT+hzL6zJxpFBrH37ic/vme64yYnFXTeHgREIxQfFLsAiQBb93HoaEQXd8FHKFJPjlTG1X5XCjdm8WeVbDNY8Q224VEHmgdgVm2bgZQ0Q4K3MFeRz+RCN7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628435; c=relaxed/simple;
	bh=MaPBEVHmNfAnix2IIa/zWYJMQIhbKgeFoY19/rpa0tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpwJf+0VEdFHZ616F5sR4F7UhdOB/VTqlCu3aBEWpFO0qFz6BCiEVYHT6QVztuZFYg90Q43wPhk8tjRmub4tXMrrDYcQRVhAKu8da0hu+CEIXSd9qeha0RgWOd32XswhLUkQGzPsAlmdNTD6TuV0ammv6C24MxptkxT2YbPw3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afF1uY+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afF1uY+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC60C4CEE5;
	Mon, 10 Mar 2025 17:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628435;
	bh=MaPBEVHmNfAnix2IIa/zWYJMQIhbKgeFoY19/rpa0tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afF1uY+B8axvd4JtNbhbrZmxEhyDWQhllJOn51lleo+hG4ut8hCD19ImJUPFWfG0P
	 9g10I4erLswOv/z4MJsWlUq26t2pKaJGBTz8NKtP9I5mLQa1zoQK/sHVSCJurSPnER
	 g/+h4F/e8mpQVYWsBWXaDqnZaMEnXk+ZFILvUwxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoku Ishibe <me@hokuishi.be>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 016/109] ALSA: hda: intel: Add Dell ALC3271 to power_save denylist
Date: Mon, 10 Mar 2025 18:06:00 +0100
Message-ID: <20250310170428.196885738@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hoku Ishibe <me@hokuishi.be>

commit 1ee5aa765c22a0577ec552d460bf2035300b4b51 upstream.

Dell XPS 13 7390 with the Realtek ALC3271 codec experiences
persistent humming noise when the power_save mode is enabled.
This issue occurs when the codec enters power saving mode,
leading to unwanted noise from the speakers.

This patch adds the affected model (PCI ID 0x1028:0x0962) to the
power_save denylist to ensure power_save is disabled by default,
preventing power-off related noise issues.

Steps to Reproduce
1. Boot the system with `snd_hda_intel` loaded.
2. Verify that `power_save` mode is enabled:
```sh
cat /sys/module/snd_hda_intel/parameters/power_save
````
output: 10 (default power save timeout)
3. Wait for the power save timeout
4. Observe a persistent humming noise from the speakers
5. Disable `power_save` manually:
```sh
echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save
````
6. Confirm that the noise disappears immediately.

This issue has been observed on my system, and this patch
successfully eliminates the unwanted noise. If other users
experience similar issues, additional reports would be helpful.

Signed-off-by: Hoku Ishibe <me@hokuishi.be>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250224020517.51035-1-me@hokuishi.be
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2217,6 +2217,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1631, 0xe017, "Packard Bell NEC IMEDIA 5204", 0),
 	/* KONTRON SinglePC may cause a stall at runtime resume */
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
+	/* Dell ALC3271 */
+	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
 	{}
 };
 #endif /* CONFIG_PM */


