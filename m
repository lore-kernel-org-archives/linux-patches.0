Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD29229BD83;
	Tue, 26 Aug 2025 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214937; cv=none; b=mXuAkEaj3GfPmXDsR7k21XX45T0vJ0URCx79HG+TXFXtw30UKQal69Y4bty4ck/NxIOW2H69nVV6wUoFE819jMs1NLMzoKc7ZuXzAamnfrIQ+1AIDWRHfRU66/aw9clM3BQVLDjiQVH7Ezc+Dl4DzUrYyr9Ekk2UlP/jc9WOIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214937; c=relaxed/simple;
	bh=eoEMHxd+TdTtf5uUJFPJbfXy2/5JSKsXVeGVdF8r990=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L43RlezcOYVk7KMbSUXitDqhVJj0ZvQQZnGC7UcxSwyF1AO8g4LVe/cP57WCs5eCRMycibl3Dlhpt0r2zpMmc1RJ+wevQmJiobfEvTn7mhSFKiVvO2gnatDuVkKgIOvW7rqhKfrNmAzOqf8e4VeWa+NhhsE4yi0vKwI322UqtF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BA6qhv81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BA6qhv81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEBEC4CEF1;
	Tue, 26 Aug 2025 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214937;
	bh=eoEMHxd+TdTtf5uUJFPJbfXy2/5JSKsXVeGVdF8r990=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BA6qhv81MLsXjlId+skcSYBK+S+fhBAPtvsnC9jcvVqVQGE1igsyaqgEC8RPoU4BG
	 mObS02Yo5DbmHxNsBoQ8anvSyug3jfU5PLlGrMidnaZwBYxwJd5ro5m0RqMEbfaIgP
	 uJ4hk8NFlkJ7vvAG0gjwUP7NgQDb9eRilmZ6Bi8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 327/482] media: qcom: camss: cleanup media device allocated resource on error path
Date: Tue, 26 Aug 2025 13:09:40 +0200
Message-ID: <20250826110938.891554313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

commit 69080ec3d0daba8a894025476c98ab16b5a505a4 upstream.

A call to media_device_init() requires media_device_cleanup() counterpart
to complete cleanup and release any allocated resources.

This has been done in the driver .remove() right from the beginning, but
error paths on .probe() shall also be fixed.

Fixes: a1d7c116fcf7 ("media: camms: Add core files")
Cc: stable@vger.kernel.org
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1658,7 +1658,7 @@ static int camss_probe(struct platform_d
 	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register V4L2 device: %d\n", ret);
-		goto err_genpd_cleanup;
+		goto err_media_device_cleanup;
 	}
 
 	v4l2_async_nf_init(&camss->notifier);
@@ -1710,6 +1710,8 @@ err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
 	pm_runtime_disable(dev);
+err_media_device_cleanup:
+	media_device_cleanup(&camss->media_dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


