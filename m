Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929B8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60699C433C8;
	Sun, 16 Jul 2023 20:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539296;
	bh=ydMKwpmqX27pSEKaKFl/BhNnMeo6f0eTuu/5tsKX/24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZIRaVJEf7vc/b1QmiLgf9ngh7or32wZdCK3d47xxBxTstzV81H9oXwyqcmgQ+dpp
	 Ua0UOHElXHeQ5BTpUDQELOv+X7Fsfzg2XBv3d0W0HfjQc8F4n8FS3j/nPd/0QUicpg
	 1Df0IsUYV9AGLLOhHgSPzhjO+VD+ZpP4AnLZuz9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 726/800] mmc: core: disable TRIM on Kingston EMMC04G-M627
Date: Sun, 16 Jul 2023 21:49:39 +0200
Message-ID: <20230716195005.981656184@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

commit f1738a1f816233e6dfc2407f24a31d596643fd90 upstream.

It seems that Kingston EMMC04G-M627 despite advertising TRIM support does
not work when the core is trying to use REQ_OP_WRITE_ZEROES.

We are seeing I/O errors in OpenWrt under 6.1 on Zyxel NBG7815 that we did
not previously have and tracked it down to REQ_OP_WRITE_ZEROES.

Trying to use fstrim seems to also throw errors like:
[93010.835112] I/O error, dev loop0, sector 16902 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 2

Disabling TRIM makes the error go away, so lets add a quirk for this eMMC
to disable TRIM.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230619193621.437358-1-robimarko@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/quirks.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -110,6 +110,13 @@ static const struct mmc_fixup __maybe_un
 		  MMC_QUIRK_TRIM_BROKEN),
 
 	/*
+	 * Kingston EMMC04G-M627 advertises TRIM but it does not seems to
+	 * support being used to offload WRITE_ZEROES.
+	 */
+	MMC_FIXUP("M62704", CID_MANFID_KINGSTON, 0x0100, add_quirk_mmc,
+		  MMC_QUIRK_TRIM_BROKEN),
+
+	/*
 	 * Some SD cards reports discard support while they don't
 	 */
 	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,


