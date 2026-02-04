Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16F2D5C91;
	Wed,  4 Feb 2026 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219110; cv=none; b=lSvC36/w00IbR1psyQFeSy3RdvWyInJvMBVR54O6r399yeNitREoht0+o1sPDdca4TcNDllVnZyAeJ6HFohEICvkTCAhkLGIQ3pdyu7Atetoa8WRA8pC1M36feiej6iNmimMEtlGct9XZZyaRdHvKTOSHqsI1Z1o1zEKz/jKxYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219110; c=relaxed/simple;
	bh=UjJyfMwDvD0R/0Ooj8RCBbT4qodg3Bz/WsD328EQRdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5F/tGkqeEpz911KOVSwquoTbVwUn1jaBZFfRmA/kRpV90FmhA1jw9vJYcIv2rLcaJbvJyRag43aYd6xSkeheymBuNewkb13hZt7bYDGTjmGtzpoBVRBBLaOeRB88dgHHdHTnkxOT5Zxf1rGz45vmD+t6haQQOHiU1ESPyKDmkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GogY/JvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GogY/JvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282EFC116C6;
	Wed,  4 Feb 2026 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219110;
	bh=UjJyfMwDvD0R/0Ooj8RCBbT4qodg3Bz/WsD328EQRdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GogY/JvODWwI113KHk93+Wj4zK9OcU6vVFTbNCJSLbIx6wqKL0xL51VSIuexVlorQ
	 58BBZDTcMjJllq5UXXowwLnaZ810kSlTgDPJJIgeWifsjFCXABVXpZJExvOCDYXFj5
	 gQHsmYwQxngdzoMS8+NHNhp0DrHHDotTjtikA/Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Larsson <martin.larsson@actia.se>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 071/122] gpio: pca953x: mask interrupts in irq shutdown
Date: Wed,  4 Feb 2026 15:40:53 +0100
Message-ID: <20260204143854.407204989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Martin Larsson <martin.larsson@actia.se>

commit d02f20a4de0c498fbba2b0e3c1496e72c630a91e upstream.

In the existing implementation irq_shutdown does not mask the interrupts
in hardware. This can cause spurious interrupts from the IO expander.
Add masking to irq_shutdown to prevent spurious interrupts.

Cc: stable@vger.kernel.org
Signed-off-by: Martin Larsson <martin.larsson@actia.se>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://lore.kernel.org/r/20260121125631.2758346-1-martin.larsson@actia.se
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -911,6 +911,8 @@ static void pca953x_irq_shutdown(struct
 	clear_bit(hwirq, chip->irq_trig_fall);
 	clear_bit(hwirq, chip->irq_trig_level_low);
 	clear_bit(hwirq, chip->irq_trig_level_high);
+
+	pca953x_irq_mask(d);
 }
 
 static void pca953x_irq_print_chip(struct irq_data *data, struct seq_file *p)


