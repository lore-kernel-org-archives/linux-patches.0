Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2543EAC74;
	Mon, 17 Aug 2026 14:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975741; cv=none; b=HZRVHM2zuuVt+zQPVX8ryWethRUxxTZ2/mokDClNtPJalHrgqWU8qIYBf09f7FzzJstHeVUEjTV9N7Bqk59iWgRQEMlJhXyBE9w6C8MUv4uqAuRp5rCKrwQPg6K5zXMFF8G8qledXlxlF63p3VKhYhh5zegZZz46xnT7WEIjJ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975741; c=relaxed/simple;
	bh=8dgAvdyEQ4DswYz5ZWCblfCpDDUXJPahhKD8VwOTO8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgom54QflrU9tDaMd8qilgXXfjkvf06coDanqsLkL8CtpdBPH0abVqvi7kn6fk3nA1AGgb8v8uEVXTxm8+2ADqcz4hfaknCVdpYhUnos3B0INMNXawgm6PArojGXOaEFjt3oT2MKVkPlnD8uXmbkopsuO3MpItQGSYYSfp23WgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxrvZhxa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxrvZhxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA711F000E9;
	Mon, 17 Aug 2026 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975739;
	bh=BErz411Q4FrBqLQh20pN/L1sRM9nJcgSvp3NJFMWVwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxrvZhxaham1RM4wfr63jWcURAss50yFaGbZqgMaJxibq+66TkFp1C8xl6v0lB796
	 Wiy8gsPqE15ErV7qMZnMANybmPIYBmYgVd/2BfdofdS7T3nuHPYONPJ6K0AaPEJGB6
	 d9UoEqHrLQDpxS6RN4bG6on9ZVfBqGTFr54cEEFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 132/389] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Mon, 17 Aug 2026 15:29:31 +0200
Message-ID: <20260817132544.305133861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -1504,6 +1504,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


