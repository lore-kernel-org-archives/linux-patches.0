Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4311A7264;
	Tue, 13 Oct 2026 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895439; cv=none; b=tx6fHJ+/Amv/ISTevbg31b1UCDmUQ3JmsKwqQS8ZSmhbHOt3WtUH2KMGWAtiWphzguq7EH+y/Kv7paqSRNyCmDZyzsbqm19YRfSWcfdweReW5BOtd80RjVmav6dsocGLOzqMvCvrSY/O53MGGMha+bme4Kg5Q3uii8dGkrGHn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895439; c=relaxed/simple;
	bh=FTmnlfXOyaQmxH0jIVwdDo6O06cQ8UJkJocpsyxKcDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnJuZVJsuLu1Go920p9oGYASG3fS8xxYkaGvBc9NWPhGuU/HuSmEjCvxrDQMM7lA3LN8BB2prvIJFNZeotQT/57VlOkNCadwpHkFQroiK9jSLtBRnnxcxsX/cZuu0GIYRAuaJN0oRlgJcdqlwSLDjWP8L8Vx0OaN4BYpQAjqnQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clQHuicS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clQHuicS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03611F000FF;
	Tue, 13 Oct 2026 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895438;
	bh=hpjJ7+Sem+2cvVq6wdfSYIpa/Co1iMLulVzNoaKrPKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clQHuicSDBFdMiZdUPXdlwFEJhH9hVPvdHCzMHs0BEyD3Gbl659HFBSBiiJJdH6oS
	 1I76eO+4EPbJNi0C2PsRP1QWyiuInH9jODzqPxPqKG9anVZIS6mnFczbA/rNYzZk2/
	 IRGFLlT+ncsXXZW8nLx0NK9XQ9XEHPIDh8gSxysc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 231/497] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Tue, 13 Oct 2026 13:36:38 +0200
Message-ID: <20261013112913.381175252@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit dd30c10ff60d2b30386c23bb7c61cc97f2385c97 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kxcjk1013_write_event_config() already ignores repeated
enable requests, but a repeated disable request still calls
kxcjk1013_set_power_state(data, false), dropping a runtime PM reference
that was not acquired for this request. This can underflow the runtime
PM usage count and trigger a "Runtime PM usage count underflow" warning.

Return early when the requested state already matches ev_enable_state.

Fixes: b4b491c0832e ("iio: accel: kxcjk-1013: Support thresholds")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxcjk-1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1068,7 +1068,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


