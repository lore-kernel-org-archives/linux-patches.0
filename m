Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA094E5337;
	Thu, 17 Sep 2026 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666715; cv=none; b=fNmd71ONrI2vbck1DVcUv3MNlNtqr9M5U0T+Gj+y1eHm0SZn7kuLub7yvZgYj/1q+ZhM0t2W9qXWGGcadujAnBhQV/pgoAvxWYcN3eNkkpLgqXzNUu6Mqx8Y0KuVj3JD9Zz1ydhJ6Fj44l0RVl/G4ev3IQlajqrc+FbAeYUm5Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666715; c=relaxed/simple;
	bh=9CJzjikQRvxgEj4XIg9RxVF2suXULReL2uU/kd5JD1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Ri8WZgh9C92a+PstNajTsZ+0a8kqOgAu/S/G4VL1yLk+Ex0JAVEIj0hM2K+byi2JCur+6/JjPO0ib/k0DahSkDnpCPym/1B9ilYLfuLsU/aV0Ja9LnLvO+5uwjrbLVQjwvCbl/i20E7/1txAlGyI+rhl3yzqfFICngmn0p9yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YATxguxj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YATxguxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467E41F000FF;
	Thu, 17 Sep 2026 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666713;
	bh=IMZAqBlTiU6QCph91D57z60gt/JgsJNGdawhR5ySYgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YATxguxjM+ILKZu56i4ZQyWRjcxKPAzSopJP8Vq6CghFw1nYlm77GLj/dAsw7PS25
	 z/mFVNkQqqQcyEEfKwXSWt5mTnrMXPivdRPO5ifOYdNacBIhXojne9qSPzKcbbIdN4
	 a7OoKGwLh9N0Tn9AOukcqGMzlSFN4B8Ebq5VaQkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Zini <alessandro.zini@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1129/1250] hwmon: (sht4x) Add missing locks
Date: Thu, 17 Sep 2026 16:15:24 +0100
Message-ID: <20260917151622.852976394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 06b7cf395b1fb652a50db39674a759658fbfba0d upstream.

Sashiko reports:

Heater sysfs callbacks (heater_enable_store, heater_power_store, and
heater_time_store) are exposed to data races without the hwmon lock.

If a user-space process reads hwmon data while another process enables
the heater, heater_enable_store() executes without holding
hwmon_lock(dev). This can interleave I2C commands and mutate shared
state (data->heating_complete and data->data_pending) concurrently
with sht4x_read_values(), leading to corrupted I2C sequences.

Fixes: 53dfa12299c1 ("hwmon: (sht4x) Rely on subsystem locking")
Cc: Alessandro Zini <alessandro.zini@siemens.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20260821144916.2889031-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/sht4x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -277,6 +277,8 @@ static ssize_t heater_enable_store(struc
 		heating_time_bound = 1100;
 	}
 
+	guard(hwmon_lock)(dev);
+
 	if (time_before(jiffies, data->heating_complete))
 		return -EBUSY;
 
@@ -314,6 +316,8 @@ static ssize_t heater_power_store(struct
 	if (power != 20 && power != 110 && power != 200)
 		return -EINVAL;
 
+	guard(hwmon_lock)(dev);
+
 	data->heater_power = power;
 
 	return count;
@@ -344,6 +348,8 @@ static ssize_t heater_time_store(struct
 	if (time != 100 && time != 1000)
 		return -EINVAL;
 
+	guard(hwmon_lock)(dev);
+
 	data->heater_time = time;
 
 	return count;


