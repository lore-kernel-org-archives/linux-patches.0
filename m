Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5900A1741D1;
	Wed,  3 Jul 2024 11:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004813; cv=none; b=oiz44uZXz7ONc9YiXNpmSofL2Y3xKsV+/qvSnYatkGTEopP53omZVNERYCaZhJcDiDCP9XC6m9SKeQfLbTWp9oCh1atT2OMcQroSLyp0LcJTFYWB0fqReCpqHKm/Iyihr1t30r+OFTH7oYGqgVQ5bbDwJ/WIxoqi2307RDxGzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004813; c=relaxed/simple;
	bh=SuYC1QjaU1I0RFxIQFsPuqmdlZREJ/YXqMeEjNCJYiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FltJStJT86vrDMUOzt1Z9VlskbkXyfvXZ32C2BR8YaJ0K9CDzc1mrBtv7pSqFgL1bxPh62odI3/4YjFdygyMGeij+znamMGxcc7nrLu+rGb64yPDiundXf0CWa3spZp4RMmTHSbnKpigdkK3lp4JJ8QBsDg3Im1s1IDQp8QRFfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5jJlSfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5jJlSfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D2C2BD10;
	Wed,  3 Jul 2024 11:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004813;
	bh=SuYC1QjaU1I0RFxIQFsPuqmdlZREJ/YXqMeEjNCJYiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5jJlSfga6u0WYZTI/g3HqC7Y8gRksH1vrCAyESj1q9+GszZpWmC3Jk+15ICQTYWB
	 SrJInMxZcbH0slAiUNBIdoKCINcfmd9sEf8O/pVlHg3NR5cj2D1l6i+wEM0qgj84HQ
	 BZsMNMsi6JHaY4QbejKDXRETCXIYZR4LkXHohZ34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 168/290] i2c: ocores: set IACK bit after core is enabled
Date: Wed,  3 Jul 2024 12:39:09 +0200
Message-ID: <20240703102910.521810956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Tertychnyi <grembeter@gmail.com>

commit 5a72477273066b5b357801ab2d315ef14949d402 upstream.

Setting IACK bit when core is disabled does not clear the "Interrupt Flag"
bit in the status register, and the interrupt remains pending.

Sometimes it causes failure for the very first message transfer, that is
usually a device probe.

Hence, set IACK bit after core is enabled to clear pending interrupt.

Fixes: 18f98b1e3147 ("[PATCH] i2c: New bus driver for the OpenCores I2C controller")
Signed-off-by: Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ocores.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -443,8 +443,8 @@ static int ocores_init(struct device *de
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }


