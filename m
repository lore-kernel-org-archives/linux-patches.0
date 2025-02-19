Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D1E1E2614;
	Wed, 19 Feb 2025 09:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955716; cv=none; b=oT3MuWdYaYbtn00YVQJyHnxnaO2VIBl8VzMTdxnhaOjXGSiTuGKTgWlZyKpW5mT4BdNo5KNFpBsWnP6/SBnnC+r2feN6okLxr3bdRNXrewi+rGHwv4aYuHw9AOUzsXfOAyKCBcfN5CTbYNSb1pF7bbyi1fqErQajruJmf9/X30k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955716; c=relaxed/simple;
	bh=0EQJorR3t0JL4dn918en+Jqx5nunekhb4Tqq6znd0KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iri2mX6AbpPXjAIOduxY9vslixa7iy6KFPSFv3q14SpaizldForlU1SOxA2YbWyBfqc61vfUmILWKBvqL8p4tSrhEZWJXKCk0LZri5U7LeX4cMRyx18hi1usIN7JMpIZXUVwdgvEiyO4tC9nsUF+nuM/Uw4vecOSOuaKBNw0y5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OceQkYZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OceQkYZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AF0C4CED1;
	Wed, 19 Feb 2025 09:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955716;
	bh=0EQJorR3t0JL4dn918en+Jqx5nunekhb4Tqq6znd0KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OceQkYZ7tqjUmSfxl9mQweHfrcjuCp6PwO5M27o4vW1kq9bk+rVBFkI9RMsQ7RQcV
	 wjIeFGhCAB4u9KIvfsmUTXT6wmBCvLnpGIglAX2a2uNvTszHLkTV9WiSaqwHx4/pdf
	 B4kTn+CSwa3SJ44WRYNGvyvaUne3GNqGjrLyWqtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 091/152] regmap-irq: Add missing kfree()
Date: Wed, 19 Feb 2025 09:28:24 +0100
Message-ID: <20250219082553.653862536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	if (d->config_buf) {
@@ -969,6 +970,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	if (d->config_buf) {


