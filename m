Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E3397E80;
	Tue, 21 Jul 2026 20:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666034; cv=none; b=QiU/i+yFhRoV+ochEFzeU0E6mSX1vKAvuRL5kesgHbzAUOlToYXkNCJco8y9Syy7R2dTwsYvjITfbrs/GhyFrmNKy/jWjfuuxmVz9TCN8r92t09/GoNofYR6rh5ZqYa87Itny07sw0cAY26PH2BTjG2BPauVO9p9pKaubv0mBCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666034; c=relaxed/simple;
	bh=DLTXYO8DvQBAIlFJzxC3wphqIv81FD8GKQnsrariw/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgBOwsXcpbvezJYoyEHitjYOkXS/XGXwBawnwJTt0oQz1hU9JFnIgj1nyhE6RF6u3wS0yq8GaDPlznrl+7CyN3lmHgVOg/mB8wlTwCYH8tE/P7c0jmGA6hva1Nr6GxdKVv+/FSw7lt7nfenMA/2w2ZTuAfqP+KWH8NrammTwb/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zwq3JkJo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zwq3JkJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A9A1F000E9;
	Tue, 21 Jul 2026 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666032;
	bh=0IgyXdhhrJvuYDaOYggSi6/ThsGaFOznYTAxLBYWzos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zwq3JkJoWLAUdsWChf1iEGpiqVRx0jb5g1uwUaCA+o+JP9DVp/BxRIhGZLsRGXwOr
	 MCMYXUVCwXWrTep4R1Or0C+xG4RZQoCC0Clhaj5liyBYCNurAmhsQPk3xf0zv6cN9o
	 HCZATqv5uVfL3W1JrjjQE6CINKh9wFAmXvkWtPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0529/1266] hwmon: (it87) Clamp negative values to zero in set_fan()
Date: Tue, 21 Jul 2026 17:16:06 +0200
Message-ID: <20260721152453.693852700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 7f8581c70a3bd50a932d3d2d253e99c5ec3eda74 ]

set_fan() parses user input with kstrtol() and passes the resulting
value to FAN16_TO_REG() on chips with 16-bit fan support.

Negative fan speeds are not meaningful and should be rejected before
conversion. Worst scenario, one may be able to abuse undefined
behaviour of signed overflow to possibly induce rpm * 2 == 0 in
FAN16_TO_REG(), thus causing a division by zero.

Instead, clamp val < 0 to zero and keep the conversion in its valid
input domain, avoiding unsafe arithmetic in the register conversion
path.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 17d648bf5786 ("it87: Add support for the IT8716F")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20260529141839.1639287-1-n.zhandarovich@fintech.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 51882f7386cc81..716afea0db2400 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1400,6 +1400,9 @@ static ssize_t set_fan(struct device *dev, struct device_attribute *attr,
 	if (kstrtol(buf, 10, &val) < 0)
 		return -EINVAL;
 
+	if (val < 0)
+		val = 0;
+
 	err = it87_lock(data);
 	if (err)
 		return err;
-- 
2.53.0



