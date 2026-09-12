Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DEC3914EB;
	Sat, 12 Sep 2026 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227957; cv=none; b=QP1KoC887JUTuv8y/FeSSbVu2aFL7eWcfQ1MAToqcc7XmQNDmsSRiCT7pX10dSVtgSyD4rYkbw/PIJHHL1ZtBqOYanyzoL9SB7NVAXEPANpJojSRKx0eUKTlUtmJn5vHi0toUZovngI6qJMLACkz/ngt8ia0+JUlSn4dVjbbbvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227957; c=relaxed/simple;
	bh=zuIxQFjToRLQTlD6d+YVCXVJJqt852KL9RHPWqstENE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqnjC6nbXx6J5isACOPG7FZMujiKrILtHaxBPSxO57LaIddYV0ofUyaBvogx2bfxNFdY+qb9ZMWPuPxNZ5U6Tzdfhg+6O73+7OLHwCdyIBc3N6DbSfEjwAfvMkLyAHp+0wzdKBzVrxP0DpJgj2daqp9NnsqqfA6bKUZIfcPsDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhj7CLzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhj7CLzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B72F1F000FF;
	Sat, 12 Sep 2026 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227956;
	bh=+LTu3WA1QysRkIwhg9jthncI/VKtPMQMozI/NLUIhMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhj7CLzrKRSSYSNJrWLTsLhTt9g0RmdKjJiI0I25IlsLMjJOkYhQPMQIMV12dalwg
	 yTp1FEYWNkguJLIEpaf1f3OGZnvhGl5t0ix1TNyT9qYF5LVIDYR35IEr41ezqmmN3+
	 Dz1UwUlcvtZCUGILUXHo38/uCIiTUb2eof55CqPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 0245/1191] tpm: tpm_i2c_nuvoton: disable IRQ on wait timeout
Date: Sat, 12 Sep 2026 08:49:33 +0200
Message-ID: <20260912065553.717569048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


