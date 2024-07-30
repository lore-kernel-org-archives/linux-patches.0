Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35DA1BD01E;
	Tue, 30 Jul 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355082; cv=none; b=Zy0l4D7oKWPFMBZrPw6LOmynq+nuJbUYthmyE0FtSB2mI7KSwtGrjoHcApK1RB2Hw2B0NEwr8zMDhX943g79mCpFLD3I076ahgWAodsKg7F6lrJBZ4XRXgF9x3mO35yAqaumlOzUUcJwBKLFSrMncq5MbYb2iO/zTO2p1CT1xBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355082; c=relaxed/simple;
	bh=VdaCktDo+E+dMu3sC9Ykmi4qMQqFWi63pnLMwmPNsjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSg58ZV3E4u8YXcDGF+1ZTw9OUM+q4f3PKlE/sMGQ5/yyviEwZrux396W1D7StsWxcmzfLPHcuz4mKrFtMBZwizA6BCdoOG8rdgRDIXzi860n3crumxolg22jMbakzH+tIYF67nK4EXwn967VWGXljFr4ESieYIiSegvWlpks8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwSGKE+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwSGKE+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A19C4AF0A;
	Tue, 30 Jul 2024 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355081;
	bh=VdaCktDo+E+dMu3sC9Ykmi4qMQqFWi63pnLMwmPNsjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwSGKE+lBtBaHdHbxgup1jKndKXBJy7u/LK4bUDQ0oQpQEokvp97tDfJ4f7QJsPFf
	 5qJehyx01q/TiL23MlQ6oF4DaJdKoOAhh5pGjUQkpsWFMpfdHk3XoZ/BQWbtiJOIMm
	 KldZqhLIdTwwtCmVDzFjoxVzKFoBdV6PhDnsm4fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/568] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Tue, 30 Jul 2024 17:42:13 +0200
Message-ID: <20240730151640.855723412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit cbf7467828cd4ec7ceac7a8b5b5ddb2f69f07b0e ]

Using DIV_ROUND_CLOSEST() on an unbound value can result in underflows.
Indeed, module test scripts report:

temp1_max: Suspected underflow: [min=0, read 255000, written -9223372036854775808]
temp1_crit: Suspected underflow: [min=0, read 255000, written -9223372036854775808]

Fix by introducing an extra set of clamping.

Fixes: 5372d2d71c46 ("hwmon: Driver for Maxim MAX6697 and compatibles")
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 7d10dd434f2e1..8a5a54d2b3d0e 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -311,6 +311,7 @@ static ssize_t temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&data->update_lock);
+	temp = clamp_val(temp, -1000000, 1000000);	/* prevent underflow */
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-- 
2.43.0



