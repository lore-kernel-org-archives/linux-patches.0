Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F622F0661;
	Wed,  9 Sep 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962414; cv=none; b=o1/Y6Cc9W9LYYJR7yiS/LcHvao4EKvepI+DTkg/aIksSBiGuRXA8Z7Zjq9bIzfFUPA2LCi7fyLVEnQZ3gfYzZyLffFaynUREqAAWPXrhfPzPKxmqALTGs2sqJMlLNoLqb46Mb/xiEA+iZcOmhn/BhbC1H5ZOQXXuW76kC+EcHXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962414; c=relaxed/simple;
	bh=eCE5U0La4/YPnMJJCMCLQstoYqFauFivrAsS++wkvsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOpRMoo6nN3i6QxRU7KLkctiCXwANYK0KH/nbWx//xhsUUCz2UV0nZ5u68yauJ39rI6Ldppa5v3KU+UJZehrW9fCXSH6+Ug1el5JvoPfGbkfo2X4PRtsDgtT2v1JVPSa2qUP7ikrpE4J4Aa/UTlaTUN9sZWOv7pDQGc8lK4PSQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7XqnILc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7XqnILc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00D11F00A3A;
	Wed,  9 Sep 2026 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962413;
	bh=rcQUJ7Ht4HN94krbTiedFNbPHyXwvg4GsenbMO0ph+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7XqnILcHlzgccnDuLHJOzU9C7168/M0pujNVjpzlcmht2TD7rGTBRT/IKYKHj8IC
	 b/c0b+TeAq6cFijaXi3+OpLZiKLEbNesAhn0pEphMdIhzZjJwHRSid6tYEt/0QJvBu
	 171KUhr3tU2ZI0MvUMNTEThBF0O7ZGZsfm7LxXvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jonathan.cameron@oss.qualcomm.com,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH 7.2 281/556] iio: pressure: mpl115: Fix runtime PM cleanup
Date: Wed,  9 Sep 2026 15:39:21 +0200
Message-ID: <20260909134240.539079620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


