Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF8D1B4F1E;
	Mon, 14 Oct 2024 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917334; cv=none; b=C2WVKNJSuqbH3M/w+fM4AMFMO4ogRuUoY4A6OLmxpWQ6LCNm7AMC8697A8g1EzLA5gTskh0PWCrVlHzsyhM6NrB89WVACluw9JHKdAx+jzKP9QwDCz3n8Qabjh4bXurEvY0A96oLIm1rlUiqwBGdEsUqHYJI7TW/IQi6Uz3SKs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917334; c=relaxed/simple;
	bh=DjzQ0GOyOc1FgGmFykqDBuqxg6GVs1QaI1jMuskdsps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBjceV+D4Y2sXWR9Hcc8mi2XF7qj1y6asAaAdohM7ocq1OFe5RpfUCMsinyheihkSfIqHxP0iq167FMZs3BtjWFk54isXZ38bHY6O22Mvzi7GXq00wdJguQQMdLPorM1z3lPE+lg3j+8JkJKUFNKtKKQEUw9Cc6HvtseLToR+zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlp0bghV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlp0bghV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622ACC4CEC3;
	Mon, 14 Oct 2024 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917333;
	bh=DjzQ0GOyOc1FgGmFykqDBuqxg6GVs1QaI1jMuskdsps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlp0bghV22gY6TlkkPB4j0hufzZWFJUrvXEXCnb14PwJY4Yvbl1CYe7f3AV3RRd2c
	 ESZmKSyL3egdFgU4Gd+meB3jE1ZnT8J97hU+cvU9J+111jVafLLqH0cW5N1pjgGPeM
	 oX7BlUH4ZsTHfhRyfKQuQzfAZ7vTZF5eJvsuiKIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 213/213] scsi: Revert "scsi: sd: Do not repeat the starting disk message"
Date: Mon, 14 Oct 2024 16:21:59 +0200
Message-ID: <20241014141051.273396615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit da3e19ef0b3de0aa4b25595bdc214c02a04f19b8 upstream.

This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.

The offending commit tried to suppress a double "Starting disk" message for
some drivers, but instead started spamming the log with bogus messages
every five seconds:

	[  311.798956] sd 0:0:0:0: [sda] Starting disk
	[  316.919103] sd 0:0:0:0: [sda] Starting disk
	[  322.040775] sd 0:0:0:0: [sda] Starting disk
	[  327.161140] sd 0:0:0:0: [sda] Starting disk
	[  332.281352] sd 0:0:0:0: [sda] Starting disk
	[  337.401878] sd 0:0:0:0: [sda] Starting disk
	[  342.521527] sd 0:0:0:0: [sda] Starting disk
	[  345.850401] sd 0:0:0:0: [sda] Starting disk
	[  350.967132] sd 0:0:0:0: [sda] Starting disk
	[  356.090454] sd 0:0:0:0: [sda] Starting disk
	...

on machines that do not actually stop the disk on runtime suspend (e.g.
the Qualcomm sc8280xp CRD with UFS).

Let's just revert for now to address the regression.

Fixes: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240716161101.30692-1-johan+linaro@kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3955,6 +3955,8 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -3971,13 +3973,12 @@ static int sd_resume_common(struct devic
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);


