Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762AB42EEB8;
	Tue, 21 Jul 2026 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671294; cv=none; b=JVlgzXB8wEi4HDPBiKf3mehA09X3aD5Jr9DtXIC6jX0wd64wFnejooNALNOvtm4oBTLnlC6VX2FGgia962ddUVVYs82NBFa+N5wEFrNR+AWt2WWv73nNmazw/SdYxo8HCxBbFT1tU7BBcmDU9cLjXUUSYRWrP/8kr+IN9ipY2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671294; c=relaxed/simple;
	bh=giPUYUN4Y1shiBb5cyluQYLDOMUJKdYBUZviodMxzXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKTaVM9Je45/fCG90BMzH/Iql0NIu56hCsKctAK8pl7YoNs8FlEJjfGLLG9SXM8/ld4AI9tdnT1zrlE3F5ZVOZFHnYGI/X+sxdck1xFtqNO8WcI8mmWfleaFMzbjH4/Q5OsqPMq0PORvdXCfBERxtQ328r3eqHtfjpn3+xd+qB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc6klAMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc6klAMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FFB1F00A3A;
	Tue, 21 Jul 2026 22:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671292;
	bh=cQ5ISOoR0Ql+gMRqq3Bj8ysQVBW8CN8A6x5MbSzxoK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zc6klAMbbWJWfzIWu3bIPAELcngWh8WbzTUkqJA1HvWngv0dNGJfqowztxe5x4gmv
	 rSrgGgwCPiC3xt5torEs7pNzmUjI6bjjhyIybDzdpzuv0MKx3e+EzVTX+KkzGSLdpW
	 2Vu5fQoxNp+OmrS3WOatuzm7iI4Jq1H7Y19mTHZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 191/843] Input: maplemouse - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:17:06 +0200
Message-ID: <20260721152410.312017814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


