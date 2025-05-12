Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FCF254B10;
	Mon, 12 May 2025 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072069; cv=none; b=fbqY0HCpvCdU5OVfKoQKo3FY24GvHA3jEFbFZ8npFo7uCJLb2sU8TsoocshE2jh6JkFSNCGJ1dD16FLYbcC0WCQfqI+iw1hXn+qTn9KxAHY1Q96izpjw9U3Cy5Wx1LoPSUUQmTyf67ZESknky8f3BkmtAEKN0uJR8lHq1ewQRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072069; c=relaxed/simple;
	bh=N9QGKnI7qJ/+H8ENuE0xuQG3ua3dLMjAraqgllTptkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNMnFjgoWKoDSwgf1QvaH/oQR5+8HOMF6jYdN01jf9uwoQUaSDgdc6jovcK78CmLe27pYMOvH6eu0Ns8U29UNEFBIklakjxJGL6jgMZGEJoLOj8pV3jg3MO+JHgQv8vAspQPzxcOzbJdYzoxW8gw8QH7kIwynL4JEyJG/HUX4h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSxpQjxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSxpQjxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7258CC4CEE7;
	Mon, 12 May 2025 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072068;
	bh=N9QGKnI7qJ/+H8ENuE0xuQG3ua3dLMjAraqgllTptkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSxpQjxcf3tmdj2KKzvF0UrQ7rP1ooBMqwMKwQY0heJ02r46YdnoQ3TLZbjI6odp/
	 MBa5Z8OtBSHaoB5Ak2n1bNGRswR5ivbyMg05ly7ZTABnPUrT2dz4Dmr/eoUVala0gZ
	 TFC1vgQtpfkdc7rILSWN6J0w5JYK5vtAZVFvRswU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 099/197] iio: light: opt3001: fix deadlock due to concurrent flag access
Date: Mon, 12 May 2025 19:39:09 +0200
Message-ID: <20250512172048.412763071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit f063a28002e3350088b4577c5640882bf4ea17ea upstream.

The threaded IRQ function in this driver is reading the flag twice: once to
lock a mutex and once to unlock it. Even though the code setting the flag
is designed to prevent it, there are subtle cases where the flag could be
true at the mutex_lock stage and false at the mutex_unlock stage. This
results in the mutex not being unlocked, resulting in a deadlock.

Fix it by making the opt3001_irq() code generally more robust, reading the
flag into a variable and using the variable value at both stages.

Fixes: 94a9b7b1809f ("iio: light: add support for TI's opt3001 light sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20250321-opt3001-irq-fix-v1-1-6c520d851562@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -788,8 +788,9 @@ static irqreturn_t opt3001_irq(int irq,
 	int ret;
 	bool wake_result_ready_queue = false;
 	enum iio_chan_type chan_type = opt->chip_info->chan_type;
+	bool ok_to_ignore_lock = opt->ok_to_ignore_lock;
 
-	if (!opt->ok_to_ignore_lock)
+	if (!ok_to_ignore_lock)
 		mutex_lock(&opt->lock);
 
 	ret = i2c_smbus_read_word_swapped(opt->client, OPT3001_CONFIGURATION);
@@ -826,7 +827,7 @@ static irqreturn_t opt3001_irq(int irq,
 	}
 
 out:
-	if (!opt->ok_to_ignore_lock)
+	if (!ok_to_ignore_lock)
 		mutex_unlock(&opt->lock);
 
 	if (wake_result_ready_queue)


