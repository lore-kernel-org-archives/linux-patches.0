Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098314F3EDB;
	Tue, 13 Oct 2026 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895375; cv=none; b=sfcDKmdrBgMvGZByVhuDTYs6TNX2Wf4I7vEme2CMgeUxUuQkHi4JeOoEEbJ14Xy3ZkWkNhhJMtQgP/LLloZQG2XCkxcXXPmtq25GydHMYzqsWy012YzLd40D4rA0xWGldQ05uxRiOzoUjoYXvK0mpZAnx3g+xkLjl0N4vy0pQps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895375; c=relaxed/simple;
	bh=hBstgkg/Lu2MeZwQAM3t+gI7WG9bNrudhmJ4nv2iv10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOjb2kWzHGhBQEhh5ICUhR6OdNmxq5zNngZ123+/MLSmHqJbmiF5OiQxPVRzNLxVnQ4xQHZVkBHZ/iUKy6NBCBW2tKAWTGe4TFk0kNiSPlNwJ6zIwWt6AJ0K8Dyy6PwxsanXUDQGAKvsgfFnom3YJSE3ceXfRYqjqXY5RH39RI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCv52qeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCv52qeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120081F000FF;
	Tue, 13 Oct 2026 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895373;
	bh=a1EiNe1KPIMw3ES1AigTp9bLZH1WN9MY1oJUUNFQuZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCv52qeVEQl7clK7dz/QDRrSLP4TMRbx7Ftb0+BWjL+Hf/Qlb7LRJQXJDtB5F+u1n
	 5DBay4TgoKqud9kBkGgmSeznT6YApd0esJtm2RC1eRu6R3mQe2QFHLsOMIfatqXXjs
	 8NX3Sn4J747C/IqLj29Dg2sUgILWpgUNtABM+uvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 253/497] iio: trigger: cancel reenable_work before freeing trigger
Date: Tue, 13 Oct 2026 13:37:00 +0200
Message-ID: <20261013112913.895889895@linuxfoundation.org>
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

commit 2a57b9246cecd5dd797a42eb310d6c8816f26d9e upstream.

iio_trigger_notify_done_atomic() defers ->reenable() into
trig->reenable_work on the system workqueue, and the worker dereferences
the owning trigger through container_of().  Nothing cancels this work
before iio_trig_release() frees the trigger, so a worker armed by the
last in-flight IRQ can outlive the free and touch freed memory.

Cancel it at the top of iio_trig_release(), which every free path
reaches through the device core's final put_device().

Found by an in-house static analysis tool.

Fixes: 9020ef659885 ("iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -509,6 +509,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


