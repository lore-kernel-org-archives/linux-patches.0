Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85074E325B;
	Thu, 17 Sep 2026 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659786; cv=none; b=odxytOj6QnxK12534eQuOEqNNuLC3qGZj/jv1psHi0a8+Qdi2oTspNhq5RWGflrsH62M7LabTyFP/QayjQDFYJOt7ziS/kYrASsgTxP8ZTKvn77MJZJYvIg7PW8HDYDPI2ZB4Mf4M/iBh7/mxAkDxta1zl3PQ9qkhA35S9DIwyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659786; c=relaxed/simple;
	bh=5kM4Guwx2xCnsBFTMpmdjgxFw5SlT4yCkQGyIP/Ife4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxqCOtuZWWmN84cQEQhhZab0/jVLGtzUaoqeGzNtj0tXED83kpcOMFftQzoGmRPGYbwElRr9z1+ORGjDBirIlUUp17XtZIgY6lGDuGsD7oXSTpxQ2q+btcm8RGwcXO205IxIqVNKhGBu9B92+3/A4CTPBFCdTUZB01Pe/Uw7v9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3YAQXzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3YAQXzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0081F00898;
	Thu, 17 Sep 2026 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659776;
	bh=JT99ICHWqGgNEfmdU8RZYYbzuvGTd6GFWRLrnK1q1+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3YAQXzqneHDuK343E09yuISIVCaIpjNYrlZvGjuf2tg/aHT+IywBE+xYetm5zxHF
	 IRaLwLY4i/1s8KbU0AOXRDJq9lLO3RXkvjtNGC5SVbKu7zVOhPN8SoDmmhPGQAWHhd
	 0uc8XVBoJpAWNhvuc0zSg2rs4bpyUJOdLl6Sflno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alessandro Zini <alessandro.zini@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 332/733] hwmon: (sht4x) Fix return value from heater_enable_store()
Date: Thu, 17 Sep 2026 16:10:40 +0100
Message-ID: <20260917151359.801676816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7a0dc2ed723d8..a97dda9e92dc5 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -288,7 +288,7 @@ static ssize_t heater_enable_store(struct device *dev,
 
 	data->heating_complete = jiffies + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
-	return 0;
+	return count;
 }
 
 static ssize_t heater_power_show(struct device *dev,
-- 
2.53.0



