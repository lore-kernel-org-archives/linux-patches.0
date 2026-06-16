Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA7847279B;
	Tue, 16 Jun 2026 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628811; cv=none; b=hIVODz/YNk9WQd1+8DWtoeT3ePiqVG9g5vy/0uvujbEUvkADyKX36Z/DD7Ko8I8zhrrqVJOed0gQ9sZ6zEUJGYlMmu9bzQaZWrzuGCm7DfGae0UE9wgYn5oedsLrRjWilkul/33ODR0AzkUvyfjc0hTg5da4hySfNzdFNM0muV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628811; c=relaxed/simple;
	bh=f6rZ9wX6WJJJLyBnAPpQ3iqlJft0ViqHrrcG/gzoGf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDPnpHeYG7qoHj1+5CeBhY1igV/SZphUs5Pqq/n1UTo2Huc1ykBE7vwZANX0DnibUANA/W0B9dL57Qgksborr+SrBPGV+DTtluskECm2J7P1J61FWqwTMoa6kjPLkXjh/LQlj1qH2dJIDUjkrIGn4pL33ogiXOW/BZy4M4XsA8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMYWhDPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMYWhDPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B801F000E9;
	Tue, 16 Jun 2026 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628810;
	bh=E/0isasNZXhrMqOw1BqOfOLho1KwhaqgKcj9pe7xSS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMYWhDPLk2HrHBMsj5EP4LLK5L5S1I+iOdGMeZnR3Ur1Q8MrKU/17SoAlIPBE2I4A
	 TY0y2e4y5N9eTxX3n5HQTlrKk1oq4kuplWLmjOHddmkMU0BRBP1CUheqAZOqmZ6O0E
	 yH1Tacjb3ORzWr85rw9g4A2YH5zJhniBIQlRcpd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.6 166/452] usb: gadget: f_hid: fix device reference leak in hidg_alloc()
Date: Tue, 16 Jun 2026 20:26:33 +0530
Message-ID: <20260616145126.583421411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 4f88d65def6f3c90121601b4f62a4c967f3063a6 upstream.

hidg_alloc() initializes hidg->dev with device_initialize() before
calling dev_set_name(). If dev_set_name() fails, the function currently
jumps to err_unlock and returns without calling put_device().

This leaves the device reference unbalanced and prevents hidg_release()
from being called. Calling put_device() here is also safe, since
hidg_release() only frees resources owned by hidg.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Route the dev_set_name() failure path through err_put_device so the
device reference is dropped properly.

Fixes: 89ff3dfac604 ("usb: gadget: f_hid: fix f_hidg lifetime vs cdev")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold johan@kernel.org
Link: https://patch.msgid.link/20260413142119.2977716-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1282,7 +1282,7 @@ static struct usb_function *hidg_alloc(s
 	hidg->dev.devt = MKDEV(major, opts->minor);
 	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
 	if (ret)
-		goto err_unlock;
+		goto err_put_device;
 
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
@@ -1317,7 +1317,6 @@ static struct usb_function *hidg_alloc(s
 
 err_put_device:
 	put_device(&hidg->dev);
-err_unlock:
 	mutex_unlock(&opts->lock);
 	return ERR_PTR(ret);
 }


