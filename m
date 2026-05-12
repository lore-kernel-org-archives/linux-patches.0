Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28113EDE41;
	Tue, 12 May 2026 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608721; cv=none; b=eg+GVEjg1BKIyKMuumpXLFsKmQ6xCPsS9a05ZZ4lYNnWRjfvoVgCuO9gweoeAgRlXtKhKjgP0/tTSkdronZKwLSJ9V129Z/DPfDDU0J9kn5MdaSlQOTYa/zfjVkI6qAAZYXTeBXtl0iaZbTKJhTmuAr5V/1fQP4LG7UfM5OfLyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608721; c=relaxed/simple;
	bh=CEZB4kSHdDS6bZXZfyCjdAXQTHCjpf5q70hTwKBX4bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4HvJEwmRbbmtx2yGE1NpptsPHGQtpWKnpUFjEh5PtGuzBmV9axmwrZMMwLOrm0E9/4XWjJewwjrwzoXZUqQKYVP+k3CydPoZ7NVJLufvBJUXXPPp9Y2AG3rXWVzUFNnqIu7rGgdCX8Z/sNwFIPvDjQOgp89I0Dwwbu7xJIJfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDE0O9yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDE0O9yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38540C2BCB0;
	Tue, 12 May 2026 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608721;
	bh=CEZB4kSHdDS6bZXZfyCjdAXQTHCjpf5q70hTwKBX4bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDE0O9yiPLPcERlfpfUVYfBja3qtce4Eu+X3XiWjpydNeXHBfb4ZO63MPd8iJZs+9
	 Um6PsC89JHK3y+h+F8cEZ0ULpUMrPw1nPg6CuW7J/HEfpFkBTCh8HLLjHf4G00cone
	 43Ia3m/tj3zHJ8/JAbyEv7fSv0bUixcZZbUwkaEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 189/270] power: supply: max17042: avoid overflow when determining health
Date: Tue, 12 May 2026 19:39:50 +0200
Message-ID: <20260512173942.428390211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 9a44949da669708f19d29141e65b3ac774d08f5a upstream.

If vmax has the default value of INT_MAX (e.g. because not specified in
DT), battery health is reported as over-voltage. This is because adding
any value to vmax (the vmax tolerance in this case) causes it to wrap
around, making it negative and smaller than the measured battery
voltage.

Avoid that by using size_add().

Fixes: edd4ab055931 ("power: max17042_battery: add HEALTH and TEMP_* properties support")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260302-max77759-fg-v3-6-3c5f01dbda23@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -201,7 +201,7 @@ static int max17042_get_battery_health(s
 		goto out;
 	}
 
-	if (vbatt > chip->pdata->vmax + MAX17042_VMAX_TOLERANCE) {
+	if (vbatt > size_add(chip->pdata->vmax, MAX17042_VMAX_TOLERANCE)) {
 		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto out;
 	}


