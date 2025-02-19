Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A141E0DC3;
	Wed, 19 Feb 2025 09:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957451; cv=none; b=lEiJlIy0Z1kj5rA8GSEOSAZLqnGP4cm6YdrqMbluAL1xnD8aeF+f1w4zr6exYq/khoy+wgjg3hSI/ryNIxGcA8JhKu67crfJjb0WhjoZZZW6b7q8qiI/dH+4wt1Xlg/oWLod3Ljt4wV3Otncz/SbExWI4Pg/hiIIvDr++wNpyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957451; c=relaxed/simple;
	bh=/vG6yiaTnkmM9pZGUqatPEJZZxaBu8wglNiajPkrZdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7OmFfq7GyY91TrQNSqGkryDLo/TrvDch/nI85N1PnIKiLM/AmchIUjOGCDkwIesxtxtfAk4SLmxWVJxhyq17bx2DM1dEQfgEYLkL1BrZwC6wHs8XsSZZWcyukJH3ZjY8MEJSconRWOpqIUdhH+0ZeaU7+/DwZpP/OxP3osAVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUpMY31C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUpMY31C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E3C4CED1;
	Wed, 19 Feb 2025 09:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957450;
	bh=/vG6yiaTnkmM9pZGUqatPEJZZxaBu8wglNiajPkrZdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUpMY31C6mFhLVZCXE0GWXOyWjLQh+YQSP3YbCh17wsV0ZWycgoZsTdqxHUWZvbmw
	 aKLFaGpdU/86fts1Uu4YZCS6Q1ycy4N/O2TEx87LxoGiPyMoDmyxwyegnLjSCH9nMc
	 TAWIKxCBAh0o7RGshA+GD9d7+kIAIy17hNuX5XuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 531/578] regmap-irq: Add missing kfree()
Date: Wed, 19 Feb 2025 09:28:55 +0100
Message-ID: <20250219082713.866891253@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 32ffed055dcee17f6705f545b069e44a66067808 upstream.

Add kfree() for "d->main_status_buf" to the error-handling path to prevent
a memory leak.

Fixes: a2d21848d921 ("regmap: regmap-irq: Add main status register support")
Cc: stable@vger.kernel.org  # v5.1+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20250205004343.14413-1-jiashengjiangcool@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -1059,6 +1059,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	if (d->virt_buf) {
@@ -1139,6 +1140,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	if (d->config_buf) {


