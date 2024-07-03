Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6FE17B404;
	Wed,  3 Jul 2024 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005977; cv=none; b=quS3MADlXm7kGW/FIXqqeQjXlaTa5W2QOQHvSTealFC5NK57R4peB5vDqfAaI810KkkWx97M+ckdrKlxysPvU8ZnE9iJDQMzJ1J7DkDd1vwq9XNDB7I8dS6VEvbEQet8MUtUbX+zhc1Ccwy6xOYxrrLdqBa5LVD5or1ZREyorCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005977; c=relaxed/simple;
	bh=ZIV7o5NpZujEKKDF0MBMzK1HSU3uUxXpIv479/qu/yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgRpsEovJRtdeuirp5bbGYPeg/eCnF+q+3tBWtsDCP4iN5sMPA3bX7WZNzm4lHh62DPRLHDyVoFdPZsj2xGI48qNwOzdV30VTejnKjqVh4Xs2kMHxeCTGOrK94W6mdTEIR279JPcrtapYFWVYa173zSkCKjpCR8hI27OojcEUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J92nDyjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J92nDyjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF3C32781;
	Wed,  3 Jul 2024 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005977;
	bh=ZIV7o5NpZujEKKDF0MBMzK1HSU3uUxXpIv479/qu/yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J92nDyjKnJ6+eG1m3JWc/CDBhmAKBTrcmar0WsSsEY+Hl6TaJtKt6A+ZK+eXCoS21
	 PvoqjOkCGIzUOe0EPHbRVnPjpYlHlvEnIXbdHPNH/+leYhxzvMgP9eJ646qRF0LWTD
	 zcVTpZUblxZjIHlWexnlFnvgK1+4puuFbFjY+KHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/356] Input: ili210x - fix ili251x_read_touch_data() return value
Date: Wed,  3 Jul 2024 12:39:56 +0200
Message-ID: <20240703102922.954080610@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



