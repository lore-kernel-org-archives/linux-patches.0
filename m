Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1764E36C0;
	Tue, 13 Oct 2026 12:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895354; cv=none; b=O72Ehmfl12X+64y1QaihWixEJDOELvwDm9ROuvJAs3lU5CPfZE0mcjxBnw+tYEQlUXS13WiVgqB2WN9tcSZguH386NLC0cSo1qit/rtYkY6vx7Ml/vW4VyTSZLSFuJVWunLnKfhnWfFbqFvrTXKVi+BbWRgPuyqsBbzSQ38+7Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895354; c=relaxed/simple;
	bh=55DKJlIWTYnX+OFKgGzezAuAAUenHaYDyQfS+6ZpV28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6sLcyvBN0F6rxx1xGoUCYAb9cXuC87AVZOgsf3rU4ZrGi1cxo7gsyWmkJfxc/RdgpsRcNwvgSgtE6YoWU3LsgS99Fv6xD0kDLHkJBYj1HkxS6XZ8ogR/UVWox6q9mCFG8vN3vG4/AR2LSRQp99ACMcySVclsJi/2k2lwzKXR6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9C38YpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9C38YpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508901F000FF;
	Tue, 13 Oct 2026 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895352;
	bh=z4OppqI8n2dpgOj2fg+BPOvow61d16UflnNAtUi1zsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9C38YpGZUrNZPXPdEu6/NBbVM+QWPtDerzHo2Sqocz1I6GF6xpup2ssQHIzE07yj
	 N50KgQt+eGyKYpV87lmF5gOjQG+bILku6nYh6HccZ61qWbc+Uxz7TMx6zDjMwiprwI
	 R5hNvART3X+SeIUlBvj3VptRzB3JQ/Ixezv/rlq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 246/497] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Tue, 13 Oct 2026 13:36:53 +0200
Message-ID: <20261013112913.734457642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1561,6 +1561,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1583,6 +1584,7 @@ static void gp2ap020a00f_remove(struct i
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 }


