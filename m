Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022AA3469E2;
	Tue, 11 Nov 2025 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823648; cv=none; b=C7jbd9uGtfMgWOz1TMZggVNzL4VnR4UOjlpdtmpdP0ba3Q7Ma5aotPKWolQVovFezeQRxRouTDi28uw40CWFVRxu0ijkIeedPlDYhPjRPt23M+n13joP8jZpyuwE1TWMj1cvyh7MPubkl9kZQplQ/wqD9plU5E65nYZm6+zBRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823648; c=relaxed/simple;
	bh=+UJLF2xNZv2mr9/ozkphesT9cr1Luxv1HMq3s+kgVOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZZQErjlLqkJ1GYWOmlhiasyrzADEzXaaUtpJU1XjoHhpiUw85dHBBcNBFhFv/i2TjPELwaDB5iMpw5wtd5IK5fERwSMOSJPxXwdIkSG2w/XPUXfhPo0Z7qa2/pvFlcRs94mAvirBYI7F4boAozbXRNFmkN0dEQXp6JuVdcL+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13YxsCUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13YxsCUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D2DC113D0;
	Tue, 11 Nov 2025 01:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823647;
	bh=+UJLF2xNZv2mr9/ozkphesT9cr1Luxv1HMq3s+kgVOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13YxsCUUTmI+7ZVuSBRmSz1ZLUMt/8s1btxsVoEs7zCql/lHFJUpIuN5bRBB7icqu
	 cOVYvSXxIKkq/EffNGtoBsgRb7lY+bRcqaTrkgBhq2bGXAHbXkooZB9Jt6MPSdQWZ9
	 wSba9JiV1qKviWQziNqcFmXNmd2NNIziYS1cn23k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/565] media: adv7180: Add missing lock in suspend callback
Date: Tue, 11 Nov 2025 09:42:29 +0900
Message-ID: <20251111004533.469906293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a20a4fad796c..684a9bba3c5d2 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -813,6 +813,8 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		if (state->field != format->format.field) {
+			guard(mutex)(&state->mutex);
+
 			state->field = format->format.field;
 			adv7180_set_power(state, false);
 			adv7180_set_field_mode(state);
@@ -1564,6 +1566,8 @@ static int adv7180_suspend(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct adv7180_state *state = to_state(sd);
 
+	guard(mutex)(&state->mutex);
+
 	return adv7180_set_power(state, false);
 }
 
@@ -1577,6 +1581,8 @@ static int adv7180_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	guard(mutex)(&state->mutex);
+
 	ret = adv7180_set_power(state, state->powered);
 	if (ret)
 		return ret;
-- 
2.51.0



