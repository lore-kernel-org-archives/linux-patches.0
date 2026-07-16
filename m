Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43D7403AFD;
	Thu, 16 Jul 2026 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211748; cv=none; b=V0buADXHzGVRAvn/ZyIbj3hK3WULSv/ftxXfne8N/0MtNB77BEoeqJIbAHKtIBEPiOZrMR00SvlEoeX3/QYWCsQIQUPb+F60L5y7rjPKFq3TFTt2Sdp5cBXmqokyMXk5neCpm2QqZB1vKYADha86NaHWrMbJQ9ESmCHTqP1X6IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211748; c=relaxed/simple;
	bh=+MprV9RUeGjfGUg88tZZiuxJRayTtlDfoIlIO+T0NvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijcP9ATc+nM++QGC1Anoi/YI2KT7Uhum0tDdZ0DzbQ2jpL7qqGEZj75g684e3SIBJLNhu9m4PUVfNxWjm+hMSTjuDkUkP3CXhi4MYrXR/aeoAvSbpR8+LfcUYTxVL8h5AVe8ZS2Q9AUGEEr/pVPuQ2D83meZxo6cahhpkDe2rhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWDW5S7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWDW5S7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567C71F000E9;
	Thu, 16 Jul 2026 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211747;
	bh=C3qaGTRaDi+W/ljxStSvKllaGp0f3Y7hqypUM21Cu6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWDW5S7dj6V8qmzL9g015Qu+tT8Yu/RPigAI1YfV4536/pV/mgCvm9ZklT4/uX31Z
	 gLYpY7pUd4OZPRL+dB3jLv4PJivrie417N36n9G/cj0lsk/1myIwnB1pJrDl+iBkVK
	 wd3DLkLtowt7L4G02zsL39CnbcoyuM0amEkMcl/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 066/349] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Thu, 16 Jul 2026 15:30:00 +0200
Message-ID: <20260716133034.800851195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e94944d7364d3ddb273539492f9bd9c9a622549a upstream.

On the failure in the ak8975_read_axis() the PM runtime gets unbalanced.
Balance it by calling pm_runtime_put_autosuspend() on error path as well.

Fixes: cde4cb5dd422 ("iio: magn: ak8975: deploy runtime and system PM")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260505-magnetometer-fixes-v5-0-831b9b5550fc%40gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -785,6 +785,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


