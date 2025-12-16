Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0379332BF22;
	Tue, 16 Dec 2025 11:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884252; cv=none; b=u2a7iOByL6qVwXb1tf/xxTQEJ3f1HYx8oa2zgVNng428eY4KWifdeTa02PqB1uZBzIC7JUzsFLVryd0UroICA2deEDGi/m/ceGUMq8zwkrQSs065KKu+NHR8nYR+Jz6g7a8CgML7YOcbE7mstHwlteJqXSSgAzRvbOkToWhuR6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884252; c=relaxed/simple;
	bh=JLfkkmEcF9dm3jkPw45J0VXWtg77KPlLBE4YVUnrXLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXH/zfG9Oe1Q69jfSwowJ0LJmrLOVHpCBlrjAPD+bx+ZyZ1W06HjybtEuAD54vZBb7NoPj7WJv/hsRyR0DFUu9KwZaFmG05oD81lwcokP5qRk+zIvActxFZDVbIgNjx2hu1DpulIWTIs8Y24i+szgfg+kGQgrPucgrM/SBbvZMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hP8T2b1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hP8T2b1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61083C4CEF1;
	Tue, 16 Dec 2025 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884251;
	bh=JLfkkmEcF9dm3jkPw45J0VXWtg77KPlLBE4YVUnrXLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP8T2b1s0Ekjjxot9gObxXPLe71yw56pDxrbzHKol7zl2sd6ePtOqqxoFkNan3TH6
	 78U5ZfSXWUHY4188XnZl3wQIsuqV7aK2BGX9Iy8ItcIIJDMD/oV6by41FvkDshdEdt
	 Mi4OC42IA50m+llXqOiKnCK6sGpAA1R8nQrQXd0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/354] power: supply: cw2015: Check devm_delayed_work_autocancel() return code
Date: Tue, 16 Dec 2025 12:11:11 +0100
Message-ID: <20251216111324.687671968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 92ec7e7b86ec0aff9cd7db64d9dce50a0ea7c542 ]

Since devm_delayed_work_autocancel() may fail, add return code check and
exit cw_bat_probe() on error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0cb172a4918e ("power: supply: cw2015: Use device managed API to simplify the code")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251008120711.556021-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 382dff8805c62..f41ce7e41fac9 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -702,7 +702,13 @@ static int cw_bat_probe(struct i2c_client *client)
 	if (!cw_bat->battery_workqueue)
 		return -ENOMEM;
 
-	devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	ret = devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	if (ret) {
+		dev_err_probe(&client->dev, ret,
+			"Failed to register delayed work\n");
+		return ret;
+	}
+
 	queue_delayed_work(cw_bat->battery_workqueue,
 			   &cw_bat->battery_delay_work, msecs_to_jiffies(10));
 	return 0;
-- 
2.51.0



