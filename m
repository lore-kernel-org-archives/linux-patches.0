Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA23D16EF;
	Tue, 21 Jul 2026 22:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673413; cv=none; b=VD4RqmSZy+Gx8nKSrejINvjB1gbtl4jtUIqQ1pvq8HyiNU7+8KOS8UNe4fpo5HQGUbpWS8EL3IPfhyAMmJnkxn4t/tOjVRCFkX76dQzOszBBb1MSW583MMKDJA6hkz3PsJtYIiELR5PmPVhQ9AsW5C1zmmqtO1tGuf3+ICesFPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673413; c=relaxed/simple;
	bh=W3m1vak7bZOxqq1YdS+2/sjvMpjCdludAw5PdmZ/5zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMKG8LSn3waG9NCKNWOSgZtCxPc4xylVX34c4Gwaws9U2EEtSmhAioH0/o8qoqrU3NMIiMwmZZ2W69CWuCQrX2Kn2WYF+TFDxq017My+IEw++4Hcmwuh6bVR3Nlp7t1RyF+jw4DIDkgixb/HL0cLfmUHKqalLlnlVXWru8NUxe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMnwcc8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMnwcc8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221A61F000E9;
	Tue, 21 Jul 2026 22:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673412;
	bh=Grf7vfSTJRvl26AXV7rOmKyXHWm/7FcXvKmE/d0kzjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMnwcc8ZejSU2AVlSQw5NJSLUvwXPFaJnI5m8+uJKUlsRBJvvcFs8rVc5lwiDXvwI
	 AQIrj7W0oF0LFAPH569gkcoX146t51VWmhPtzfMeNGIqy+VmXwdveemwBGrkTVrZSY
	 tuVhagImFmqQ0zi7sZbzowe70BaXeKBnW/87mRbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 153/699] Input: maplemouse - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:18:32 +0200
Message-ID: <20260721152359.152828335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


