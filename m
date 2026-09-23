Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE705372DD;
	Wed, 23 Sep 2026 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174001; cv=none; b=FXYx0q7ZXWb2/dsQEZ65JwkBjditZ9WKlj/zi7TdJM9CkRgNXT41vCgsC6iT/udOP+dAGDp4mKTNhl+i3847hs4IKESR2am224oIFXSbeXzP/KtrrGQ6WZHDfSLTBwDD3CSquckEo9zpd/67kdJUEzDWuPdrnYLmzl8BoX6Pwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174001; c=relaxed/simple;
	bh=+5ziXJAqG5Wj+hbFk6PNmWBqLI+g7qUz5noAl/qXxqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYt4407btsWLYezfQbr2WlpBkv68XxngAWQLYEqbjOTkb3W3q37iZagpFmZ651gVU6m/NcQsOLsjew7korPZdGhMNYMKYweoKfrZ0gQKvFq8925hI3Hgv2EneWE1+8jnGa97iJWzrKkLUxxdJJEuINV91sG9/KWW4YH0TTYo0yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2J1MT4l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2J1MT4l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA6C1F000FF;
	Wed, 23 Sep 2026 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174000;
	bh=qsFGQE2f8Blm5DPN2eG0fO6nF4E1+2paUNuiXW0YO5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2J1MT4l0q/fbermw0hqs4bh0kuHkJLw0sn051GZ+8Gq6ZIVAZYyeDNtLJ2NNrdbgp
	 mZUxnUiz+U2YEVV65jS9FrivrNLDUWRuuPSdLLtbn6VEdKP485kPXYS2+mUYXDjh3H
	 XqVSMSK+LTzBTOPLvpFTG7+oKHhhmfmx6rC9Lm1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 371/438] hwmon: (w83793) release probe data through kref
Date: Wed, 23 Sep 2026 16:06:32 +0200
Message-ID: <20260923140654.477631224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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


