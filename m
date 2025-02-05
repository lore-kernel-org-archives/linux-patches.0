Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9CE158218;
	Wed,  5 Feb 2025 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765748; cv=none; b=ovW/cSjDWmkuKivtaTQ1Kw4zo9sQUBxwqPM2cs1/fPJNQLm/N3NCJvlpTT1P8EBqin+vKcS1PtjgKvmKTEij7k9nqWm1lleWTlL4O7aYFWC0XmXORQh/7hjW/ImKAtuxsba5btY5hQoWGLriTodlsT5sOvDK+3qopZz+cNJsSKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765748; c=relaxed/simple;
	bh=9AK0X4JuGMsbDXY/EhfiZ+f6H8iVtZj1JjiVjFuu+Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCTwRV5Zu2+ZOEOXDNF09nlTA2gr/asiU7IXp5T6vx8o6SyCg7KbozuPVI7hXCCCD9TkRhTf55+P1nNNivrfqrTzD5EF/uorfyOrltDEiFRPv4qpZ4ePQY8UbAHgD/Cu0tP4ZB5jG0TnF+kjdxk/ajFgHSnoOVDJVwe9pT7ONhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlBwkqYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlBwkqYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3217C4CED1;
	Wed,  5 Feb 2025 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765748;
	bh=9AK0X4JuGMsbDXY/EhfiZ+f6H8iVtZj1JjiVjFuu+Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlBwkqYk/S3n6n8eGWbxRug8qWye7WukJW/Jv2wQxdIgpf2Ybe/EAA04Ou2ffgG/u
	 s6aONOrFtPJ96FL+Scc6edvYjXa+sz7QUy2twZLvZDP+QelE6gAr8XRqFDZaf8Bd7G
	 a+YwvVHP3INJDQG7nIq7236juDORZY1pgkhG06Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/393] watchdog: rti_wdt: Fix an OF node leak in rti_wdt_probe()
Date: Wed,  5 Feb 2025 14:43:34 +0100
Message-ID: <20250205134431.600372992@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 143981aa63f33d469a55a55fd9fb81cd90109672 ]

rti_wdt_probe() does not release the OF node reference obtained by
of_parse_phandle(). Add a of_node_put() call.

This was found by an experimental verification tool that I am
developing. Due to the lack of the actual device, no runtime test was
able to be performed.

Fixes: f20ca595ae23 ("watchdog:rit_wdt: Add support for WDIOF_CARDRESET")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250105111718.4184192-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 563d842014dfb..cc239251e1938 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -301,6 +301,7 @@ static int rti_wdt_probe(struct platform_device *pdev)
 	node = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
 	if (node) {
 		ret = of_address_to_resource(node, 0, &res);
+		of_node_put(node);
 		if (ret) {
 			dev_err(dev, "No memory address assigned to the region.\n");
 			goto err_iomap;
-- 
2.39.5



