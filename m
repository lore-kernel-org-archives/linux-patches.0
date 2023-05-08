Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928C168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2505C4339B;
	Mon,  8 May 2023 10:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543173;
	bh=CjKytRevELX7kf3IJ2TCy9akXHAjAiVJumBW8p7gxpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/Em9jlEYMTGdlGWI9O9icNoGkbDkvn/kEMiHZtjXu8TNKLEFeyF5iexkcXt9rOul
	 jTJi5njoxS5/f+Hzh/mY6E9gOYRbRgeykxqkY6IbnJG3hNT+Y9e6F0SG34/wSHmrON
	 ss+oeXrKoUN5oWESboeimQk6dvrii5Mwe1AC8k0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.2 663/663] debugobject: Ensure pool refill (again)
Date: Mon,  8 May 2023 11:48:09 +0200
Message-Id: <20230508094451.747616835@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit 0af462f19e635ad522f28981238334620881badc upstream.

The recent fix to ensure atomicity of lookup and allocation inadvertently
broke the pool refill mechanism.

Prior to that change debug_objects_activate() and debug_objecs_assert_init()
invoked debug_objecs_init() to set up the tracking object for statically
initialized objects. That's not longer the case and debug_objecs_init() is
now the only place which does pool refills.

Depending on the number of statically initialized objects this can be
enough to actually deplete the pool, which was observed by Ido via a
debugobjects OOM warning.

Restore the old behaviour by adding explicit refill opportunities to
debug_objects_activate() and debug_objecs_assert_init().

Fixes: 63a759694eed ("debugobject: Prevent init race with static objects")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/871qk05a9d.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/debugobjects.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -587,6 +587,16 @@ static struct debug_obj *lookup_object_o
 	return NULL;
 }
 
+static void debug_objects_fill_pool(void)
+{
+	/*
+	 * On RT enabled kernels the pool refill must happen in preemptible
+	 * context:
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())
+		fill_pool();
+}
+
 static void
 __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack)
 {
@@ -595,12 +605,7 @@ __debug_object_init(void *addr, const st
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	/*
-	 * On RT enabled kernels the pool refill must happen in preemptible
-	 * context:
-	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())
-		fill_pool();
+	debug_objects_fill_pool();
 
 	db = get_bucket((unsigned long) addr);
 
@@ -685,6 +690,8 @@ int debug_object_activate(void *addr, co
 	if (!debug_objects_enabled)
 		return 0;
 
+	debug_objects_fill_pool();
+
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -894,6 +901,8 @@ void debug_object_assert_init(void *addr
 	if (!debug_objects_enabled)
 		return;
 
+	debug_objects_fill_pool();
+
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);


