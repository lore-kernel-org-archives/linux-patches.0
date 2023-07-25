Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65201ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4803EC433C8;
	Tue, 25 Jul 2023 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285322;
	bh=XmxzaaER255j+qym9M427F0CRp3DIvbsG7KfgQvarxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EseuPCC6syWpG9OsxoA0FrolbJeH38IkWhtkccwE+5GsPr28MWGR++fsuz3BWb1PA
	 rFao27MYNOe5XBuQ3NbS1L6WvSH1ZMVG1KyXzlyddIdMcOccuX3hKKZ/a9TuM883OF
	 eDPVAzei1MwRQ3zrPMC6iJtwTLnra4S1r+ynnj7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 164/313] mmc: core: disable TRIM on Micron MTFC4GACAJCN-1M
Date: Tue, 25 Jul 2023 12:45:17 +0200
Message-ID: <20230725104528.035129127@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

commit dbfbddcddcebc9ce8a08757708d4e4a99d238e44 upstream.

It seems that Micron MTFC4GACAJCN-1M despite advertising TRIM support does
not work when the core is trying to use REQ_OP_WRITE_ZEROES.

We are seeing the following errors in OpenWrt under 6.1 on Qnap Qhora 301W
that we did not previously have and tracked it down to REQ_OP_WRITE_ZEROES:
[   18.085950] I/O error, dev loop0, sector 596 op 0x9:(WRITE_ZEROES) flags 0x800 phys_seg 0 prio class 2

Disabling TRIM makes the error go away, so lets add a quirk for this eMMC
to disable TRIM.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230530213259.1776512-1-robimarko@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/quirks.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -98,6 +98,13 @@ static const struct mmc_fixup mmc_blk_fi
 		  MMC_QUIRK_TRIM_BROKEN),
 
 	/*
+	 * Micron MTFC4GACAJCN-1M advertises TRIM but it does not seems to
+	 * support being used to offload WRITE_ZEROES.
+	 */
+	MMC_FIXUP("Q2J54A", CID_MANFID_MICRON, 0x014e, add_quirk_mmc,
+		  MMC_QUIRK_TRIM_BROKEN),
+
+	/*
 	 *  On Some Kingston eMMCs, performing trim can result in
 	 *  unrecoverable data conrruption occasionally due to a firmware bug.
 	 */


