Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E841A785;
	Sat, 12 Sep 2026 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228226; cv=none; b=q0YLWyAId8pBFknIqYjluHunbM4Etl7j0lbb0I1Nn4LiA3x0vkIOFBc6TgWJm4xyabr0XWL4IojHGIAuxNcpZrW3M1+CpqHIdbsbPIhbpOBHHUiLWrOsXzA0CtLPOluYTueFEYqWB72WdnwiLMUMcAN/o35oy7/5NzVuNgHUZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228226; c=relaxed/simple;
	bh=Uu+5mVd1SE0PNLuCPeJp8858OCVeSwl0HviCyzTYVCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9K/VTkItP1AAhNtundERKOzWa7nznmZ4VvJD9BRnUJ3Rcg2Wb2TQgwmUxP91b/u9eLDrR+/15SpE/8YeGqznH3mnOfEmVr+2KBeqjIKX9ilgN5xrkbFmpNrNLDmX2nbiU/t1QI23waTbEWU9frGAexjaw20M2w1FPzBrrO4mFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1SBojte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1SBojte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3711F000FF;
	Sat, 12 Sep 2026 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228225;
	bh=DDBWTEUT834ud1bpzyuwytkFwSld67+I9HazfdlrJNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1SBojteJ/pe5xvZ+Sh8C7+V9KVC6b9YU66tXbnA4cjZf9PQ/pbel2u5+JDCeaxwL
	 JwtYZuUMJodPTkjB2QNO+HFZwJueurzXnnOsRGOWzMPb1TwNNHmJeqQzcCzRFakbxV
	 QWgM3VeaPQpc89LlE7TVkzw9wnX4em3RE/awRvGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0343/1191] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Sat, 12 Sep 2026 08:51:11 +0200
Message-ID: <20260912065555.931848964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 1135d6875d2dbda3f6ec718f3421a6ce4378bd63 upstream.

kthread_run() can fail and return an error pointer, but sgp_probe() stores
it and returns success, so the device is registered without its IAQ thread
and sgp_remove() later passes the error pointer to kthread_stop(). Return
the error from probe instead.

Fixes: ce514124161a ("iio: chemical: sgp30: Support Sensirion SGP30/SGPC3 sensors")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sgp30.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/chemical/sgp30.c
+++ b/drivers/iio/chemical/sgp30.c
@@ -548,6 +548,9 @@ static int sgp_probe(struct i2c_client *
 
 	data->iaq_thread = kthread_run(sgp_iaq_threadfn, data,
 				       "%s-iaq", data->client->name);
+	if (IS_ERR(data->iaq_thread))
+		return dev_err_probe(dev, PTR_ERR(data->iaq_thread),
+				     "failed to start IAQ thread\n");
 
 	return 0;
 }


