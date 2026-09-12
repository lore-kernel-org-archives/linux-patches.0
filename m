Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA42BDC0E;
	Sat, 12 Sep 2026 08:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200199; cv=none; b=XXzxFpQR9X/j6Ryik/2/PJMs0JsiiS4cO193w04pvxUtglX9b++H/Op0aV0BHhDS32q6xA9ULqSkKFvIWTvNGAif0E6420D0uEeBDd9dzDeuhVESmlhEXJiAdroNOo8BAtAL9eFJ873YXRqiJMK0RSHqQQVAN3Xm9RkY96rwLTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200199; c=relaxed/simple;
	bh=JAnNoBG41NTNq6Sab/9JH8hxvLBbTATzI2rvyJyfxTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNNjln/T3BwXQzbhwRw+Zu7RTRuOe6nCLaTh23uobW7LX6Tq3wC8KIKWWqH5axwPrFCtrVBygndxXY7RGqff5h1NFxs5ysrABxgZqSMAetV2NGDeA8mKSAisdBKvA7qN7w2UyFwcHmiuLW760y9HeO4wXBZGT/LZm3gAPJ0rWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIDHMGSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIDHMGSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6466D1F00898;
	Sat, 12 Sep 2026 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200198;
	bh=FZDGtAQtMnbB7HKGvA2P+XPN314Cy1HzDXKfftD4fII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIDHMGSKww36mMN5RpFTtON5iDGucTIrh3GyMseK5oILZ1M3rblmmZTQGEsaaJ8Gp
	 4iTbgR+clQBh0Lvs2Wq0IlV04IdrhnDun1/OqiFUzICN/b1QVW8IIdHuAvPXHM1Zk1
	 iIeY1VCbdttkdcxCA9cQPS5lU+NrOSm3VqY0nCAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0742/1815] nvmet: reject out-of-range mdts values in configfs store
Date: Sat, 12 Sep 2026 08:41:32 +0200
Message-ID: <20260912065706.327734786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit bf881dd20062db5e951a0d0703cb476df8c9fdee ]

nvmet_param_mdts_store() accepts any integer that kstrtoint() can parse
and stores it directly into port->mdts. The value is only range-checked
later, when the port is enabled: nvmet_enable_port() silently resets
port->mdts to 0 if it is negative or greater than NVMET_MAX_MDTS.

As a result, writing e.g. "mdts=1000" succeeds and reading the attribute
back returns 1000, yet enabling the port quietly turns it into 0. This
is confusing and hides the invalid input from the user.

Validate the value against [0, NVMET_MAX_MDTS] in the store handler and
reject anything out of range with -EINVAL, so the error is reported at
write time and port->mdts never holds a value the port cannot use.

Fixes: 0a5a94648627 ("nvmet: introduce new mdts configuration entry")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2b69ffcfc8dfb..413ee2d16d29c 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -312,15 +312,17 @@ static ssize_t nvmet_param_mdts_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
-	int ret;
+	int ret, mdts;
 
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
-	ret = kstrtoint(page, 0, &port->mdts);
-	if (ret) {
-		pr_err("Invalid value '%s' for mdts\n", page);
+	ret = kstrtoint(page, 0, &mdts);
+	if (ret || mdts < 0 || mdts > NVMET_MAX_MDTS) {
+		pr_err("Invalid value '%s' for mdts, should be 0-%d\n",
+		       page, NVMET_MAX_MDTS);
 		return -EINVAL;
 	}
+	port->mdts = mdts;
 	return count;
 }
 
-- 
2.53.0



