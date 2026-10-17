Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED013B4404;
	Sat, 17 Oct 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256743; cv=none; b=dUS+07Umjjn0y2DPF3T24xUZt4lioeLC34Y9EVp/vWhFfzbH2B0+WWqAyxb+z7YFhYG70ikWhOoKQV7GY817GoAK3b2DZlRkCx8Y1ynxM+BGfzfz3ZT3oBkFRvJ4r8chiCpGHnqdi74O/U7mOxq3N73QsQ6iiSX8Q4cDELRnY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256743; c=relaxed/simple;
	bh=rC+GAUc2jtiBtDmbLnNcCg/Hjc6ukVT3XXWdlNLyaV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RABL5SrsK60Wt73SBcRFjX8AcbwWJOh6JZf1wOUJalDEpBuaocxU0UMUIm6qB4/pWyUlRN/tzdHiq+Y/R+DcaicuSZWUIJ+/1ndInlBXunINWrV5xF6wqKngsfFiDwHQP3Y7+MRmHber3pS/414m7we/w4BUY4rkFx8qvdcbyEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwnNl0w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwnNl0w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E61F000C4;
	Sat, 17 Oct 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256742;
	bh=4zClSySZaYKfGRj+JXuZY1ZFBk9eMb3+CzlDUIX20CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwnNl0w4tpZ//1vh4NVj2KjpvGrroFNaIu9Ge6HLnvDWpoOiovQg46O6A11os8/w8
	 tJouR2+j7kJ+5tpKMHc2LXOtoYHB9U3KR0VZAKYSenkMsLxmqOj1Tqm47wF0XXZOJV
	 TzUY82uGY+DKo/TMtoAIFXRLST2wC5/tpWEQPnqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0335/1674] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Sat, 17 Oct 2026 17:43:27 +0200
Message-ID: <20261017160439.725310493@linuxfoundation.org>
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
@@ -1050,7 +1050,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


