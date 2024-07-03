Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92C4136E2A;
	Wed,  3 Jul 2024 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004929; cv=none; b=K/qGXvqaqVuKdHCakTqq8qkM13CD4QDRuukgKqXj+fc+00RclaN3xrdCZk8kuXNeUHfTdu6dohR5K6Z5pqy+Zmml7jNBFeYx86w2lcJ2nQgEhci4ouv3AvzCLhTWX8rz+HDTo958EiwV3b8LoKWLJrHEO08ukn4s+ojOg2ovULw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004929; c=relaxed/simple;
	bh=aydpzet7+5dXrnjW7HPdxTL+UaWyQmgmKQEMdHjxhc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvKYsV6HEqIz1RjFRmQDRQkvQWtm8RsWay2lf6Gvu0hOD+9e3bC87qVqA71PdG5gz7eAEQuiCSVmBK5YFlaug7sUmD45h5RO+0e7+uOhmttaEyqP1DyifMuo+lmVH1K3LRHgO/1wVtWua28I5Q6Wml4ULSHxNFyYSoAQOo4o8JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4rqE+5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4rqE+5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E73EC2BD10;
	Wed,  3 Jul 2024 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004928;
	bh=aydpzet7+5dXrnjW7HPdxTL+UaWyQmgmKQEMdHjxhc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4rqE+5EYk4WRTC0fKH9PKjhisPglz4ATHiQP9ESh0cqcAKiu59WwEvRfRWHku76R
	 lGtNuYwmjary/l3au4SYk7iY4qN/vq2qGvLKg5wbFcF1EjwlxNlCXJtR/U1f0Ndvnv
	 ZI56roSjB3N3KWTgcm+iUDWGb629Zt/RieE3IQjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/290] Input: ili210x - fix ili251x_read_touch_data() return value
Date: Wed,  3 Jul 2024 12:39:45 +0200
Message-ID: <20240703102911.868422598@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f437eefec94ad..9452a12ddb096 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -231,8 +231,8 @@ static int ili251x_read_touch_data(struct i2c_client *client, u8 *data)
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



