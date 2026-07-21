Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0B547143F;
	Tue, 21 Jul 2026 20:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665479; cv=none; b=gxBGRD8aWlvtzngWHrapHgbabK1bHb0fnnyD7l3QSXUHuRJPOSWBrBdCaGj1ubY7Mc4FDKzPM0RhHgtgtsyT0hhacGReur59xTLoKjr4hWaAE4qwhS6+sipl2alz/YJnf7/JVV2wdro5rvWZ3xt54yb53yPL8y4I+EpqoygAiWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665479; c=relaxed/simple;
	bh=odUNGpNd/6VViVAsdByOBcqiITkKfcEit4VFam09Dtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V58nk2GJZdX/0YgVnf4ZjE07aQF6H0PAkvXbSHCsvJTC2wzycLcCtO0AovoSFDq4LaKHYm6esQJxERwVkvK431gdHqjpJv7F9e3eczowSYY96osliOEo69HwlQkvcrNNll7ZxQySOMDUYIbJn3hus54JlCm2DcOCkyoCPbzmEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7+nQGSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7+nQGSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B3A1F000E9;
	Tue, 21 Jul 2026 20:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665477;
	bh=+cBKxGhO4XiMXr5VpO9/guWWHACgKYVWac0W5n1b7Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7+nQGSiLC3WCXy+K0uo6POv8ulXrjLsbpvwyVQKMSEmsImvk6iM0L5noX0u75quq
	 NhhtIZa3T9+LEMvtgtHcDzz+jYkPQo11jNz1gHGr77Wg22hO7SX5ebIxiiS3b5MSYh
	 0Y5uoxrmquj7XuXaGa1rIKGtcAOM1e5KGW7jp8rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0317/1266] Input: maplemouse - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:12:34 +0200
Message-ID: <20260721152448.931634974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 738f24bbbc95dd50cb4229d1ed62a05f29db2bda upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/akNXw45L_8bxD6QV@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/maplemouse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/maplemouse.c
+++ b/drivers/input/mouse/maplemouse.c
@@ -88,6 +88,8 @@ static int probe_maple_mouse(struct devi
 	mse->dev = input_dev;
 	mse->mdev = mdev;
 
+	maple_set_drvdata(mdev, mse);
+
 	input_set_drvdata(input_dev, mse);
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
 	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
@@ -103,12 +105,12 @@ static int probe_maple_mouse(struct devi
 		goto fail_register;
 
 	mdev->driver = mdrv;
-	maple_set_drvdata(mdev, mse);
 
 	return error;
 
 fail_register:
 	input_free_device(input_dev);
+	maple_set_drvdata(mdev, NULL);
 fail_nomem:
 	kfree(mse);
 fail:


