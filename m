Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A6647DF8D;
	Fri,  7 Aug 2026 15:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117408; cv=none; b=n0fg2tpfdMuK94QxO3fKZj/xfOVylngjg3n2lsIfPiSgfH+aMW/fSFXY3VaESPRm3QO9FF6CWvpKHBXepr7aTlwhuaZBIsF7w12XzhZ6bbT2D3KLLhsLujIkWn0SnwOoOmbD/XRe+BQYw/6+PN1cH/ehc9qqYEMBMWFlvUIC2+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117408; c=relaxed/simple;
	bh=MYae/2ikEc0ZbQrYW+e1uQxwsq3Gq9KcsGK+6zqiT/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVvwhM8UqYupm3vUZTjNbW7ujGzeyHW0CaUwfJPCQKJjHe8DvciYNHrkFeHffXd1TKaM0YUUhCPYrqjql6Yt8kUp393YvfyP1bM6xox4RJd92y/B9XFH/5V/kf7HF4Ed3r/uFZ28aAFp/94gBEOY6vllk0uGHIVtXERrBstvcrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp3RHS4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp3RHS4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A401F000E9;
	Fri,  7 Aug 2026 15:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117407;
	bh=7XDSUMnun1hQzzJGftOjGjuIOrGnHd9bVW2UqgY2yLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zp3RHS4mMmjIXzoCNIRBTw7afbBEPA+kqz0fh1Wh5n3Swh3hEPtnbROa9bYWpFBtP
	 rdj9E8i6noGIli6LDPfFsDrNSLTSU9CtA9lYtCLUYgCKOXKeVqpwyk25fda3J236rM
	 rJy/07Iq4b4bclU0V7e+h0w9B/xJ6ICcOLUQe+SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 264/438] ata: libata-sata: fix ata_scsi_lpm_supported() iteration
Date: Fri,  7 Aug 2026 16:37:40 +0200
Message-ID: <20260807143433.619744686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 3fd70e96914d761c17c376aadd0b0d1a3c9badba upstream.

The inner loop of ata_scsi_lpm_supported() uses the wrong variable when
iterating.

It should obviously use the link that we are currently iterating over,
rather than always using the host link.

ata_scsi_lpm_supported() is used to control if a user should be allowed
to change lpm policy (from the default) via sysfs.

Thus, this bug could potentially disallow users to change the LPM policy
for certain SATA devices via sysfs.

Cc: stable@vger.kernel.org
Fixes: 0060beec0bfa ("ata: libata-sata: Add link_power_management_supported sysfs attribute")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-ide/20260728112200.B99F21F000E9@smtp.kernel.org/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-sata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -913,7 +913,7 @@ static bool ata_scsi_lpm_supported(struc
 		return false;
 
 	ata_for_each_link(link, ap, EDGE) {
-		ata_for_each_dev(dev, &ap->link, ENABLED) {
+		ata_for_each_dev(dev, link, ENABLED) {
 			if (dev->quirks & ATA_QUIRK_NOLPM)
 				return false;
 		}


