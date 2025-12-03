Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEEC35CBC4;
	Wed,  3 Dec 2025 16:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779217; cv=none; b=tk+eaJvdQw6kUiW3U0uXI2gslfMsqOU/qWiue2MaDa8MUX5+sVwwba3+EN0qrKK5kPhqPmQ5tS32pJgV6Cg+VMEVTYvq+e6Pi+bSlAdMMkzryo0SZZHsRNreID61iXi7dwStWg1UFqvB2BHS4AgVqyGJcYM+kbyVC0LtJTNUr28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779217; c=relaxed/simple;
	bh=FFqgbI17iSZnlbpsqvI83EtslEXhLiXTlMr4pC4tZVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EazKOcZfopUpGsM9r0gLdCsazWN7/bhk8nnNOGrq1cWt4OkUKmB0yICXrQQXUDGDHjDS5BNzbOREnNDAo83WPFXq0VUw4U8rKXPHEAuA47H1raz2OKAGcPYKBsP2St1pD3/Mehwhi28+keLd+X/ea8luSu/XCvdfB7YK+BkD2Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzwaSoZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzwaSoZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5CFC116C6;
	Wed,  3 Dec 2025 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779217;
	bh=FFqgbI17iSZnlbpsqvI83EtslEXhLiXTlMr4pC4tZVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzwaSoZLeiTHLfmZEGPi7PKfDPjAbTfSGniIiec+i3Egyi3QtlFRDcB1xKDyUlQKv
	 5e5ZDXGDMSuf/i3HEC5vBkHcbTFYWSRh7Esf3YJQb+AhvVBE+X2td8kDTvjRuWHbZM
	 PjKu02IFrpN05NGcabePkP5ucWelfUTaAKgUyGDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/568] media: adv7180: Add missing lock in suspend callback
Date: Wed,  3 Dec 2025 16:23:13 +0100
Message-ID: <20251203152447.721129458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 878c496ac5080f94a93a9216a8f70cfd67ace8c9 ]

The adv7180_set_power() utilizes adv7180_write() which in turn requires
the state mutex to be held, take it before calling adv7180_set_power()
to avoid tripping a lockdep_assert_held().

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 46912a7b671a8..a7977f9c64c88 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -804,6 +804,8 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		if (state->field != format->format.field) {
+			guard(mutex)(&state->mutex);
+
 			state->field = format->format.field;
 			adv7180_set_power(state, false);
 			adv7180_set_field_mode(state);
@@ -1568,6 +1570,8 @@ static int adv7180_suspend(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct adv7180_state *state = to_state(sd);
 
+	guard(mutex)(&state->mutex);
+
 	return adv7180_set_power(state, false);
 }
 
@@ -1581,6 +1585,8 @@ static int adv7180_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	guard(mutex)(&state->mutex);
+
 	ret = adv7180_set_power(state, state->powered);
 	if (ret)
 		return ret;
-- 
2.51.0



