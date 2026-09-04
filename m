Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E2D416878;
	Fri,  4 Sep 2026 06:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501813; cv=none; b=hu1Vvz1v7rNWbz4GoyY1C1dXKh4gv5003NPlGIRfAgHosWJu4YQ+0E4lkkem/CtL44PZzYhjIi3WuKPZPEvNIeHkxiBgmxJid00udOxLJBFy50sRb34DFm5cGeLG4vtHNn0ejDuikb/A51qpfjVQGpsRqvf7FR/Tb5sAgo1nmho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501813; c=relaxed/simple;
	bh=J44rcLTQnpwDeTPvUUmwJCIl8S85eYwlVZD2xHNj63Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgoPuzGLH1nowWw6YZCuEHFndO6R0kqB3c6kyxl0oP0Aaiz0Yk+xjaFHjBDK5gEqUyFGHuf/21PdWzJBcE1w6L0IKOLLZ8ZgmBaxGyz4FU3tjrM9hmSM60QBeri3SbalM6Pn3hVft23NfggbV1qQuRqWeP6M0mRDep/hXBKCF54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdlXYBqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdlXYBqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E611F00A3D;
	Fri,  4 Sep 2026 06:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501812;
	bh=cubmWU/O6hdzH/d8GzMUhcLtSWLI6OXwiw1nCFHOiIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdlXYBqAgM99k8oAFLkZ2AtcKCXN7lHnXdX95amlpHAW/QAjiQ73ThHYR8cFk5EJE
	 3RZnkrl+m9gCTqXWB1VXLkJ288HFlKNhaKiz/LXgV7vhZZxXT4DzL6nZokWV7pzZ3k
	 N6xUXCpARI+4iwHZc71fex33DNfAZD+MC/gs0H1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 542/552] tpm: tpm_i2c_nuvoton: disable IRQ on wait timeout
Date: Fri,  4 Sep 2026 07:01:39 +0200
Message-ID: <20260904045802.895667120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -182,8 +182,10 @@ static int i2c_nuvoton_wait_for_stat(str
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


