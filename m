Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE3255E43;
	Sat, 17 Oct 2026 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256908; cv=none; b=R7ERM39wKeoliDJP950YuEmV60PIWG1fiROR2lNayKjhOIf+YRS6SLAJWYK+EaE61T4d+q297uWUxfNVYSAgz3ubhSHZv4WmPv68wNhl49/sBSV+071iFVZATqS9bG2CilmgfNyuYklFTyp4F7YgXAMx2mDySKpf5+77McrHFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256908; c=relaxed/simple;
	bh=azgbvX/ZVhCsSgzSHDt7NCHFFGnPTVdjGVun+aDL10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKSzc/uxGQaT+M31tEUSXXWP8qPvbUxK+wWtI9WX31+woBqQvHmyXnxiJVRgoAKXqQ7FrantpMKe7SVpbQob+hGUQDKpBa0e1uafSu89QAj3vOT1UISlyjm+9LOZeVkXykKaaJN6Sm5wExWAehzoTWTasH7gKx6vtGLk8azn/Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJAaNbj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJAaNbj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBA81F000C4;
	Sat, 17 Oct 2026 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256907;
	bh=cRHcmTvuUbqyfQF9RL923R9uv7LOK/UhyoDQDJdGuDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJAaNbj1EcJi7rapdEPQbbyaU6vFWxRGKexRLTOKNGpb/8lkB6siUJzoVzmxxqEYS
	 Xp09l3XkmDOdJYVkU4mff3oftsBBjg7ock4nYhUtKxG6wEXVVVXgUPQl24f4m8KGSv
	 OfqtxFqW3AujU3kq8ojFh0tpgy7b6fIZQKKwNiV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0347/1674] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Sat, 17 Oct 2026 17:43:39 +0200
Message-ID: <20261017160440.036406537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 63213927b141085b6c8719b8037dab3074b7e0fe upstream.

The threaded IRQ handler queues data->work through irq_work_queue() so
the trigger is polled from a per-CPU context.  free_irq() does not flush
an irq_work the handler already queued, so after gp2ap020a00f_remove()
returns that work may still run and call iio_trigger_poll() on data->trig,
which the devm cleanup has already freed, causing a use-after-free.

Add irq_work_sync(&data->work) after free_irq() in remove() and in the
probe error path, mirroring commit 78601726d4a5 ("iio: trigger: sysfs:
fix use-after-free on remove").

Found by an in-house static analysis tool, confirmed by manual review.

Fixes: bf29fbeaa13d ("iio: gp2ap020a00f: Add a driver for the device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap020a00f.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/light/gp2ap020a00f.c
+++ b/drivers/iio/light/gp2ap020a00f.c
@@ -1565,6 +1565,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1587,6 +1588,7 @@ static void gp2ap020a00f_remove(struct i
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 }


