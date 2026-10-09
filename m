Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF97C4E5329;
	Fri,  9 Oct 2026 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556954; cv=none; b=BOvjdvpO6S6qwNE16CKCpibUYfWA5p49i/tApUY7Npe0RGygjq9uHqcnkFHjLKJOuTQBKBQ6r3btUZLyE6mFyU1IHyFhFAW2YpxLeYpeG68K6dzp8bOuw63dPFIVMcbB82IRiVBsWfBaZe6TptxvOPQSYjM9if5jnLLjSTQpikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556954; c=relaxed/simple;
	bh=Z2tRWtvT2iRpm/gGNm3Rvy4obWHPr7/YtrGZ1MyZltk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOlL5QgXc02JHL7dkT9y5nLeW5M+sqYU7PzSA84DBzgS8FdwtFSJccni3IthpX/tY/gI4fZepV/OtPzpngg87Fn4oC7x0HLHBX5qXQHbSPR7oGf5nRsaUb4EYMkXuoqiJ3H5E0PLvpJPtx+KvcW4bx8jM+E1cXvdkGtvOmJSg9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNxRUw2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNxRUw2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F971F000FF;
	Fri,  9 Oct 2026 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556953;
	bh=j9Gp07JCpFr7EAr0ffgGG3KFTnCb1AH9qd1s9Qji7Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNxRUw2femBXdOIeoMOdmuYOMIq1NBx+nDORE5qm3knBfcc1mqaJDVJlOp6gq/T24
	 R4amdJ7H7MUgTQ9O4ylHdwoY2a802CGvUQ09NLpvzgVaO2J+CXDkx6QlohIMQBQG8Q
	 iRTxt2h2ioSLSv2yuZ/RHL30w/PLlLyED/AaE55I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 319/403] iio: admv1013: initialize callback mutex before registering notifier
Date: Fri,  9 Oct 2026 16:11:20 +0200
Message-ID: <20261009140959.685543398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit baf7e43b7fb5afb777353bf265ddf9d909f72b9f upstream.

admv1013_probe() registers a clock notifier whose callback takes st->lock
on POST_RATE_CHANGE. Initialize the mutex before
devm_clk_notifier_register() so the callback cannot observe an
uninitialized lock during probe.

Use devm_mutex_init() so the lock lifetime is tied to the device and
cleanup stays paired with the rest of the managed probe resources.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -604,11 +604,14 @@ static int admv1013_probe(struct spi_dev
 				     "failed to get the LO input clock\n");
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+
+	ret = devm_mutex_init(dev, &st->lock);
 	if (ret)
 		return ret;
 
-	mutex_init(&st->lock);
+	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+	if (ret)
+		return ret;
 
 	ret = admv1013_init(st, vcm_uv);
 	if (ret) {


