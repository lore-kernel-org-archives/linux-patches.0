Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904994519A0;
	Fri,  9 Oct 2026 14:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557473; cv=none; b=NtPY3aOUY+yAFAtsToOwITwHciCT+UlkQlzug49G5wCrPDIH0pYBLjnuziv8FOpel2ansjqr26EMpP+g0hmSSSoOEV9ApCAIgg5CxR52KRfZV6sK/YGIA7Whu4sR/aGI5PxbrrmXXg+bCevwaL2hAZODhpyq40/eoyPuaE6pxco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557473; c=relaxed/simple;
	bh=ZI4EpLeeoVxrJDwEOMJODkjokX/3NCc/dA3fgL4OZR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzxXCgl/qNHAQ00N2jzFoAlvsGHcxM2iiP7MEz8lKj/LbJp7xOu8Wa5IyY/3o8TaTCDiyG8T9+55EVzumLtUlpniYrfPJCRxaKqNvaiOrARRP9QZW+OJA7ff2zkPewv9t62PIPZ55qSwovCi+UUsFt6OPwWns660cVm3+KcmvoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYMc5/N4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYMc5/N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBD61F000FF;
	Fri,  9 Oct 2026 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557472;
	bh=eRbyuVZkbjrpsXoPtftFl6cr5W6VC0PCiQxJt8Y5Y1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYMc5/N4ViD5Grr2Xk3EBATeRKq9WUuW+tBDw9YIxGTgAzJjJIUpPUpirTQCiSdGt
	 sHAGY5fNNAZ+YzdnvbKLgoYf++FgkYGJ4681Cu73BBT6n6brZtJJGwh2K3DBm1NWHF
	 /A0wCEUlwQFooYZ6VliGNk1s0EuL05+KR2MvvKxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 371/428] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Fri,  9 Oct 2026 16:11:48 +0200
Message-ID: <20261009140954.334413454@linuxfoundation.org>
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
@@ -1030,7 +1030,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


