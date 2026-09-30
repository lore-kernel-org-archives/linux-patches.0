Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB19E4A8430;
	Wed, 30 Sep 2026 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788802; cv=none; b=tfJWEJSHJkAoDqnmeIwmI+B1/1fazpeQRsxqtJhXUOxZ9FCzGQazLSFfAv7q6w/1hqCAr6I9JxVQRp7t9/a5Wzqe3u0PDEOTiPesEnez1bS35ih2HomTfkGSPqgsQ44KKM9vg7S5uXTXtBYfjuwsd475y0fSx/UL/IQ0EJS4R9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788802; c=relaxed/simple;
	bh=/gVezxDJ7vsjCht1mVZORE88m3iKEwzuk6QUW4PPtSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nddeU69SHleMcfNcmDNxp5xWbzBWuHuqoUrhydd3gwbeXhQvLfoQUyjmsyngAqMAQKh9715rXEQ8lYcJl2ycDNZ/0ajZsVEN9rd8wj+8mDb8oWNN67elCum6e8X0xGvXVoyBrekjyHNwiP2+dPvBuJ5D+McICJ8/5u+Kz99fb4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7XKL5z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7XKL5z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0981F000FF;
	Wed, 30 Sep 2026 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788801;
	bh=fIsm6eiv0eefmByqErgbmyzqpeBWAqFHSLRtaSuL/AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7XKL5z8hTxcaufNTZQVhDUQ187OeXMEyg4k5gECWbqwDXeJA344f++8NzOK93q8N
	 B5Q7x9SMVGOmKfWSPsInahFpDu1oNlJePhN2GgIDrxYnX4MiDQEJFGt2iU/wi13e5a
	 RF3rz/xlCsP9y7QefRtmsqG+ul48/wXBfZULOiEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 251/877] hwmon: (w83793) release probe data through kref
Date: Wed, 30 Sep 2026 17:19:22 +0200
Message-ID: <20260930152420.137732583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1928,7 +1928,9 @@ exit_remove:
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


