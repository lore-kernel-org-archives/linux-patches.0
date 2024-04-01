Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9263E;
	Mon,  1 Apr 2024 16:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989399; cv=none; b=CnnpC6TBROytQqaboE3S/2WVT30s+RUx3VedbHsI8MrXcMt2yUtDerZxeaX9Hxg6RzHTLuAHYJ0+LFHAa9LzUxJ086aiYoRUHAV92HzmZ8yyY7PipH8M1SQtv6SeX15wuiD/zd98oaEIkwE8HfZZFGAfPSscGGZWulCT5zO784I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989399; c=relaxed/simple;
	bh=B2uayMs4qLSfQ7kshybldvOHbBlmdZK/j7k6/KE1Tgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pl4oMlzMJPIIsYvEqmU3mS0XpEAPfwCumLXtMhSdENizspCZjIcgudjYcPAxmIByAcsXI17kMkGDDV3MsY7XrMNtirXUW58OeL20k0nX4ss6HCzwgbUko75b1X5PUQedEA14T2shmITmMRalo6yrCE49OXE9EmbpGIcWLwxJ8oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSgc4xeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSgc4xeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30036C43390;
	Mon,  1 Apr 2024 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989398;
	bh=B2uayMs4qLSfQ7kshybldvOHbBlmdZK/j7k6/KE1Tgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSgc4xeoxYB5GPFU7HzwoeQJrxhFhdajawr73Mih71fuVx8sAfh9pJPdzTlMSNzXO
	 Yv4NG28h2moERF9prupqOJcmpBqfYmC8d1XmW5plFQmb59YH1UdcxX6OfaDuroV4Vz
	 62A8ciY4ftX6kHSBmDo2CyUPv4bm/tgfaKCtvQVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	sparclinux@vger.kernel.org,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/396] sparc64: NMI watchdog: fix return value of __setup handler
Date: Mon,  1 Apr 2024 17:41:26 +0200
Message-ID: <20240401152549.034439297@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3ed7c61e49d65dacb96db798c0ab6fcd55a1f20f ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from setup_nmi_watchdog().

Fixes: e5553a6d0442 ("sparc64: Implement NMI watchdog on capable cpus.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20240211052802.22612-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/nmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index 17cdfdbf1f3b7..149adc0947530 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -279,7 +279,7 @@ static int __init setup_nmi_watchdog(char *str)
 	if (!strncmp(str, "panic", 5))
 		panic_on_timeout = 1;
 
-	return 0;
+	return 1;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-- 
2.43.0



