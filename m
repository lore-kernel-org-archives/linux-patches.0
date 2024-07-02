Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5BD1BE22B;
	Tue,  2 Jul 2024 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941324; cv=none; b=MuFF+KbZP6QBIZ8InUihFYPihW4Z58i4t+mrvA5hgDf1iPleRbT9g780eJrJHHAsYJxf2dJ5edrBD7LOjY3kYYkb/3ZSbBaOp4oXkJkWWrojg9V6BWNyhF7HQTaB5iuYcYA56mSY8i3+UUiXp38iKIMwwpfdx/PWS5qi+bIehIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941324; c=relaxed/simple;
	bh=kkCSWqWS7kHa8g8ftIzcA1GCgUTAJLmjyn9pXo37xFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrLXyRLSJraQeqgbH1SNtflrE4lAnuoPc0Ev4ecs0mS0+vfgXY6lgwH9aDRQIdWWF0PEtZedSJeo61IDzlszHJZut21SQRZjwpToUpl2Hkv7ZaGfCbBLcci2CJtcyJyvAs+/PwHU3mRZ1KGj+xssh21sLqFeAsIu/2gXpeNhOuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDFvAi5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDFvAi5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B918BC116B1;
	Tue,  2 Jul 2024 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941324;
	bh=kkCSWqWS7kHa8g8ftIzcA1GCgUTAJLmjyn9pXo37xFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDFvAi5bAQ8wpwTyNYfUeplkemkrDhZoMtb1mwxqk7DZaWIchFwta7WV8nYMpWe5j
	 UVYVFueoTphPw4dChe9ejcnlDURpJi9DXOpln1txNz8L5BrK1YK9C1kObBOcQf9o+j
	 xFH2lMOOyDPO9hyy/at96i/mPYbXsu3WzAOeKSks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/128] Input: ili210x - fix ili251x_read_touch_data() return value
Date: Tue,  2 Jul 2024 19:03:27 +0200
Message-ID: <20240702170226.476227028@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 9f0fad0382124e7e23b3c730fa78818c22c89c0a ]

The caller of this function treats all non-zero values as an error, so
the return value of i2c_master_recv() cannot be returned directly.

This fixes touch reporting when there are more than 6 active touches.

Fixes: ef536abd3afd1 ("Input: ili210x - define and use chip operations structure")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20240523085624.2295988-1-jkeeping@inmusicbrands.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ili210x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index e9bd36adbe47d..e3a36cd3656c0 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -261,8 +261,8 @@ static int ili251x_read_touch_data(struct i2c_client *client, u8 *data)
 	if (!error && data[0] == 2) {
 		error = i2c_master_recv(client, data + ILI251X_DATA_SIZE1,
 					ILI251X_DATA_SIZE2);
-		if (error >= 0 && error != ILI251X_DATA_SIZE2)
-			error = -EIO;
+		if (error >= 0)
+			error = error == ILI251X_DATA_SIZE2 ? 0 : -EIO;
 	}
 
 	return error;
-- 
2.43.0



