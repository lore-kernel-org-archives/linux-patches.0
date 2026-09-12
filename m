Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53BE344DBD;
	Sat, 12 Sep 2026 19:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241687; cv=none; b=a43yrSyHUF55NisbON3Zfc8KKpz3+qq7tV7iOCCFhhKNa+2t7NTPWtJATnDLMkQPbjwo5lNvhSumNSs66+1j9r/Qtz8xdkAdpfboevFyY4h0frnezLH8NF3AAfBNDU4py8Mc2vxlwSh4NYgfngAPqYi0/uJ5bxSf8Xz4AGLnf1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241687; c=relaxed/simple;
	bh=YIWhAbcUFgWgPftvJZJaVY2jPO91ly+CRss3rXkGKQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWAXUDn629K/9UyTiDxrgDR2Q3mjleO2zAYEzBifImpn2vqUr+4bBuu0lLEKYeM8KXbPeFL5lfLREYGe4wCBNJCLl7WfiDSkSsIQ0ETPgfj30UmKxxutFOqhH4D2T1o2vKlnNMrGnQbQB+o6Wfj9H3lCy+RThfliwgeU6r36IO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LX6rnjc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LX6rnjc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECA1F000FF;
	Sat, 12 Sep 2026 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241686;
	bh=0ThYyFPh4TZOimnZdHwKgzAyOsFuQYIkQO03fgL0g5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LX6rnjc3QJvpLMouDBZjfL3KabUMq8rJZck33aCVnAYgzA6lxJUSPTBs2TFJqrjKl
	 KDzilUoBk0rbCA9pMF+LTSoOGGZY3NpXiHcEYycqyQ0rN8F+MLxV1UYH06acqSbb/a
	 dyRK7sy1EAeHraotbBI2iJYst6c8fzlpY8y7FcCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 186/798] tpm: tpm_i2c_nuvoton: disable IRQ on wait timeout
Date: Sat, 12 Sep 2026 08:56:54 +0200
Message-ID: <20260912065521.306934002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 705c4ed0643366963547b2616d53165f2519c81f upstream.

i2c_nuvoton_wait_for_stat() enables the IRQ before waiting for the
interrupt handler to report a status change. If the wait times out, or is
interrupted before the handler runs, the function returns without
balancing the enable_irq() call.

Disable the IRQ before leaving the failed wait path. Also preserve an
interrupted wait's original error code instead of converting it to
-ETIMEDOUT inside the helper.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 4c336e4b1556 ("tpm: Add support for the Nuvoton NPCT501 I2C TPM")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260626091653.54929-1-mhun512@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -181,8 +181,10 @@ static int i2c_nuvoton_wait_for_stat(str
 						      timeout);
 		if (rc > 0)
 			return 0;
-		/* At this point we know that the SINT pin is asserted, so we
-		 * do not need to do i2c_nuvoton_check_status */
+
+		disable_irq(priv->irq);
+		if (rc < 0)
+			return rc;
 	} else {
 		unsigned long ten_msec, stop;
 		bool status_valid;


