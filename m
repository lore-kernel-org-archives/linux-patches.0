Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8423B2F32
	for <patches@lists.linux.dev>; Mon,  2 May 2022 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rfl/E6TxnQgqrMM/nRVAVQuV3SFjaQY1vwgookprjZM=; b=stD+MqO5Rf6x4YAd9OOtcdmkEj
	IERFkEAalR763FJGBtvI0nnwSk9vr/7qEI6NbOJtSS7ycMRUZ/O721TsNH5UZhsAMbZFgkfLGhSh8
	mnci2QjMDDJ/lECwkXd9ToCWPVxC4B8Pf4oi/SnjJJf36/NpL2XbJhmKwY7bmKNqJfrh7kVnY/t8H
	ndagJPxmOjzMZbzr14yZCUQbY/MM/wP+gweOua0GROSjQEG9oRZsnnY9ny7DMYoJo+w8Zma8db+WI
	pCx/G+LLkZcLVsIKb/JnuJG8FGwO71HtoeIgXhf34oOBQ0B+pojP2QmCcw0CewkuknfVSBxQxDyoo
	n0SzaPsQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nlbjc-002Oqk-89; Mon, 02 May 2022 19:29:28 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2] POWERPC: idle: fix return value of __setup handler
Date: Mon,  2 May 2022 12:29:25 -0700
Message-Id: <20220502192925.19954-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from powersave_off().

Fixes: 302eca184fb8 ("[POWERPC] cell: use ppc_md->power_save instead of cbe_idle_loop")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
v2: change From: Igor to Reported-by: Igor
    update Igor's email address

 arch/powerpc/kernel/idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -37,7 +37,7 @@ static int __init powersave_off(char *ar
 {
 	ppc_md.power_save = NULL;
 	cpuidle_disable = IDLE_POWERSAVE_OFF;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", powersave_off);
 
