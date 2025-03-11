Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2A25D904;
	Tue, 11 Mar 2025 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707093; cv=none; b=XhcGYNgXn8hKzM0PstXhn8agPi+j/T0/hzu4fQmj9wZ9AqYwAQ7LM3NQnIoUrt+FCMNLhnzRTxAjDZ7Eu7sdwXacPBJiAi/jh5nsvx/EMmquuzseRiGpJuhID/pc4ribtjiFd4q3E1WGSFz5B9cEjx79cPJGg0NaIj00nL2ndGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707093; c=relaxed/simple;
	bh=Zs1908dru2ChVGRDYxFRs6qp8nTX0hBw0bvrq8fYCWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jA34RU0l8SLHo7nfTksvutsVg+AWWOxSFCtFTlkYeD5K2jzyHm9uPXU8WLyY32qRw5d7TALVvM/gBsi/pkmkEt6ybczE5zuHpMXLDup3cvBUZRAfAn2+xZc+d2k7/ENdEDx6YFsrx9GKGbrkvi5wY8e0cu0HhvGgIM7E1tUoZ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgftPmHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgftPmHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6E2C4CEE9;
	Tue, 11 Mar 2025 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707092;
	bh=Zs1908dru2ChVGRDYxFRs6qp8nTX0hBw0bvrq8fYCWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgftPmHq/aHTnhsQW6AzqU6HM/av8iiyxqGN9wQPfyMjNeTBMSxEYmJutgujr1VpI
	 wDBzuSNQsgqeSCAkrKmZxGZHbwGZ4tHFtjvfzkeyoqsuIIVy5gV7YhqX7pqklmDITo
	 ZWQB7lZYCAuKmCW2mn9IPtqmBXP+LNbLOkmXHNMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 271/462] regmap-irq: Add missing kfree()
Date: Tue, 11 Mar 2025 15:58:57 +0100
Message-ID: <20250311145809.071491823@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -834,6 +834,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d);
@@ -904,6 +905,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);


