Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6535208DE;
	Thu, 17 Sep 2026 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665867; cv=none; b=aXoS8ec/RBPEXKy58qpwMvTb1t3WYRyuZ6gHh2qcVk5F41Ho97CJX7lUFxN9rhQlzQOoQvgxX8o8u6hIs7DUPuKR94rLrZXYdW/H0YCDZHZVIEC63vcVoyrAMNYexdvRHxpVlH89Ku511hucHS9JSb+39t2u87UGolGgit9minw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665867; c=relaxed/simple;
	bh=FAEn5thy9qao8KBmJWUhVsBmO7HW/e2DQGqIpuuHoPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPFAJfVtAu6K02yr2IytmStr+Un0pC4OjBJWNGv5YVe5/HEqjnyuYtPfkEB58j4XNhQB0pJxstt23tztgStf/dA/nDeuKxa3KpJ/X16oZSuvy48mm7Yb6Wc3um3s6LjkrxPZ6dHTj0twBSd+U88K+KwTqaDbBaClMUG+KFju1k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9VsqOSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9VsqOSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5851F000FF;
	Thu, 17 Sep 2026 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665866;
	bh=UfJ49T3LjoPJzCCrFCbMObRWqeyOKfOaag6CyTD/CbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9VsqOSR0Zy7rZ4zf9MJO0y27kcLwiUwsTjqiHX77BBZxTg1ALq2LVlEOn0+59z9f
	 7VioWR8D+S9yS+mq4y6lyKOjkhs3tLn5/lqQ0bTzqftfulzUO+fWPpIGXawbs2Vsu7
	 ueAxXZAqIS0EpeGHUb4D91mgwra8KrpkVj1ea2ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alessandro Zini <alessandro.zini@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0845/1250] hwmon: (sht4x) Fix return value from heater_enable_store()
Date: Thu, 17 Sep 2026 16:10:40 +0100
Message-ID: <20260917151614.863261261@linuxfoundation.org>
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

[ Upstream commit 70c33e211b2b78830f76c908e5236b77ffde63a0 ]

Sashiko reports:

The return value in heater_enable_store() causes an unexpected write
failure in user-space.

When the heater is successfully enabled, the function returns 0
instead of count:

drivers/hwmon/sht4x.c:heater_enable_store() {
    ...
    data->heating_complete = jiffies + msecs_to_jiffies(heating_time_bound);
    data->data_pending = true;
    return 0;
}

Returning 0 signals to VFS that no bytes were processed. Standard
user-space tools will retry the write with the remaining bytes. On the
retry, time_before(jiffies, data->heating_complete) evaluates to true,
and the function immediately fails with -EBUSY.

Return count as expected to fix the problem.

Fixes: 0eed6fc3d2b9e ("hwmon: (sht4x): add heater support")
Cc: Antoni Pokusinski <apokusinski01@gmail.com>
Cc: Alessandro Zini <alessandro.zini@siemens.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20260821144916.2889031-2-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 5abe1227e109e..cab25048dd55f 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -286,7 +286,7 @@ static ssize_t heater_enable_store(struct device *dev,
 
 	data->heating_complete = jiffies + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
-	return 0;
+	return count;
 }
 
 static ssize_t heater_power_show(struct device *dev,
-- 
2.53.0



