Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAC8442FD4;
	Mon, 17 Aug 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979372; cv=none; b=u6StRS9FJVXFCfJTXbMjfVp7kbIgOVVlEd7XYQ3T4lAcbzE6B1V0DXZA1geZTpAFF8Isp5IeazhGraFuASpoAacIoIIzq54iQ0yIFLXtQxNlibxj92PaeSY4BjzgmNpj22KVfPpXaccRLFX9JsDDt9F3KF75FUNW9/lpwpJXw78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979372; c=relaxed/simple;
	bh=DyCfEvJs+N8JkF49Yz4o4YEMMHVR2203Ip1fxGbCS9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZFjdzGJX+sdtyn68yk3oullHc/kUqBsbTBEpOUqhfLA8E6+fstlEO6Y9h5xeHTSGz/OsI4OJTjlzCCSXeI2Qhs0KolpM6wZ6M0dkq32fAXd2f6az5/MKjrvsAmzEsjB+1OVCZQw2lYmT7Oyuy+XExepDmiuklgzyeC6a7hcW9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omjXGq84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omjXGq84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108A41F00A3E;
	Mon, 17 Aug 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979366;
	bh=8lJJhjO5T5XWw4FuK6QjvwwQ5L4axCy9P+sgswwHTPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omjXGq84LjpzKqC50kdGwO0m3OrmX8DIlzMRH9I9C7aZU1T8g8UsRGDPtihomHqj8
	 RyOYOKRdSgy1osiOLFdIwT1rI3rCBJvjhNkyFjDEEimkBe2pJ1bF19FhPeF7fNQ/2s
	 SQ7gUUT1fNUncHziDAlpUn6T6tMtFXhzQ6oCcReM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 202/609] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Mon, 17 Aug 2026 15:28:18 +0200
Message-ID: <20260817132550.869071644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 436a693af04ffb889aaf87cb69ec1f2b21d3569c upstream.

si476x_radio_probe() registers radio->v4l2dev before allocating the V4L2
controls and before registering the video device. If any of those later
steps fails, probe returns through the exit label after freeing only the
control handler.

A failed probe does not call si476x_radio_remove(), so the
v4l2_device_unregister() there is not reached. This leaves the parent
device reference taken by v4l2_device_register() behind on the error path.

Unregister the V4L2 device in the probe error path after freeing the
controls.

Fixes: b879a9c2a755 ("[media] v4l2: Add a V4L2 driver for SI476X MFD")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/radio-si476x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1495,6 +1495,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


