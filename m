Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3AB641;
	Tue, 16 Jul 2024 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144426; cv=none; b=YYmbNH7rCsUIkvTeMHQ2ipQ7XG9PPYopPoEVJEKbl1cp/R2e16WFWkfv03iB5AY2CwV5PTqETpxnpzFSRWAG/N6Cs9Yc8FM/nJk4zKcmxvJkJokkOVfZ86+DSsuJ4DlT3946d1/vwj4VAbLkWBIReb8nTjOAlooLRsRRE2VBLpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144426; c=relaxed/simple;
	bh=JkdsvQDjr6ytp8ycS5vB/Eymil4hWEsDXZWXDIYx4WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXY5BxcyN5XVrRGpxY9qxNIi3gx/QBEff9EBmSRvGs2muHkb99eUQPdpUfcUYFai6IoEvAVc6YOK+NbfBTY8trrFmyz3Zgh8JgPhGCYsQI3/9SRQXShFY9oUehUTlcJP1JXaYU5u4+IIQ4DsDTfSjo4uHls0E+rIRwBnJ2WM3iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oxrl47NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oxrl47NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FD4C116B1;
	Tue, 16 Jul 2024 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144426;
	bh=JkdsvQDjr6ytp8ycS5vB/Eymil4hWEsDXZWXDIYx4WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oxrl47NG2DkK9DlP0k9E4xf25fhKLyOowr6ic7Oy62Q/O9j9am7rRI40g/fau5gru
	 xGGedxivG+MoFoqBfwsEqpJPT3TBJMKUJuFYYpwK+EbYEvGShe8zfzChqKBcxSlamK
	 5wiN41XnG4HjUaQk/79l/Mal3zqo1649YzorSKmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 69/78] nvmem: meson-efuse: Fix return value of nvmem callbacks
Date: Tue, 16 Jul 2024 17:31:41 +0200
Message-ID: <20240716152743.312050669@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Chakraborty <joychakr@google.com>

commit 7a0a6d0a7c805f9380381f4deedffdf87b93f408 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

meson_efuse_read() and meson_efuse_write() call into
meson_sm_call_read() and meson_sm_call_write() respectively which return
the number of bytes read or written on success as per their api
description.

Fix to return error if meson_sm_call_read()/meson_sm_call_write()
returns an error else return 0.

Fixes: a29a63bdaf6f ("nvmem: meson-efuse: simplify read callback")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/meson-efuse.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/nvmem/meson-efuse.c
+++ b/drivers/nvmem/meson-efuse.c
@@ -18,18 +18,24 @@ static int meson_efuse_read(void *contex
 			    void *val, size_t bytes)
 {
 	struct meson_sm_firmware *fw = context;
+	int ret;
 
-	return meson_sm_call_read(fw, (u8 *)val, bytes, SM_EFUSE_READ, offset,
-				  bytes, 0, 0, 0);
+	ret = meson_sm_call_read(fw, (u8 *)val, bytes, SM_EFUSE_READ, offset,
+				 bytes, 0, 0, 0);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int meson_efuse_write(void *context, unsigned int offset,
 			     void *val, size_t bytes)
 {
 	struct meson_sm_firmware *fw = context;
+	int ret;
+
+	ret = meson_sm_call_write(fw, (u8 *)val, bytes, SM_EFUSE_WRITE, offset,
+				  bytes, 0, 0, 0);
 
-	return meson_sm_call_write(fw, (u8 *)val, bytes, SM_EFUSE_WRITE, offset,
-				   bytes, 0, 0, 0);
+	return ret < 0 ? ret : 0;
 }
 
 static const struct of_device_id meson_efuse_match[] = {


