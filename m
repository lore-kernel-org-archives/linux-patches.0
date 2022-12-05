Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6732815C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E8AC433C1;
	Mon,  5 Dec 2022 19:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268821;
	bh=b1CbOiWRUw/e80CJapgJt3Jhdul/Ig9uRW3+UhFwcjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvDs7ngVdMy6tFIo3xKWG+jrfh17gQw9uzl5fptcWIlGMRYvbZKAWYlacb5bhwhGd
	 Q3/g3LlEjqiKj7AezN9uzSBAB11Sqyw6bf/g3wdTLyUYQzf7BxZdFD8JrlQajN8I/S
	 kLtnd1HOBZ4zO/8qz1L87halqUj5O/A8ufXeQUWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/120] hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails
Date: Mon,  5 Dec 2022 20:09:24 +0100
Message-Id: <20221205190807.299233754@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e2a87785aab0dac190ac89be6a9ba955e2c634f2 ]

Smatch report warning as follows:

drivers/hwmon/ibmpex.c:509 ibmpex_register_bmc() warn:
  '&data->list' not removed from list

If ibmpex_find_sensors() fails in ibmpex_register_bmc(), data will
be freed, but data->list will not be removed from driver_data.bmc_data,
then list traversal may cause UAF.

Fix by removeing it from driver_data.bmc_data before free().

Fixes: 57c7c3a0fdea ("hwmon: IBM power meter driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117034423.2935739-1-cuigaosheng1@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ibmpex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index b2ab83c9fd9a..fe90f0536d76 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -502,6 +502,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
-- 
2.35.1



