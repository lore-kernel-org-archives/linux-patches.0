Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD73229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AC4C433EF;
	Mon, 30 Jan 2023 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088784;
	bh=xWR1no2GUHRJRi6ZMYnwd/p+LgTk7+pTJX6RE2FVl6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpqSRDoM/67lWaYkEi9ocaVseJ8re67vLX9b2DzkXZq3Cf0UCh3sr1FwjPilhtJBj
	 QWQXZ9lea2AGSsD1htHiustQ5J4blxnhVBy8MRKzgZW0vHKyQpNDbEX5KzdvH0Kmbh
	 AWkWW7DJGcING29zNwZCq1JWnUPookLX/7wvBQcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivo Borisov Shopov <ivoshopov@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/143] tools: gpio: fix -c option of gpio-event-mon
Date: Mon, 30 Jan 2023 14:53:11 +0100
Message-Id: <20230130134312.376123310@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivo Borisov Shopov <ivoshopov@gmail.com>

[ Upstream commit 677d85e1a1ee69fa05ccea83847309484be3781c ]

Following line should listen for a rising edge and exit after the first
one since '-c 1' is provided.

    # gpio-event-mon -n gpiochip1 -o 0 -r -c 1

It works with kernel 4.19 but it doesn't work with 5.10. In 5.10 the
above command doesn't exit after the first rising edge it keep listening
for an event forever. The '-c 1' is not taken into an account.
The problem is in commit 62757c32d5db ("tools: gpio: add multi-line
monitoring to gpio-event-mon").
Before this commit the iterator 'i' in monitor_device() is used for
counting of the events (loops). In the case of the above command (-c 1)
we should start from 0 and increment 'i' only ones and hit the 'break'
statement and exit the process. But after the above commit counting
doesn't start from 0, it start from 1 when we listen on one line.
It is because 'i' is used from one more purpose, counting of lines
(num_lines) and it isn't restore to 0 after following code

    for (i = 0; i < num_lines; i++)
        gpiotools_set_bit(&values.mask, i);

Restore the initial value of the iterator to 0 in order to allow counting
of loops to work for any cases.

Fixes: 62757c32d5db ("tools: gpio: add multi-line monitoring to gpio-event-mon")
Signed-off-by: Ivo Borisov Shopov <ivoshopov@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
[Bartosz: tweak the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/gpio-event-mon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/gpio/gpio-event-mon.c b/tools/gpio/gpio-event-mon.c
index 84ae1039b0a8..367c10636890 100644
--- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -86,6 +86,7 @@ int monitor_device(const char *device_name,
 			gpiotools_test_bit(values.bits, i));
 	}
 
+	i = 0;
 	while (1) {
 		struct gpio_v2_line_event event;
 
-- 
2.39.0



