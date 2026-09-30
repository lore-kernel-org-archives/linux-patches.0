Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A080F51123D;
	Wed, 30 Sep 2026 16:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786130; cv=none; b=Bzx1FcIiMZrphunU/Skaak9qLsO+OTBlbSuQYFuzVJimvGNepih/TT/cEQ0MBBCTK3lTIU0tdjggbf+ld98EEBbvGM25SYUtT9Ww9OiLdUIOYrEXszOTRfEYjrLoqBVIuoyxn3RtRhAoXy6y5eYGY1Fd80ReReYKUEl8MqQdCLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786130; c=relaxed/simple;
	bh=z+KqBvBzwRGB3JOgKWMfoWZYjfYzubwQl2qYGTfL5OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osDzU3hAKzoyxzeTzkYxWfYS6TEU/wClSJSfOFLaGLTFfuWzVrEMikq9cTzAq5FE8lRYgxuE94OjMS+dghTc1Vg0Sqwsb+SXBqG0fAre5wxp29U/yoxDRFWf4q/waApZ1DUVwApYe3s+Is8DD143gc4NnBgs4MYxZl9x8AqJNnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLFLPFYj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLFLPFYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F301F000FF;
	Wed, 30 Sep 2026 16:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786129;
	bh=htII3v0M8PwTKYGl9dkjE7+4vaMP7Yf0OGSYpPJDMtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLFLPFYjY/ihMAsBYf6p1Pv0JDWAdOc2jp+xtm/y3OiQWVeA4RClMqs6OBtSd9JZx
	 YGSMnv1Jph5bakUFRPGLtdSEFHzYIWBxCTT8eoCw5suW0d+qyfsTtfSSsT4lXKN7vZ
	 sHCiyUtfZTt+7ckkNJ021QYjS1jpqfwRzZyorD9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 753/982] hwmon: (w83793) release probe data through kref
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152432.926694095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c702a5f18b780e477eccbbab558e590e9673e4cb upstream.

w83793_probe() initializes data->kref to manage the lifetime of the
driver data. The normal remove path drops the driver-owned reference
with kref_put(), while watchdog users take and release additional
references through the same kref.

However, the probe error path still frees data directly with kfree().
This bypasses the kref-managed lifetime and discards the initial
reference without a matching kref_put(), leaving the reference
accounting unbalanced.

Drop the probe-owned reference with kref_put() instead and let
w83793_release_resources() perform the final free, matching the normal
remove path.

This issue was found by manual code inspection.

Fixes: 5852f9609d21 ("hwmon: (w83793) Add watchdog functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260914073638.1662500-1-lgs201920130244@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1929,7 +1929,9 @@ exit_remove:
 	for (i = 0; i < ARRAY_SIZE(w83793_temp); i++)
 		device_remove_file(dev, &w83793_temp[i].dev_attr);
 free_mem:
-	kfree(data);
+	mutex_lock(&watchdog_data_mutex);
+	kref_put(&data->kref, w83793_release_resources);
+	mutex_unlock(&watchdog_data_mutex);
 exit:
 	return err;
 }


