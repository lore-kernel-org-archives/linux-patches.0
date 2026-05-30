Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA8732BF24;
	Sat, 30 May 2026 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160107; cv=none; b=hzUOeIMKd3HQ7n9XTcDdEhnOSAKJ6g9aDusLVfEdCao6zMspspa1DJ61dnQm/lGOiGH/y5NT5vYhMLupA8dONPp4KyJFh/Iz2DjZ74k0P3Cj67t4VFMgibdw2XUwbf1c1B0aZYsA8HL4oeKsGM++8X3OhOj+alZhdnUXkhvxU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160107; c=relaxed/simple;
	bh=7IDFYasl0gAyMuo35y7FMsCEbI0sY1pGhmlecYOPp4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw3FenKUiLZuxqeTiguTKjDg/oLi+GNASnKb8gZYV50BMJ2lit/3xOQv4SVqq6SMp1oocIh0cX0n308MogEhIKofGQ9zYzAx+jJvJF9nX+UkIlwkFRK8sTEHILZkSP1mBE4HTolwXY1iWp74rTfEE2u+mJk25+MIeXBWf0aAr/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMUvIi+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMUvIi+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C37B1F00893;
	Sat, 30 May 2026 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160106;
	bh=+XAtXTrfRfbgV/6OmCy/wusuN4dP9xjBv8D/HWLNApE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMUvIi+cN6MP8cR8/gTWUDORt7QF5iSIMgf2jKhFy2wZFdzQxh85UNetF8hN2svoE
	 rxTeN1YZk+zhYf9BSeuz9B9i4hR9CxokNuzlaGZN7BBEK1W8nTGFBKqm3th+lCnnsX
	 42TNnFUy7HizRoMgIVfBVx35u8R7qb12vKmAQsPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 229/969] tpm: tpm_tis: add error logging for data transfer
Date: Sat, 30 May 2026 17:55:53 +0200
Message-ID: <20260530160306.778980539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Jacqueline Wong <jacqwong@google.com>

commit 0471921e2d1043dcc6de5cffb49dd37709521abe upstream.

Add logging to more easily determine reason for transmit failure

Cc: stable@vger.kernel.org # v6.6+
Fixes: 280db21e153d8 ("tpm_tis: Resend command to recover from data transfer errors")
Signed-off-by: Jacqueline Wong <jacqwong@google.com>
Signed-off-by: Jordan Hand <jhand@google.com>
Link: https://lore.kernel.org/r/20260415160006.2275325-2-jacqwong@google.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -441,6 +441,8 @@ static int tpm_tis_send_data(struct tpm_
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
+			dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be set. sts = 0x%08x\n",
+				status);
 			goto out_err;
 		}
 	}
@@ -461,6 +463,8 @@ static int tpm_tis_send_data(struct tpm_
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
+		dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be unset. sts = 0x%08x\n",
+			status);
 		goto out_err;
 	}
 


