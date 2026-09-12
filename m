Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B28E390CBE;
	Sat, 12 Sep 2026 11:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213561; cv=none; b=uapt17ErxZm5JQO2s8TI/j2RZFa1vphdWYe5RDVPXc5qamN05o3+trFRHVULmv6yJnEdEbkDLzeLOddwn3nex8Xgs4OiRZgoFYktLQqNzsBfNQyB8CaPpmLlXSuNLz5Q4VPzky2ydRlpvZECftk7InMuxC87kgWCxXySJkBpkt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213561; c=relaxed/simple;
	bh=hSf6e4BGG9JI47lFSJLdI+4kQtCoIyX/709ONr0W94o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1/qwFotWUBYcNwhG+z0fVbcx8Tt+hwCXBC4W8ma3h+rcRHblAdOJZO9p0lIGhBpI/EVUmZXd4Repdbr7DPjmehmhJxFbJVBa0zHSX3I2F5Vx9IZGFRwRfmFI9h+KxaemJIUeSX+ESnlfXB3we0O5iW3qVOk0QiO91N0ka6NjmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMux0EyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMux0EyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBA1F000FF;
	Sat, 12 Sep 2026 11:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213560;
	bh=o2T43PKFwbMJNYpZ8nTDsl0pCzRjrpqJPD+pG++e2u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMux0EyBLteI65CSWi+ZNVCDix1D8b65lYzzl7vxNE9UIQzJGzWJ3ae1PrYmfO0wY
	 IaA3J5+mJ2rX+5EyrWS2bBxbpOIfFM8u8gzFkh/BX4hig3sLeuDLfwscn3vD1B/5tu
	 4UhnBa6C5rFFMG5C2iMOi8OCU2JIJcSzc5s41W3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jonathan.cameron@oss.qualcomm.com,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH 6.12 0148/1376] iio: pressure: mpl115: Fix runtime PM cleanup
Date: Sat, 12 Sep 2026 08:42:54 +0200
Message-ID: <20260912065610.850968734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

commit 0b5e142ced4bcf20532da051934bd694d1bbd470 upstream.

mpl115_probe() enables runtime PM when a shutdown GPIO is present and
then returns the result of devm_iio_device_register(). If registration
fails, runtime PM remains enabled and autosuspend remains selected.

The same unmanaged runtime PM state is also left behind on driver
unbind, as the IIO device registration is managed but the runtime PM
setup is not.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
probe failure and driver unbind, and check pm_runtime_set_active() so
setup errors are reported.

Set the autosuspend parameters before enabling runtime PM. Once probe
has completed, the driver core queues an idle request for the device, so
an explicit pm_runtime_get_noresume()/pm_runtime_put() pair is not
needed to start autosuspend.

Fixes: 0c3a333524a3 ("iio: pressure: mpl115: Implementing low power mode by shutdown gpio")
Cc: stable@vger.kernel.org
Suggested-by: jonathan.cameron@oss.qualcomm.com
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/mpl115.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/mpl115.c
+++ b/drivers/iio/pressure/mpl115.c
@@ -203,9 +203,9 @@ int mpl115_probe(struct device *dev, con
 
 	if (data->shutdown) {
 		/* Enable runtime PM */
-		pm_runtime_get_noresume(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
+		ret = pm_runtime_set_active(dev);
+		if (ret)
+			return ret;
 
 		/*
 		 * As the device takes 3 ms to come up with a fresh
@@ -215,7 +215,10 @@ int mpl115_probe(struct device *dev, con
 		 */
 		pm_runtime_set_autosuspend_delay(dev, 2000);
 		pm_runtime_use_autosuspend(dev);
-		pm_runtime_put(dev);
+
+		ret = devm_pm_runtime_enable(dev);
+		if (ret)
+			return ret;
 
 		dev_dbg(dev, "low-power mode enabled");
 	} else


