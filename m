Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB31634BA24;
	Fri,  7 Aug 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115258; cv=none; b=lHHDRmpP+ADDRfWl5ttkZHQVJtR7Cc+P0M1rckZGUo69OZu/V+tPTadzsLSHLfyT07SdqRCJA9bicjrcL+dXRSWy/YfWgHmCE2+nONQsB6buA5Wg0lzQA0UiaxTnxeWqnkoDfxOonh46764ev/HZ0hTb4rWWiwK4dbl9ZLbhvjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115258; c=relaxed/simple;
	bh=GWdU5Gkzfw1ctCwm4k2f2y4Ytaeu30m3eyqoxOSyOd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBpYuW/go6lTHcG9F7Ac1gegAadabn8R3kUrh7z1eYEub+Qk6+YLOJWCuaYbTXPGWL3RpezwBrUGj/4kdqseH4c4aDtjI1GnbBGKk4saDFx2IKoYN5LlUjAjVD7EZcVRon0Zp9ibYfXiTQq/dnFb0MHnTxMkGoQAKWJ4QsW8w7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydLZkCLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydLZkCLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44E01F000E9;
	Fri,  7 Aug 2026 15:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115257;
	bh=xURoC6boqQNV8LB2kmRQZ2dBh79jDc2XATlp0+p8Bs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydLZkCLS/CMIZTs759OtrpwgPwooM3Iz/NTX97FnwJZRL9ud2Lb//IY9cZ9eYdUgK
	 s264ei12PBfkS16ZbqIpz8Bqjk0/90PmVV3M61iNbwOIsgbg4oiRnhvOSIQcGjwCL2
	 CRsI3BPxawdCB6Ip1jIguvwrlpb/XGO3nBO64q+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.18 213/396] ata: libata-sata: fix ata_scsi_lpm_supported() iteration
Date: Fri,  7 Aug 2026 16:36:13 +0200
Message-ID: <20260807143428.863575574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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


