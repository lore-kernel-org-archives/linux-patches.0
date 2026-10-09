Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2406F2C0F6D;
	Fri,  9 Oct 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557562; cv=none; b=DJm/gTzJUbHlGgyggbBN6ItwNEPZRRz/zR4yxk0oAMUweRKH1l+/wheyd5n8zUmszH2BUf6cba5Z6e8zp3Mrz058mLtkAYvZFbT6vcqwT3prDUTmSXutnanToKLdp1Fzm89VWgfiNFNnkZhXjH4SHCPd37DHhzDTBbG0jw/vOSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557562; c=relaxed/simple;
	bh=VwOH8cCPKgXpYiD0sE3CMw0skro3lVUwARrukYBSb5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBefita+YXw7ckcDUCWM1Teo14rrE8IS6Xga/DffhHqMJ9i2B8TyQThjKpZLsq9+Q0ro+JArHnlnDYJ/NWc8gN3s8r+1X8SJZhFKsGbwhnfEB2qd6vKAWKHXuWIV8vBc31LU+XOyK6PQQZ0iFC7aVfHIeBgTs+o8vB7Pw7flDQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YztbVdjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YztbVdjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5401F000FF;
	Fri,  9 Oct 2026 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557561;
	bh=xK3IUue7YO67XDq+5FHIUC+LaBcI44wOGbLIqw0mWaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YztbVdjOLbm7YgTtaucit3lDGwI2oLfUA6zHiR1eT3jsjBEXa4iUuF3oMg8lHBqme
	 wTKcyW72zNSlR1jIcitIjtU9WVSbA0tckABio/UnMS11t6xDPguiNiMaO+q4+gPwHE
	 HDBF+NBIT4Pxh9ZtsgCgN/xYeEGbyPqEr8dV4iRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 404/428] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Fri,  9 Oct 2026 16:12:21 +0200
Message-ID: <20261009140955.093873025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -1497,6 +1497,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1519,6 +1520,7 @@ static void gp2ap020a00f_remove(struct i
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 }


