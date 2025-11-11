Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4AF3469F0;
	Tue, 11 Nov 2025 01:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823653; cv=none; b=WCCWFOpd+OhnFYFvIbSFFhFiZduR481rIYp1umtHexsg5jzfH0KoUcE5cTvGYo8930Y7OqE0bD2pAL3D/2YMhZ34xyQn3E/q5DiCtAYe1D1HHUSfc4xjr8/1us6u2Q8td8PP22KXv2GzLiK2KKVVJId4i10ygLFkPhKy0XS+58w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823653; c=relaxed/simple;
	bh=EufpvHkRWkrDRx+QxKlukmfwJEi4urHZ8qq0M2t4ogM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QvPyjAGHjhCt1RTDCilby24aII8xVHbLk3wfY6K5mcESrq4LujC5fEsTpGOg8L9cnPo/WeBP0UByD1F2nDvFVwgI2axepQ9Pu7WrHqnE2mtryCJE6fc/ckfvwAkPY1Fo2/Jx6x+CQF90oFRNkShIOuebGuMYhG2Nr8i1+Y2pp0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJYiy038; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJYiy038"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33589C19424;
	Tue, 11 Nov 2025 01:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823652;
	bh=EufpvHkRWkrDRx+QxKlukmfwJEi4urHZ8qq0M2t4ogM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJYiy038g1duL4LLKEu0YXWne6cURBxBksBQQBhQV5DyJvhyXCik50gTExK/yUMyz
	 dh3MfKgAsGmtP33TkkKS6kSM5HhNfrKAxenH6bRL6qvVd9yEbENNbfTMS6Wm2Ae+ft
	 vVX8Ur5IyAwJhEdC31dfx+fewvX5sISBEryqB1bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/565] media: adv7180: Do not write format to device in set_fmt
Date: Tue, 11 Nov 2025 09:42:30 +0900
Message-ID: <20251111004533.492335045@linuxfoundation.org>
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

[ Upstream commit 46c1e7814d1c3310ef23c01ed1a582ef0c8ab1d2 ]

The .set_fmt callback should not write the new format directly do the
device, it should only store it and have it applied by .s_stream.

The .s_stream callback already calls adv7180_set_field_mode() so it's
safe to remove programming of the device and just store the format and
have .s_stream apply it.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 684a9bba3c5d2..6eb55f0d89dc9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -812,14 +812,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	ret = adv7180_mbus_fmt(sd,  &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		if (state->field != format->format.field) {
-			guard(mutex)(&state->mutex);
-
-			state->field = format->format.field;
-			adv7180_set_power(state, false);
-			adv7180_set_field_mode(state);
-			adv7180_set_power(state, true);
-		}
+		state->field = format->format.field;
 	} else {
 		framefmt = v4l2_subdev_state_get_format(sd_state, 0);
 		*framefmt = format->format;
-- 
2.51.0



