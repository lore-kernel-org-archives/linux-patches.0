Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228093491C2;
	Fri, 21 Nov 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732627; cv=none; b=spjnwqA1NLLcrt3BOahTW8NfE8cK0dY0HifafycdGDr4eIYbnvu0uTnfqpebbnjJVE8sceNTjmPbwZq2WYDRFDn90WcgLNOjm/hUsWfMRhwG8Iu3u82LFwvXA75n2e0rDs8n/WaCaoQz4M/2kLeWSS/SfvpX0QOTlS/GIZdoV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732627; c=relaxed/simple;
	bh=RwSHI6EXuQaLNfzbY0Bl8IujFYDEOpOK/H5Vy3MZzmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M8wnUVAScC6/JqiN6z5+i8cEVxEdcduM3rS/jTHn/yFoLIqAxWG+lDrvJ8NDtZa8SNpQiWGJnaFxXDmRCeZYuujU0rSuuViEjMQrwdwJCb+plFnh8tkp9odOn6SaRnaYK+8KRkxGp+mxDAx9OCSPoxxhR5jx39dpYQxxP0PKfHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLXpupOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLXpupOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99921C4CEF1;
	Fri, 21 Nov 2025 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732627;
	bh=RwSHI6EXuQaLNfzbY0Bl8IujFYDEOpOK/H5Vy3MZzmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLXpupOZ0e1oC9Dyel7D+GT0gK0BQPaEzAvVQs1hCZpOjYFTaEZm5+MEWxqeYNvLu
	 ZAsXIrZb0GVDhHKT/i6iieAd1xOU6WnD8sql4Ud2Ixe547FGrhwA9lSAvqr12kzIiF
	 11s3JZRDgl4pdpfRd6WdfSTLOd+5BfbUlYHPfkp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/529] media: adv7180: Add missing lock in suspend callback
Date: Fri, 21 Nov 2025 14:08:06 +0100
Message-ID: <20251121130237.673369609@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 114ac0c263fb2..831ce10718550 100644
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



