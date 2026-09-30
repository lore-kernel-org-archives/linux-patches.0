Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801AD314A86;
	Wed, 30 Sep 2026 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788805; cv=none; b=d8m4pcsLBSqUdcCJRqJQkp8KebX2JbCh2o4mbwJ2jzRxKfEOL3zxx8QHrZ01eo1D9M4L9ZWN4JZ3mqNSzK2yCQQyO+ewZ0tRqu+pn86zuslAAxospyZV7U/4xq3/5U7fOqqMAvXLySxfq6mDZ6c/a+6THHCQuqA71Jdwx+WvYvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788805; c=relaxed/simple;
	bh=x2IPiA2EIlB72U36PK0WXuMdCBHQmG3AnxN2ssxmHMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdYZ90in8Zka73IEajcgJd+0oDkmmbgaDZ1ZIVa10sLTBj+C9R1KegyO/xlpNZULS8Lx6OHzf8llpyq9C6jXU0Bhx38D1ALTFINrwbjNguLSOej2OVtHWLsdDVVeTkxeAPnLgprV4du+vtGDbidahe23wG5ikDKk0lAMN4bs4W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3qkXZcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3qkXZcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAAC1F000FF;
	Wed, 30 Sep 2026 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788804;
	bh=uMeYj1Km/Puz/vUZ8m5O0GbcFXjzKRt/0ciSi3mOpmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3qkXZcp4Bk3QYCysIznO15UtfT3ZLoNp6Iv4+uHV/0IpTyTpiSk+0fkQbZPklu8w
	 gRimn7z0GDYqzMTZ0EPA2Gm2iabW9Uk1x99YoNItXyK2pytGUUzug6xgcHEIj5u7zl
	 uExqu8S02wkMos8hSqRuPiw9teC07rZ+sHE7k0P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 252/877] watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 30 Sep 2026 17:19:23 +0200
Message-ID: <20260930152420.159364493@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

commit 7cb575b71ab98194d2e040bded3a7281e089c5ed upstream.

da9063_wdt_suspend() and da9063_wdt_resume() only check watchdog_active(),
when the watchdog is left running by the driver sets
WDOG_HW_RUNNING in da9063_wdt_probe() but userspace never opens the
device, so WDOG_ACTIVE remains cleared, the wdt_disable() will not be
executed in da9063_wdt_suspend. In this case, the suspend callback is
a no-op and the watchdog keeps counting during system suspend,
leading to an unexpected system reset.
Check WDOG_HW_RUNNING and wdd，can fix this issue.

Fixes: a7ceca4398bc8 ("watchdog: da9063: optionally disable watchdog during suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://patch.msgid.link/20260917013710.2754679-1-lijun01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/da9063_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/da9063_wdt.c
+++ b/drivers/watchdog/da9063_wdt.c
@@ -271,7 +271,7 @@ static int __maybe_unused da9063_wdt_sus
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_stop(wdd);
 
 	return 0;
@@ -284,7 +284,7 @@ static int __maybe_unused da9063_wdt_res
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_start(wdd);
 
 	return 0;


