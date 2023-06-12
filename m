Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEEB1106
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9506C433D2;
	Mon, 12 Jun 2023 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566346;
	bh=m0slSw/uErCfHzzh4ttbelI1hqwhLuCw/wfCw4tUQCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wo8iA3cNcFX1+iZflYkwh7y5V7woCHpGc233ALKH7hBeI9lxN3z+7gNXSFS1KECSA
	 jXO/BbhZBo6ZYvNpXi4tjZPCn+TZ+4gHEaTaoh2LYZ1TIZGT4/4y9bmGgAjeTvqObQ
	 LGrfSNxL/TdbF2WDMAPU8GjTBTZF7odO+L9cw920=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 89/91] Revert "debugobject: Ensure pool refill (again)"
Date: Mon, 12 Jun 2023 12:27:18 +0200
Message-ID: <20230612101705.832396370@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 503e554782c916aec553f790298564a530cf1778 which is
commit 0af462f19e635ad522f28981238334620881badc upstream.

Guenter reports problems with it, and it's not quite obvious why, so
revert it for now.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/debugobjects.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -590,16 +590,6 @@ static struct debug_obj *lookup_object_o
 	return NULL;
 }
 
-static void debug_objects_fill_pool(void)
-{
-	/*
-	 * On RT enabled kernels the pool refill must happen in preemptible
-	 * context:
-	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())
-		fill_pool();
-}
-
 static void
 __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack)
 {
@@ -608,7 +598,12 @@ __debug_object_init(void *addr, const st
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	debug_objects_fill_pool();
+	/*
+	 * On RT enabled kernels the pool refill must happen in preemptible
+	 * context:
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())
+		fill_pool();
 
 	db = get_bucket((unsigned long) addr);
 
@@ -693,8 +688,6 @@ int debug_object_activate(void *addr, co
 	if (!debug_objects_enabled)
 		return 0;
 
-	debug_objects_fill_pool();
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -904,8 +897,6 @@ void debug_object_assert_init(void *addr
 	if (!debug_objects_enabled)
 		return;
 
-	debug_objects_fill_pool();
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);


