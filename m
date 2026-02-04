Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0305D426D39;
	Wed,  4 Feb 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218435; cv=none; b=fSwd7PANp8D2SiGUfTljYPeX5wkIofaL8Jhx4V4SX/PgezAz5kXUduYrW9iH5xEnHxk6QWUo+sWSQPw+70lnjuHZw9PmgpgFYmmvRCpsU08ZdukEFVxYD5noq4bcx35/esdaha6XnmpFcdvTd6G+oe7p1RcLNR+gi4iKCpgv7is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218435; c=relaxed/simple;
	bh=fD6YUug5r13c8Y54XuthN1ag26Y56YlYhHHFe2/GGr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzjxnWw5dtWcTQGprC+3bh1EGRRt/2VPTkuRKF1MXol0RiOp4Cm75+0v89JwEajB2PWvz9GcPbFxaHdMNeEfUK2Y6FTQjaDwv1xbtwZ/Z/z/JbJIgpycwIwnK11PiwYchus4tt9N8zC22s2G6gZhFps2DGTt7XC0C5D4dQ5ruyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1T6YEkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1T6YEkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA6C4CEF7;
	Wed,  4 Feb 2026 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218434;
	bh=fD6YUug5r13c8Y54XuthN1ag26Y56YlYhHHFe2/GGr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1T6YEkjgS8dbWo6KVGTfV21qtGwQsXaHSp0Z22vR/GZoKuqLt1TiwoiwtwKIl1eF
	 QoobuKrjdeGz+y+WOgdkUN0cBiuxof2jgRyE50yceEm0T5/PCU0RrU/n13JJSbdadg
	 iKDaBeVpd7LRsAZ+s2/op5fVjsQp+4CcYgjFhV6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Larsson <martin.larsson@actia.se>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 29/72] gpio: pca953x: mask interrupts in irq shutdown
Date: Wed,  4 Feb 2026 15:40:32 +0100
Message-ID: <20260204143846.682265107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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
@@ -811,6 +811,8 @@ static void pca953x_irq_shutdown(struct
 	clear_bit(hwirq, chip->irq_trig_fall);
 	clear_bit(hwirq, chip->irq_trig_level_low);
 	clear_bit(hwirq, chip->irq_trig_level_high);
+
+	pca953x_irq_mask(d);
 }
 
 static void pca953x_irq_print_chip(struct irq_data *data, struct seq_file *p)


