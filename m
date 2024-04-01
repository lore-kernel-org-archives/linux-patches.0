Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AFD43AD6;
	Mon,  1 Apr 2024 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987973; cv=none; b=eQA0pUeqPZm29K9sO3lbjDc0S+6vDK6i3SwN6X3JZfa9wToNGt2p7ydTcwwfapKr7umlvo493m8vQFr+Gvjg9lZNHenI5muuWymw4ATupXzYZPAbIgSrdpnFlIVNvAsMVubT6YEU0bXSJCBCXS9jnks95AkqvwH5YcJvNMxZkTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987973; c=relaxed/simple;
	bh=pd0doYUm0ss8NpcMD9ryOGegzPDfbwO/McN8uktLx5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8PqfL0pavDU9H1ouBvGkR5mzxOS0ahBZq656Zyza7pVQKicFTTps5ZPD0gG+8t7cIeZ6M+Gk4rfq8Ag78ySjm5rnNdBPNFaUXLTrDuqzvmlkQKQUBIjYspWohA1XEcr0Yy/K1j5Mtc1B+QOpCI4QO268v+dwuPWD5zbht1IQ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4AP2LWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4AP2LWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CCBC433C7;
	Mon,  1 Apr 2024 16:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987973;
	bh=pd0doYUm0ss8NpcMD9ryOGegzPDfbwO/McN8uktLx5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4AP2LWufKZmV+eeMOZbhk4BUM4ZPC96VZacK9L6Ineyk2nsH+E8onusgdLhiiluB
	 12Ne6pW7G1mdnCIgZws8SCyEfY7QuO/1Imt8OSM+A9W253xd8LGVcKrAqHT1KAjeOY
	 AUOCX1BklI+68GHidwclJ7I2/BHoDoTVh5Ddm/ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	sparclinux@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Nick Alcock <nick.alcock@oracle.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/432] sparc: vDSO: fix return value of __setup handler
Date: Mon,  1 Apr 2024 17:40:26 +0200
Message-ID: <20240401152554.297458585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5378f00c935bebb846b1fdb0e79cb76c137c56b5 ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from vdso_setup().

Fixes: 9a08862a5d2e ("vDSO for sparc")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nick Alcock <nick.alcock@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20240211052808.22635-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/vdso/vma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/vdso/vma.c b/arch/sparc/vdso/vma.c
index 136c78f28f8ba..1bbf4335de454 100644
--- a/arch/sparc/vdso/vma.c
+++ b/arch/sparc/vdso/vma.c
@@ -449,9 +449,8 @@ static __init int vdso_setup(char *s)
 	unsigned long val;
 
 	err = kstrtoul(s, 10, &val);
-	if (err)
-		return err;
-	vdso_enabled = val;
-	return 0;
+	if (!err)
+		vdso_enabled = val;
+	return 1;
 }
 __setup("vdso=", vdso_setup);
-- 
2.43.0



