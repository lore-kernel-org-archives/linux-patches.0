Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197171ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CD6C433C9;
	Tue, 25 Jul 2023 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284293;
	bh=AHAfLPUTCUUHRsnA2xM2PyG6fmI/bjg4m342f+s8WGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJyOMEdMhEnEhmgnnoOA8m8zxI9xr4nv0Ote359vI/LIHat1GpLeLulp1xrkXkNyl
	 Nx0zdDzApR/EtEztV6Z33367q1UkO2rCu2L3QgIWw5epqYggRYjPxE/lib9lNjzJCP
	 JyENQoA6RY4IjpVI8tRu4M4BSYV0PGfWYVb+Voas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 304/509] ARM: orion5x: fix d2net gpio initialization
Date: Tue, 25 Jul 2023 12:44:03 +0200
Message-ID: <20230725104607.662611986@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit f8ef1233939495c405a9faa4bd1ae7d3f581bae4 upstream.

The DT version of this board has a custom file with the gpio
device. However, it does nothing because the d2net_init()
has no caller or prototype:

arch/arm/mach-orion5x/board-d2net.c:101:13: error: no previous prototype for 'd2net_init'

Call it from the board-dt file as intended.

Fixes: 94b0bd366e36 ("ARM: orion5x: convert d2net to Device Tree")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230516153109.514251-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-orion5x/board-dt.c |    3 +++
 arch/arm/mach-orion5x/common.h   |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/arch/arm/mach-orion5x/board-dt.c
+++ b/arch/arm/mach-orion5x/board-dt.c
@@ -63,6 +63,9 @@ static void __init orion5x_dt_init(void)
 	if (of_machine_is_compatible("maxtor,shared-storage-2"))
 		mss2_init();
 
+	if (of_machine_is_compatible("lacie,d2-network"))
+		d2net_init();
+
 	of_platform_default_populate(NULL, orion5x_auxdata_lookup, NULL);
 }
 
--- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -75,6 +75,12 @@ extern void mss2_init(void);
 static inline void mss2_init(void) {}
 #endif
 
+#ifdef CONFIG_MACH_D2NET_DT
+void d2net_init(void);
+#else
+static inline void d2net_init(void) {}
+#endif
+
 /*****************************************************************************
  * Helpers to access Orion registers
  ****************************************************************************/


