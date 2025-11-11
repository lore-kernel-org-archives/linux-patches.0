Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ACB3431F8;
	Tue, 11 Nov 2025 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824083; cv=none; b=Opexd3ftd+hfkK+ogdaIK4/chngw+KcLtuboTY4Q0umFPxT3i0QZz5haacZ4vaT7+4MUWs47OaqFjNi8oHsmUF+D06jutGnrNiYRGRr0pqoKXb9M/Wh7NMkGs4H1yyt9nM24I5EVQzTG/vz/BQ5ySTjlvRXtfbVVqlLuhWT/58Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824083; c=relaxed/simple;
	bh=LrDuVaTVzfvYbiFdhdi/t0PA8dOyoIw0PBibWXRSxSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNtqh9IP6YqNIVtP0l78j7NYED2Jy2Sg3rDs8efrsWOmUboJVP7QpmhJ6AhrKupl9G0peWsT6udT1pXTEfFuKf1W2Ck63lc2YLacqAgaKQZzfhLOBhqudO38/d/O1x+5NSvzd3vADhgLRVPeZiZbGKHXAvw4JUnpAzZGv24F22M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA9jQBdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA9jQBdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56DBC4CEF5;
	Tue, 11 Nov 2025 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824083;
	bh=LrDuVaTVzfvYbiFdhdi/t0PA8dOyoIw0PBibWXRSxSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qA9jQBdLLvSJ/sXpC6ZWl41BWJHMTnzVUZ3c8IwB5k1+IvfuedihdyvSXq9au2lsW
	 gCXrvML8jJMpzLHdWYSlIjhCm7gSz8Nt2jTyQbFjXjeuM7wae3e+m4i7vQp0s9f0U8
	 12FzIOJuxy73LEI1acC9/HLrdr6u7N38+lcc+xrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 433/849] media: adv7180: Add missing lock in suspend callback
Date: Tue, 11 Nov 2025 09:40:03 +0900
Message-ID: <20251111004546.900053819@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5d90b8ab9b6df..84600fa75ae8a 100644
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
@@ -1549,6 +1551,8 @@ static int adv7180_suspend(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct adv7180_state *state = to_state(sd);
 
+	guard(mutex)(&state->mutex);
+
 	return adv7180_set_power(state, false);
 }
 
@@ -1562,6 +1566,8 @@ static int adv7180_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	guard(mutex)(&state->mutex);
+
 	ret = adv7180_set_power(state, state->powered);
 	if (ret)
 		return ret;
-- 
2.51.0



