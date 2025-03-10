Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9EB17A2E8;
	Mon, 10 Mar 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629721; cv=none; b=SmZmpnlnkW+r6OGO6l95o0W/eYd0OfyJj1yHBDPhEslpu0c9BPxzPWSifOtDSSZ5suOdCwb1mR4Jef5V/EeVHlPrENRqF0GJq/eVTbZKgjxST7BaThKPAOtwoC+yyX5C93AexEDJUkRwska6k8FFTxsTt9oMKC5pFfmQFCim8+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629721; c=relaxed/simple;
	bh=02y/wQoRst6YuTksMYQnkgF2MlSEfGc4u6mYrw6JNuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGdcIGvaPdBcKN9Oce2VPHlMiJlyXvWdHTiYf20ImdIUMw0LVmd5NcPFQkfWE95t5IYzVp+cv/jbdljWftX+s00DGjd8vTLNBhbwYfdi3ejM2cYlaBczw+UXhrUuVlQuTuGWWkYfti/MTNlUWCoGuFBlCBEOzNnlzGTJH0Mb7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMhRZAcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMhRZAcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578D9C4CEE5;
	Mon, 10 Mar 2025 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629721;
	bh=02y/wQoRst6YuTksMYQnkgF2MlSEfGc4u6mYrw6JNuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMhRZAcKbH5fuK7jMaZuY72+sZpyaq4S8vMB33y6mqYd0FzQLcMjuMPDDnVNxIuI5
	 czpQmt8hrUXtVX8MKGgwRtaqQ9ZLird6zLJWP/D1jPJlVig1w4cSjg8XxxGAFmsl8y
	 F+5QOL5L3Kq8b1jFFLKrLoHS/pVcdVqCRa7+wjdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 385/620] regmap-irq: Add missing kfree()
Date: Mon, 10 Mar 2025 18:03:51 +0100
Message-ID: <20250310170600.790604896@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -904,6 +904,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	if (d->virt_buf) {
@@ -979,6 +980,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);


