Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CF34677A;
	Wed,  3 Dec 2025 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780023; cv=none; b=KYbQR2s4GIwX7NRcXUD9QjwO7XmlyjbwNvpHrQuzb3H8LXp4wMuzxWs+RoncAn96F81qZDUWQsMVQgc/C4WEfKXnysTciufPsmZehOECqrrojMbl7nTRCv4lnEaqTgqSgq6rhP9Lhaw5P/h7Dw8epghsdH7/mhYJcnE9IMiD//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780023; c=relaxed/simple;
	bh=hY9bpA6Na7jhxE4+D0qWptcqsYmEqHNQQWoHv2SGadY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUJu7K3LH6PLGAKBMreFoqSFJc8yU2Te5AgpS9lwJ9XgJXetarE1npeoJY93Lf4D1IqSiNuwnrJ9yW2yzdw4/Z76KhhbPgxa5eo2l9SX5d/wFfj3Rwx/B5yccCY2r7jdYe5aAXkVzLud5IJEdWdWIEJD+Gj6mRvNlefqlDe+xa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pAenoaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pAenoaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA427C4CEF5;
	Wed,  3 Dec 2025 16:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780023;
	bh=hY9bpA6Na7jhxE4+D0qWptcqsYmEqHNQQWoHv2SGadY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pAenoaHhF49uTAu66GJc9ZcDtXhjYsSGLNnz+izS594IMWDGtz2ShVrZZOx3by3i
	 Wew4Xr7EQQo3ig3wSkH4ckjUs9+kX7lhRaPZodfjQj9CoW5wBSNoJ5fA9WATK6yGZY
	 ndJi7Kdf5fjhAG4Hk7RfzYuQuySRfMQnaE/N3NLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@h-partners.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 433/568] ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()
Date: Wed,  3 Dec 2025 16:27:15 +0100
Message-ID: <20251203152456.555923247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@h-partners.com>

commit b32cc17d607e8ae7af037303fe101368cb4dc44c upstream.

Call scsi_device_put() in ata_scsi_dev_rescan() if the device or its
queue are not running.

Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Yihang Li <liyihang9@h-partners.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4683,8 +4683,10 @@ void ata_scsi_dev_rescan(struct work_str
 			spin_unlock_irqrestore(ap->lock, flags);
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
-				if (ret == -EWOULDBLOCK)
+				if (ret == -EWOULDBLOCK) {
+					scsi_device_put(sdev);
 					goto unlock_scan;
+				}
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);


