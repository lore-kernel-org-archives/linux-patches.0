Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216232309B0;
	Mon, 10 Mar 2025 17:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628654; cv=none; b=fzcIBkpcQMqUhZLTXI7Lnf3dRiM8Ix/Lr1YTlEUtOIPFPFAGEmva3GcOjjpAKJo9ddjNku6mMxNCc2Puykl8fnx6sIYw6ZOl6YG7S9k50Cf3bwBMkwl6cJAWkpDHv80KGVfUSnOAWFjm+Hi68H+r3Tp3WASnp+Dw52K8TbtRjh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628654; c=relaxed/simple;
	bh=oh5A1Qcd0O2ZBX6+/a0ROfGFG9k1HH345xdOuT7Yl2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHa+hID4dE3cVXNpQLE9yzDnNXM4cGHAg6v9oDna5mIT0SobHFkv0CFhxwiodCeC4W8cbhRf+gAPH/utLyLk8PRT9hPrgRn56BTnwfiEa3/7Py3fZ/tIjREgR8dXPO4dISTKBZBo/JbJJ5knEox3DUUdQUk8tVl9G7NM9rx40G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVcyJihb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVcyJihb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A440C4CEE5;
	Mon, 10 Mar 2025 17:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628654;
	bh=oh5A1Qcd0O2ZBX6+/a0ROfGFG9k1HH345xdOuT7Yl2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVcyJihbqtDBx1CLe0gmDHQbpVn6AgMZo4W65ZE+mESx27EwDvAC2ugGRHtBZLx58
	 /WKfMrwYrY5v+6y30ZduiFuWL+sn4p1YDeN0ccOq/A6FJlil9Z6RfuGYtfc7jEQYU/
	 zl7oc3WlgGddfkwUMTRU3d4HLl91MQ5OEOHCwdhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/620] ipmi: ipmb: Add check devm_kasprintf() returned value
Date: Mon, 10 Mar 2025 17:57:49 +0100
Message-ID: <20250310170546.489924287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 2378bd0b264ad3a1f76bd957caf33ee0c7945351 ]

devm_kasprintf() can return a NULL pointer on failure but this
returned value is not checked.

Fixes: 51bd6f291583 ("Add support for IPMB driver")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Message-ID: <20240926094419.25900-1-hanchunchao@inspur.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmb_dev_int.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/ipmi/ipmb_dev_int.c b/drivers/char/ipmi/ipmb_dev_int.c
index 49b8f22fdcf03..964bde656f0d3 100644
--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -322,6 +322,9 @@ static int ipmb_probe(struct i2c_client *client,
 	ipmb_dev->miscdev.name = devm_kasprintf(&client->dev, GFP_KERNEL,
 						"%s%d", "ipmb-",
 						client->adapter->nr);
+	if (!ipmb_dev->miscdev.name)
+		return -ENOMEM;
+
 	ipmb_dev->miscdev.fops = &ipmb_fops;
 	ipmb_dev->miscdev.parent = &client->dev;
 	ret = misc_register(&ipmb_dev->miscdev);
-- 
2.39.5



