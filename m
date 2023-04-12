Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4032F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A778DC433D2;
	Wed, 12 Apr 2023 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289392;
	bh=21OnGELfFIqpPmaF6jBtOcYh5Fp4wg3v95cGurPvF2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmL7FxzjOZjRJjKn/pJvPpZ1fIxPH0SNhgo6vf84EhoJpXLepZY5BLyGLi6bMRjca
	 Wtp1qnnowWUxHd+fmez8S5kTP045TcyfzuMFJCEj8JZFKF+fc8fLYlAnd6G/e9vSv9
	 APnhbB+KUQqgdjBn8f7FlxicuvcYuCrmLcqTRzHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 081/173] iio: light: vcnl4000: Fix WARN_ON on uninitialized lock
Date: Wed, 12 Apr 2023 10:33:27 +0200
Message-Id: <20230412082841.329969092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mårten Lindahl <marten.lindahl@axis.com>

commit 42ec40b0883c1cce58b06e8fa82049a61033151c upstream.

There are different init functions for the sensors in this driver in
which only one initializes the generic vcnl4000_lock. With commit
e21b5b1f2669 ("iio: light: vcnl4000: Preserve conf bits when toggle power")
the vcnl4040 sensor started to depend on the lock, but it was missed to
initialize it in vcnl4040's init function. This has not been visible
until we run lockdep on it:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  at kernel/locking/mutex.c:575 __mutex_lock+0x4f8/0x890
  Call trace:
  __mutex_lock
  mutex_lock_nested
  vcnl4200_set_power_state
  vcnl4200_init
  vcnl4000_probe

Fix this by initializing the lock in the probe function instead of doing
it in the chip specific init functions.

Fixes: e21b5b1f2669 ("iio: light: vcnl4000: Preserve conf bits when toggle power")
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230131140109.2067577-1-marten.lindahl@axis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index cc1a2062e76d..69c5bc987e26 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -199,7 +199,6 @@ static int vcnl4000_init(struct vcnl4000_data *data)
 
 	data->rev = ret & 0xf;
 	data->al_scale = 250000;
-	mutex_init(&data->vcnl4000_lock);
 
 	return data->chip_spec->set_power_state(data, true);
 };
@@ -1197,6 +1196,8 @@ static int vcnl4000_probe(struct i2c_client *client)
 	data->id = id->driver_data;
 	data->chip_spec = &vcnl4000_chip_spec_cfg[data->id];
 
+	mutex_init(&data->vcnl4000_lock);
+
 	ret = data->chip_spec->init(data);
 	if (ret < 0)
 		return ret;
-- 
2.40.0



