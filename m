Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB382D8763;
	Wed,  4 Feb 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218721; cv=none; b=EJJ1dClvAnmTeICaB+J/sOqJyjribpx2OJZVNnIi1Q8letBWIU6nWj7eqxnxZZP1F4I6cwCSIn2O6mrXgE8na6QvEHFEf8aAcHpL9EC9ROuog+SQPk+9fMcsBXWCcRQ+ouqgAkFhc5ra86mNRwJMohOIZY7RjTn5Pvj4RdDgqjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218721; c=relaxed/simple;
	bh=4hASMqAiwQ3/jhwKuC5iXe9kLVqLOsI0edLFpwKBcyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNoIes2tU3m2V2XNUiTVfNk6UMxw8UP3WPoJHKxYdvrwstkh8P40EtkFrpBOpfS3KT5gQm4GVxmN2Dl1dm2i+Hli/WlmPgk7pcgY5DDuPfeArQ36+L1XgRe+JbWxjBnsRCUl1pmuMZpC2HXGCs0JVfpxtt0mjnHd5NoosPS53Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBZxjEQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBZxjEQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A28CC4CEF7;
	Wed,  4 Feb 2026 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218721;
	bh=4hASMqAiwQ3/jhwKuC5iXe9kLVqLOsI0edLFpwKBcyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBZxjEQgqqZXwcDM4eAxmyMKsB7TKuFqzhF6/aN59bB8XfPCFav+KQLn4Hmh+uCDh
	 Vp+q9mngvI/nr1eMRHFmNweFW+LMhDyXulwGsy5WBCdkoN2rEflWrXu6NoKi6kepcs
	 kJNYKKV5N7vyI/tGy1sFlvuDR91nbBvmXHsqVMGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Larsson <martin.larsson@actia.se>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 41/87] gpio: pca953x: mask interrupts in irq shutdown
Date: Wed,  4 Feb 2026 15:40:39 +0100
Message-ID: <20260204143848.393128979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -817,6 +817,8 @@ static void pca953x_irq_shutdown(struct
 	clear_bit(hwirq, chip->irq_trig_fall);
 	clear_bit(hwirq, chip->irq_trig_level_low);
 	clear_bit(hwirq, chip->irq_trig_level_high);
+
+	pca953x_irq_mask(d);
 }
 
 static void pca953x_irq_print_chip(struct irq_data *data, struct seq_file *p)


