Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446A13DDDD;
	Thu, 11 Apr 2024 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829525; cv=none; b=TZdQKToxF8OgQuyo6qU6lIrkqQnqa5YTcFGHovKlgKZy1weaA50X23AR0id5RMvMvhS7X3wKEajijI7nWekLxOK3x00cmdE9PJ5gq24FixqxTgzRCgEqBOpKzHcrkci0LNXXw+akTA6vmI0fP23ijyBbMwJzCF06+Dpw8GZkhGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829525; c=relaxed/simple;
	bh=s0JC/z39eKoY7OcvtWFVy51YccbLPOnSHxuMUUAj7dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im6+uLUz1GquhTrsH7+SwyjjXHyMV6hOUjbpC1oAUQLfkEbhOKlX4R/3K3QsNTK7ZXyjzFNNUFH5B6q0H+1H2RkpxJAfl9GAnH3xZLHrygP4fSuU++JSPQZTVvefGkj1cpHp603CR83+N4O1sjwrPWi6uFjxULuCW/CulhFT7QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6ndrwUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6ndrwUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93BFC433F1;
	Thu, 11 Apr 2024 09:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829525;
	bh=s0JC/z39eKoY7OcvtWFVy51YccbLPOnSHxuMUUAj7dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6ndrwUoQi/KU1oo9v3WwCmN4unLIHgw70Cvixhy4tm1+1UwQ6JchQ0C7oDXIEBdh
	 VaFhl0YkOvGIyszCtuxwM6S6u9Oy3fkZPafpqgGZO1MmKPlA0SOePMUtxWGMHnmZ+E
	 qZqrNxxUn11gzvTQ4Rv/H2g5Bil1u7yHdYI4iwhg=
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
Subject: [PATCH 4.19 017/175] sparc64: NMI watchdog: fix return value of __setup handler
Date: Thu, 11 Apr 2024 11:54:00 +0200
Message-ID: <20240411095420.065988249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8babbeb30adf9..1f356928a06d5 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -273,7 +273,7 @@ static int __init setup_nmi_watchdog(char *str)
 	if (!strncmp(str, "panic", 5))
 		panic_on_timeout = 1;
 
-	return 0;
+	return 1;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-- 
2.43.0



