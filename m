Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28B3644AB;
	Tue,  6 Jan 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721891; cv=none; b=nSf4UdQ5qmyeTk9bSuE5leb7/8LjMXH2YXeRGX9nxBCc9IMQQSLSsOwb7aoQA29JBAdD6yrjnNVWdb1kbDi6pVCeqnZrj6lpRvXwjj1ysisYJesnzG8dKXC/tejyukiZLIdC50hBLDEXHlpToZNHKphS+8Zg+dW3f2wUoykshTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721891; c=relaxed/simple;
	bh=+DXKa9FnmeHaJUbyMURM7UvFNToVzEoeI6URpV1eB0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZC0VftCLzkIWi0IB8S0ad2ZWMyRnDVVr9pYWlsCHChXPLmYCZGNvMZaqTPdc7LM9YRV+4OThaTeayXmbEnz0gDMlqIWqgitPPb3MWdrNtELTX8YsNvQZQbVIUGToCj9XB81OdM6q3xfObBa/gCFE1UYqWXxa3BP+MR2QfaGsR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOOesTVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOOesTVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD7C116C6;
	Tue,  6 Jan 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721891;
	bh=+DXKa9FnmeHaJUbyMURM7UvFNToVzEoeI6URpV1eB0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOOesTVlmi/JjP3eCK084NXd51aAV7sn8Ice18bbLJzr6cNSIk2HZLvNri0DbO0nt
	 l8nbYJ9mmjwhjoaRLrfbwN0Nn4zIoJCGfYVgXAoNDTMLApFpsm5UQ836uPDyBIZgTh
	 8ycW+TtQGXX8HhORDX2wjaJItyNMuPoWziq5baXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 103/312] ASoC: codecs: Fix error handling in pm4125 audio codec driver
Date: Tue,  6 Jan 2026 18:02:57 +0100
Message-ID: <20260106170551.563857762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 2196e8172bee2002e9baaa0d02b2f9f2dd213949 upstream.

pm4125_bind() acquires references through pm4125_sdw_device_get() but
fails to release them in error paths and during normal unbind
operations. This could result in reference count leaks, preventing
proper cleanup and potentially causing resource exhaustion over
multiple bind/unbind cycles.

Calling path: pm4125_sdw_device_get() -> bus_find_device_by_of_node()
-> bus_find_device() -> get_device.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 8ad529484937 ("ASoC: codecs: add new pm4125 audio codec driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20251116033716.29369-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pm4125.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/pm4125.c
+++ b/sound/soc/codecs/pm4125.c
@@ -1549,6 +1549,10 @@ static int pm4125_bind(struct device *de
 	struct device_link *devlink;
 	int ret;
 
+	/* Initialize device pointers to NULL for safe cleanup */
+	pm4125->rxdev = NULL;
+	pm4125->txdev = NULL;
+
 	/* Give the soundwire subdevices some more time to settle */
 	usleep_range(15000, 15010);
 
@@ -1572,7 +1576,7 @@ static int pm4125_bind(struct device *de
 	if (!pm4125->txdev) {
 		dev_err(dev, "could not find txslave with matching of node\n");
 		ret = -EINVAL;
-		goto error_unbind_all;
+		goto error_put_rx;
 	}
 
 	pm4125->sdw_priv[AIF1_CAP] = dev_get_drvdata(pm4125->txdev);
@@ -1582,7 +1586,7 @@ static int pm4125_bind(struct device *de
 	if (!pm4125->tx_sdw_dev) {
 		dev_err(dev, "could not get txslave with matching of dev\n");
 		ret = -EINVAL;
-		goto error_unbind_all;
+		goto error_put_tx;
 	}
 
 	/*
@@ -1594,7 +1598,7 @@ static int pm4125_bind(struct device *de
 	if (!devlink) {
 		dev_err(dev, "Could not devlink TX and RX\n");
 		ret = -EINVAL;
-		goto error_unbind_all;
+		goto error_put_tx;
 	}
 
 	devlink = device_link_add(dev, pm4125->txdev,
@@ -1648,6 +1652,10 @@ link_remove_dev_tx:
 	device_link_remove(dev, pm4125->txdev);
 link_remove_rx_tx:
 	device_link_remove(pm4125->rxdev, pm4125->txdev);
+error_put_tx:
+	put_device(pm4125->txdev);
+error_put_rx:
+	put_device(pm4125->rxdev);
 error_unbind_all:
 	component_unbind_all(dev, pm4125);
 	return ret;
@@ -1663,6 +1671,13 @@ static void pm4125_unbind(struct device
 	device_link_remove(dev, pm4125->txdev);
 	device_link_remove(dev, pm4125->rxdev);
 	device_link_remove(pm4125->rxdev, pm4125->txdev);
+
+	/* Release device references acquired in bind */
+	if (pm4125->txdev)
+		put_device(pm4125->txdev);
+	if (pm4125->rxdev)
+		put_device(pm4125->rxdev);
+
 	component_unbind_all(dev, pm4125);
 }
 


