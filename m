Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A6F1D07BD;
	Wed,  2 Oct 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878187; cv=none; b=seGVUjHKzcLtWooxoJbJbT3v0UwEA10945IWJ15fFOyRu8870QUeU5vQ/IXPNzvcY92qkq9FdkgJgodDQFRlud9j/IDEQ5axGWHsQIdjlSMSKUDjxUl786l/0VXDqtu48VyMkz7aZbKRNF5j1VxDJLoY/K5VncQgJ6hP7p2yQAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878187; c=relaxed/simple;
	bh=a04ZGxb+lnbbPgBOTxj+sYOkw0GpLlpvTEdB4GYDNk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj5vzqxcD5RuG5QGMx21L6OdAgxmHRrG1e3IyDw/R7eW5xFsx54ATAChBHhGdoRsIz6uhkPi21Apo05pbkCYJ61pqqLTbG1q+qtqLtVJZFKihxTNY6pLyn9ZbhspQBjwj/mj4U9FZ9xxM+YjmLFLYqLcJrD1Y4yxkqa3nzDxKnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjl+aC/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjl+aC/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08899C4CEC5;
	Wed,  2 Oct 2024 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878187;
	bh=a04ZGxb+lnbbPgBOTxj+sYOkw0GpLlpvTEdB4GYDNk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjl+aC/uCrjKK2S9id05gSdNC5k0nwMHnGhI4fOy4DmbxrYrYy5ckC22i1A+IZON/
	 +Nw45mflWEBVBe2ZC037rJzbQCzCLd2JqSMf63f1MXKgJnFdCZRVy/wIlrMhdNPG3t
	 1UYVAGjlNwZH5RjK//viDj/Gx4o/yzYYW5+bMUOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 329/634] Input: ilitek_ts_i2c - avoid wrong input subsystem sync
Date: Wed,  2 Oct 2024 14:57:09 +0200
Message-ID: <20241002125824.090736638@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 7d0b18cd5dc7429917812963611d961fd93cb44d ]

For different reasons i2c transaction may fail or report id in the
message may be wrong. Avoid closing the frame in this case as it will
result in all contacts being dropped, indicating that nothing is
touching the screen anymore, while usually it is not the case.

Fixes: 42370681bd46 ("Input: Add support for ILITEK Lego Series")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240805085511.43955-2-francesco@dolcini.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ilitek_ts_i2c.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/ilitek_ts_i2c.c b/drivers/input/touchscreen/ilitek_ts_i2c.c
index 3eb762896345b..e1849185e18c7 100644
--- a/drivers/input/touchscreen/ilitek_ts_i2c.c
+++ b/drivers/input/touchscreen/ilitek_ts_i2c.c
@@ -160,15 +160,14 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 	error = ilitek_i2c_write_and_read(ts, NULL, 0, 0, buf, 64);
 	if (error) {
 		dev_err(dev, "get touch info failed, err:%d\n", error);
-		goto err_sync_frame;
+		return error;
 	}
 
 	report_max_point = buf[REPORT_COUNT_ADDRESS];
 	if (report_max_point > ts->max_tp) {
 		dev_err(dev, "FW report max point:%d > panel info. max:%d\n",
 			report_max_point, ts->max_tp);
-		error = -EINVAL;
-		goto err_sync_frame;
+		return -EINVAL;
 	}
 
 	count = DIV_ROUND_UP(report_max_point, packet_max_point);
@@ -178,7 +177,7 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 		if (error) {
 			dev_err(dev, "get touch info. failed, cnt:%d, err:%d\n",
 				count, error);
-			goto err_sync_frame;
+			return error;
 		}
 	}
 
@@ -203,10 +202,10 @@ static int ilitek_process_and_report_v6(struct ilitek_ts_data *ts)
 		ilitek_touch_down(ts, id, x, y);
 	}
 
-err_sync_frame:
 	input_mt_sync_frame(input);
 	input_sync(input);
-	return error;
+
+	return 0;
 }
 
 /* APIs of cmds for ILITEK Touch IC */
-- 
2.43.0



