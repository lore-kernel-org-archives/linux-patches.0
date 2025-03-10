Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C5222576A;
	Mon, 10 Mar 2025 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630935; cv=none; b=bIl1L8I6tWl9l6oLYP/Bo/tEYDwD3f0nYKbvJE43g8ByJFn4s0QSdg9gsYiyToh8c2uQC0NiSkEEuZWhUrTbkFl4xfbMNPgmbVFiS4+u2kkOFDKu844lL0C0LVXp7/ChBXRvVXuRsrfduccNCQMSIXTTGpSesJEPsj2T0DDX0sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630935; c=relaxed/simple;
	bh=2mmOC3S8YEUIcFYcmdfyTC0HFO2ikpUTQhAC/jtjvS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaUfyOqCxQl9+qnKDmkJ3Mu4V+LUiMG6N1OhR7i8RrhKv2aWXcGE5NPj2du5sIaSVmjurbcXmnHGLJsBbFe4LlDic9wGkeVYttzyTKlPJU/ahNU6cMYNb7Y5vEVRukQwYhRyZ2IQ58YuR6osgQlXQf+RJPD7A9s+SYE3JlLN3+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq6qPJvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq6qPJvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D447C4CEE5;
	Mon, 10 Mar 2025 18:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630935;
	bh=2mmOC3S8YEUIcFYcmdfyTC0HFO2ikpUTQhAC/jtjvS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq6qPJvRxriW7DNbBhF2q+GXvtd0kZjcNaVIBqoydMVRSoFaqTRkA6CRIkDJDNQer
	 rY0YaDi1sNrClD7fef9DdaJ9/EIvsntXvkm+bHZBe+FyxLi5rA6MNqON/ZJBqfYXeq
	 d+yBySwIXpktS2SSoSMUxBxp9khq8ech/WiCjpoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titus Rwantare <titusr@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 558/620] hwmon: (pmbus) Initialise page count in pmbus_identify()
Date: Mon, 10 Mar 2025 18:06:44 +0100
Message-ID: <20250310170607.571075058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Titus Rwantare <titusr@google.com>

[ Upstream commit 6b6e2e8fd0de3fa7c6f4f8fe6841b01770b2e7bc ]

The `pmbus_identify()` function fails to correctly determine the number
of supported pages on PMBus devices. This occurs because `info->pages`
is implicitly zero-initialised, and `pmbus_set_page()` does not perform
writes to the page register if `info->pages` is not yet initialised.
Without this patch, `info->pages` is always set to the maximum after
scanning.

This patch initialises `info->pages` to `PMBUS_PAGES` before the probing
loop, enabling `pmbus_set_page()` writes to make it out onto the bus
correctly identifying the number of pages. `PMBUS_PAGES` seemed like a
reasonable non-zero number because that's the current result of the
identification process.

Testing was done with a PMBus device in QEMU.

Signed-off-by: Titus Rwantare <titusr@google.com>
Fixes: 442aba78728e7 ("hwmon: PMBus device driver")
Link: https://lore.kernel.org/r/20250227222455.2583468-1-titusr@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index d0d386990af5e..6366610a90827 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -103,6 +103,8 @@ static int pmbus_identify(struct i2c_client *client,
 		if (pmbus_check_byte_register(client, 0, PMBUS_PAGE)) {
 			int page;
 
+			info->pages = PMBUS_PAGES;
+
 			for (page = 1; page < PMBUS_PAGES; page++) {
 				if (pmbus_set_page(client, page, 0xff) < 0)
 					break;
-- 
2.39.5



