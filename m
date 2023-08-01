Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E21FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D660BC433C9;
	Tue,  1 Aug 2023 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883296;
	bh=6sQomdi6eHwR4kmmWt3b2KK9Mk7q06ATA9b9I1ITEKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrF+5McvPp7Uq2rACXo06KZ14XQuK6vBKEdLZ2DOhqyHsWfJpALEBSn3lbVtePJV5
	 Y6Vp/aQxQDtSYjdX8doNZokxwxS6IjLo4FN6Ae97uzicULyiJGbPrSTVqSvOQIJABQ
	 05I9cq4mYEw/OJP7E6HK34fAWMHm7D59kSvcfJ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Naresh Solanki <Naresh.Solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.4 184/239] hwmon: (pmbus_core) Fix Deadlock in pmbus_regulator_get_status
Date: Tue,  1 Aug 2023 11:20:48 +0200
Message-ID: <20230801091932.309430238@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

commit b84000f2274520f73ac9dc59fd9403260b61c4e7 upstream.

pmbus_regulator_get_status() acquires update_lock.
pmbus_regulator_get_error_flags() acquires it again, resulting in an
immediate deadlock.

Call _pmbus_get_flags() from pmbus_regulator_get_status() directly
to avoid the problem.

Reported-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Closes: https://lore.kernel.org/linux-hwmon/b7a3ad85-aab4-4718-a001-1d8b1c0eef36@roeck-us.net/T/#u
Cc: Naresh Solanki <Naresh.Solanki@9elements.com>
Cc: stable@vger.kernel.org # v6.2+
Fixes: c05f477c4ba3 ("hwmon: (pmbus/core) Implement regulator get_status")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2946,6 +2946,7 @@ static int pmbus_regulator_get_status(st
 	struct pmbus_data *data = i2c_get_clientdata(client);
 	u8 page = rdev_get_id(rdev);
 	int status, ret;
+	int event;
 
 	mutex_lock(&data->update_lock);
 	status = pmbus_get_status(client, page, PMBUS_STATUS_WORD);
@@ -2965,7 +2966,7 @@ static int pmbus_regulator_get_status(st
 		goto unlock;
 	}
 
-	ret = pmbus_regulator_get_error_flags(rdev, &status);
+	ret = _pmbus_get_flags(data, rdev_get_id(rdev), &status, &event, false);
 	if (ret)
 		goto unlock;
 


