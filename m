Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BB59443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B715C433C7;
	Sun, 13 Aug 2023 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961861;
	bh=HXglDCR0bXRO0+kfU3gmDgzDz5YsPpMcER/unWMgpKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgMZHiWdlW9E6xizzZLyVwm6aSy+tf74A4MC1rcRbF5WepsVZtvpWnws++Dbl9w2K
	 iEp3H9HbYGeGc0R/s66vMQhi9ofXiK7k7PhleBu5zQwFmPBsLrOEYe1NvjCEhCz3Vg
	 sWwCaYVD0P+YFtLhBg+LNtM9IszqyPKM2kekH0JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 003/206] tpm/tpm_tis: Disable interrupts for Lenovo P620 devices
Date: Sun, 13 Aug 2023 23:16:13 +0200
Message-ID: <20230813211725.072395309@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan McDowell <noodles@meta.com>

commit e117e7adc637e364b599dc766f1d740698e7e027 upstream.

The Lenovo ThinkStation P620 suffers from an irq storm issue like various
other Lenovo machines, so add an entry for it to tpm_tis_dmi_table and
force polling.

It is worth noting that 481c2d14627d (tpm,tpm_tis: Disable interrupts after
1000 unhandled IRQs) does not seem to fix the problem on this machine, but
setting 'tpm_tis.interrupts=0' on the kernel command line does.

[jarkko@kernel.org: truncated the commit ID in the description to 12
characters]
Cc: stable@vger.kernel.org # v6.4+
Fixes: e644b2f498d2 ("tpm, tpm_tis: Enable interrupt test")
Signed-off-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -164,6 +164,14 @@ static const struct dmi_system_id tpm_ti
 	},
 	{
 		.callback = tpm_tis_disable_irq,
+		.ident = "ThinkStation P620",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkStation P620"),
+		},
+	},
+	{
+		.callback = tpm_tis_disable_irq,
 		.ident = "TUXEDO InfinityBook S 15/17 Gen7",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),


