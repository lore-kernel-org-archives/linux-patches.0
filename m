Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59171DEFF3;
	Wed, 19 Feb 2025 08:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954458; cv=none; b=kJmPYvIMNwabD+JDkEwZuJ7kSI7lrhXkM1YInJnQkX5szuXRP+HbnJwNRVwubzS1uPAtyO0FnV5VfHeH8TNbyZIcz2PjheUcpgZgP5LBMdI1T5eqittgpHJvVuOF1LNIlouCseaPHXGExJ73KvMK2AuELPPSITLgRlMvE9bTrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954458; c=relaxed/simple;
	bh=zgagEb7q2Uaj4IS2FjGgy66CvYdzfcbyMkX0S2GvSZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1a17xGjuTX1v1XBRSoI7S1TTLxlNhV5oxIReueM5tOYbdHqhEvS+F839FuNZ4uwJRvI9ucggQ0FFRsW8VdxBJyCtNYNJZQQubvOealxNhpEEjkUyO10Ja1M4vJ7G2SCzy8s3nWc4di5ncP2VqhiDKdO5t5ohZqthF7fSvHyhvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hj85Slv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hj85Slv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE9EC4CED1;
	Wed, 19 Feb 2025 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954458;
	bh=zgagEb7q2Uaj4IS2FjGgy66CvYdzfcbyMkX0S2GvSZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hj85Slvtu4yS6ZQ+CPZdxotO4ZArAgYCsjj6YA04XKG5OC8U3ejRzY73lOiwC5XD
	 92pLgw5KQlbF/y2wAKWCmh0MobiTtFQ+IMZNHHCauWUMvwmCQSSpjDtUnZUw4YTQbF
	 sIXSO11sKgfq+FeW+9y1wOJcmvvCgaMCOEOzRGe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 180/274] regmap-irq: Add missing kfree()
Date: Wed, 19 Feb 2025 09:27:14 +0100
Message-ID: <20250219082616.630011298@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -906,6 +906,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	if (d->config_buf) {
@@ -981,6 +982,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	if (d->config_buf) {


