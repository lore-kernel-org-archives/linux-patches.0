Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25D91A9B58;
	Thu, 27 Nov 2025 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254862; cv=none; b=plmc6kG77GtEjOMnbTEqeGwaErZLGxNNI7i2jEX34gbOXyX/rGgwaOswBCJoTLovfr0oIm2+/ypY9jtnHQTIPzhf/bky8pIWSjwVrVQssKSIDY88gSWVtNh9Tpp7cKsfzWyPBAZtqUq9zkJ7fBzeSlgIj6L05PSiD6UR3KPkQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254862; c=relaxed/simple;
	bh=muZ2lGeRj5jYtXsmEhnouc30Ki2kJFyLaYmpBn0egG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL9jJXqGInoLeK7aa1/Z65Wc4Os81R4838dSStg307J/GGClgVEIp6sX2ulaJhD7AfJ6LI0D1jwV6gOOYODhF2VtsI2oCcC4xvxWDFhpOa+wWNzjMiKZRDdfum5q1eiROGfKQ8RGO3cVrb7m8n0etnQRcPYycJx8TVgo9kzCdGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4csuMch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4csuMch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EA3C4CEF8;
	Thu, 27 Nov 2025 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254862;
	bh=muZ2lGeRj5jYtXsmEhnouc30Ki2kJFyLaYmpBn0egG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4csuMchBuqk8uJog5lJwIOeMYg6VxDgB1X0ztdVuTxKIwC5VSz7P+mag6+hrfoBm
	 yhW3HfTnSDP8/A3VR2ZR8EKM38OsNFVkQ4Cix8wJKEP5kUmpDykjp8g0fAJXLtaWX0
	 BDcHgvOjSzd6CnIdphR5gJBlDhKAbNzXifzKuXmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@h-partners.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 12/86] ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()
Date: Thu, 27 Nov 2025 15:45:28 +0100
Message-ID: <20251127144028.266542045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4838,8 +4838,10 @@ void ata_scsi_dev_rescan(struct work_str
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


