Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F432D7C7;
	Sat, 12 Sep 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221591; cv=none; b=QDZ0+a2kaDMSc5LGHrBvhDQ8SHI5go6p40gaKeKqAI5mMLPaeN8W7jRW6x9592lSv39yev3rzOiYvr3oUKAGyzog5hlacu5RPcN6ld4qbPy7ise4Va4rYrhqV0VEJPe28wuOlnxdmNEaF/xlqr/7c5IQJGCt402t46ngMP0/qi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221591; c=relaxed/simple;
	bh=PGQgjIFOtVnhIV/mxrdd58qU1rUJRmazz43yJYNfCco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6dmH+UvgNmkwTYnJz/DzTpNeT3I7fmE2B8lzmUTdHOxuWuZSCHRihsD5kDkSFaoio5M9Iiib0DOH9LWhFY38eWaOgoesDTObXyZKd9HIBuDthZtsyYXiYK1MCd8RjRhstdwsYAHmwykChpL08YFP9fPPXHWubnSBE1QhP6Ifog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lRw5pGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lRw5pGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070591F00893;
	Sat, 12 Sep 2026 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221586;
	bh=hLy0FKOAkkUuNhY2jUgeDDMFRImLUwZVAWt66PVe6/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lRw5pGObApl8Ucu066W+2kopnMubUnKqNb32JmcFY2KnJROTikc5/fUaqUhsejF4
	 zap0BCQ+oYYiz9HYQjPFRctrUX2USbX5szOIZtVpgq4sX1En6tR5SXgBds4vfYg+Z3
	 l1m5wcqpZbYU6MzKOgUKTKKl07ugoqg2UL5nX9io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0413/1424] iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable
Date: Sat, 12 Sep 2026 08:47:25 +0200
Message-ID: <20260912065616.531181499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit bcd3f72e26314edfce7eaf8d7160b3119c7b7fed upstream.

atlas_buffer_postenable() acquires a runtime PM reference with
pm_runtime_resume_and_get() but returns the result of
atlas_set_interrupt() directly. If atlas_set_interrupt() fails,
the runtime PM reference is leaked and the device can never
autosuspend.

Add pm_runtime_put_autosuspend() on the error path to balance
the reference.

Fixes: 0e4f336f50de ("iio: chemical: atlas-sensor: Balance runtime pm + pm_runtime_resume_and_get()")
Cc: stable@vger.kernel.org
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-sensor.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/chemical/atlas-sensor.c
+++ b/drivers/iio/chemical/atlas-sensor.c
@@ -414,7 +414,11 @@ static int atlas_buffer_postenable(struc
 	if (ret)
 		return ret;
 
-	return atlas_set_interrupt(data, true);
+	ret = atlas_set_interrupt(data, true);
+	if (ret)
+		pm_runtime_put_autosuspend(&data->client->dev);
+
+	return ret;
 }
 
 static int atlas_buffer_predisable(struct iio_dev *indio_dev)


