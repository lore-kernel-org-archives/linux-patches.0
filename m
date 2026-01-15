Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D50D86334;
	Thu, 15 Jan 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497481; cv=none; b=oUdwACyBOLr5hBCbJEtQJ5EFSwV60JFGhlPVpIwiSSYDt/KJOJxFMixd1MhUOMHJp8HrfcAV6FhRvkDxigK2KMqVlxOG8ODepICkCw3fJGjaKPb9JDrEVDFpCgVO835F0ACRPWgdAEwtLNgs8ZV3OrSKKqfHIS5z3mkkDj9Muzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497481; c=relaxed/simple;
	bh=8W9jjKWvj0rHZDj3KvjjitooOflyptOnwwOkFIuBXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6sv1BaZwrS2vvjFIclBnVXMr0GinxWtvGUhaA8VIo7hOgkgMnkdG4v46w5cZ3xbyMZgSTMPxa8a0ZZkgLiG1l8/0HccphZn3ymoikc5aE/Zd6iJLh9P3GNLZU2skTS1IC77tBq3Q+jSi9SsE6CyeLe0k1PeYpbgC7qmxczJcCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4ZBVS5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4ZBVS5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE5C116D0;
	Thu, 15 Jan 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497481;
	bh=8W9jjKWvj0rHZDj3KvjjitooOflyptOnwwOkFIuBXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4ZBVS5KlUxYVHDB5BhxoW3SX50zVuAeBqirSB/mT5Q2Up+TdnPhj5pZIbruZ5BWV
	 BmKtcAEkinTmA7aPFNK7VrudWFqJGyXzhitg9c9NwZdwZg5tLHOUnjbZc8tqL9rFQ4
	 +O1ig8MAmFB8/LfXCwRCr9yHNynymRz6XamReou0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/554] i3c: Allow OF-alias-based persistent bus numbering
Date: Thu, 15 Jan 2026 17:42:10 +0100
Message-ID: <20260115164248.561194846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 7dc2e0a875645a79f5c1c063019397e8e94008f5 ]

Parse the /aliases node to assign any fixed bus numbers, as is done with
the i2c subsystem. Numbering for non-aliased busses will start after the
highest fixed bus number.

This allows an alias node such as:

    aliases {
        i3c0 = &bus_a,
	i3c4 = &bus_b,
    };

to set the numbering for a set of i3c controllers:

    /* fixed-numbered bus, assigned "i3c-0" */
    bus_a: i3c-master {
    };

    /* another fixed-numbered bus, assigned "i3c-4" */
    bus_b: i3c-master {
    };

    /* dynamic-numbered bus, likely assigned "i3c-5" */
    bus_c: i3c-master {
    };

If no i3c device aliases are present, the numbering will stay as-is,
starting from 0.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20230405094149.1513209-1-jk@codeconstruct.com.au
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index ae60eb7b27601..209aa1e889044 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -21,6 +21,7 @@
 
 static DEFINE_IDR(i3c_bus_idr);
 static DEFINE_MUTEX(i3c_core_lock);
+static int __i3c_first_dynamic_bus_num;
 
 /**
  * i3c_bus_maintenance_lock - Lock the bus for a maintenance operation
@@ -420,9 +421,9 @@ static void i3c_bus_cleanup(struct i3c_bus *i3cbus)
 	mutex_unlock(&i3c_core_lock);
 }
 
-static int i3c_bus_init(struct i3c_bus *i3cbus)
+static int i3c_bus_init(struct i3c_bus *i3cbus, struct device_node *np)
 {
-	int ret;
+	int ret, start, end, id = -1;
 
 	init_rwsem(&i3cbus->lock);
 	INIT_LIST_HEAD(&i3cbus->devs.i2c);
@@ -430,8 +431,19 @@ static int i3c_bus_init(struct i3c_bus *i3cbus)
 	i3c_bus_init_addrslots(i3cbus);
 	i3cbus->mode = I3C_BUS_MODE_PURE;
 
+	if (np)
+		id = of_alias_get_id(np, "i3c");
+
 	mutex_lock(&i3c_core_lock);
-	ret = idr_alloc(&i3c_bus_idr, i3cbus, 0, 0, GFP_KERNEL);
+	if (id >= 0) {
+		start = id;
+		end = start + 1;
+	} else {
+		start = __i3c_first_dynamic_bus_num;
+		end = 0;
+	}
+
+	ret = idr_alloc(&i3c_bus_idr, i3cbus, start, end, GFP_KERNEL);
 	mutex_unlock(&i3c_core_lock);
 
 	if (ret < 0)
@@ -2607,7 +2619,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i2c);
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
-	ret = i3c_bus_init(i3cbus);
+	ret = i3c_bus_init(i3cbus, master->dev.of_node);
 	if (ret)
 		return ret;
 
@@ -2816,8 +2828,16 @@ void i3c_dev_free_ibi_locked(struct i3c_dev_desc *dev)
 
 static int __init i3c_init(void)
 {
-	int res = bus_register_notifier(&i2c_bus_type, &i2cdev_notifier);
+	int res;
+
+	res = of_alias_get_highest_id("i3c");
+	if (res >= 0) {
+		mutex_lock(&i3c_core_lock);
+		__i3c_first_dynamic_bus_num = res + 1;
+		mutex_unlock(&i3c_core_lock);
+	}
 
+	res = bus_register_notifier(&i2c_bus_type, &i2cdev_notifier);
 	if (res)
 		return res;
 
-- 
2.51.0



