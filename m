Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B667C415F15;
	Tue, 21 Jul 2026 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665051; cv=none; b=nNHmfww42+7ZYRlBgOJvSimDIboBT+D8eekO7NcQxNTAte9+mMKCAGxica1BUPTxcjHsvqW1snHta8O63zYwkKK5EmYbigzxkLFtyUK0vD7uIyZEhJbrrXFMJ3S6U2kRoQDNVjCpYd2mb+YC/A729BQdgmbx2z77iUuM0VcruNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665051; c=relaxed/simple;
	bh=1kyMuGWSt71zCUdrcxACbfjBIHY2XP/cwMjr84Slr2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXv2VlsY03ce59zcOKsipT8YX9CsQ+Gt7ZeN1AmiomrP7kZ9mCvjaTqCqv7QcYTvJvgY+4/CKi+DMscxzM2HoGfSX4ZzYbMcMD4t8oJOo0Gn6/pekcYVfHvE8BwHXvHrjAVeiZvlKENVbmzEC/6Q2rbkVEp3kuQvrCrz1JcBiVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlYjsiI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlYjsiI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E871F000E9;
	Tue, 21 Jul 2026 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665050;
	bh=tVRYyQPGackecCEU278e4GBtu5cR3krCtch2zc8QfmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlYjsiI+Z01z7dn1WXFseXx9dEca65ODcwLbWbRWJD924bK4lPH5QV7pTHW4P9PhP
	 mk5PV/bCAHH/WVXwclQCLIzupGjY/90vZHHJoBg30XELTdBEedd4ew7ez4Fip7Uv/5
	 FIfs5uvufQ66zHAT68Ms89WfCqVXoEk+BOo0upM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5e8dda76ca21dae314b6@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 0158/1266] debugobjects: Plug race against a concurrent OOM disable
Date: Tue, 21 Jul 2026 17:09:55 +0200
Message-ID: <20260721152445.339904240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Gleixner <tglx@kernel.org>

commit b81dde13cc163450dcb402dcc915ef13ba241e01 upstream.

syzbot reported a puzzling splat:

   WARNING: kernel/time/hrtimer.c:443 at stub_timer+0xa/0x20

stub_timer() is installed as timer callback function in
hrtimer_fixup_assert_init(), which is invoked when
debug_object_assert_init() can't find a shadow object. In that case debug
objects emits a warning about it before invoking the fixup.

Though the provided console log lacks this warning and instead has the
following a few seconds before the splat:

     ODEBUG: Out of memory. ODEBUG disabled

So the object was looked up in debug_object_assert_init() and the lookup
failed due a concurrent out of memory situation which disabled debug
objects and freed the shadow objects:

debug_object_assert_init()
        if (!debug_objects_enabled)
        	return;                         obj = alloc();
                				if (!obj) {
							// Out of memory
                                                	debug_objects_enabled = false;
                                                        free_objects();
        obj = lookup_or_alloc();

        // The lookup failed because the other side
        // removed the objects, so this returns
        // an error code as the object in question
        // is not statically initialized

	if (!IS_ERR_OR_NULL(obj))
        	return;
        if (!obj) {
        	debug_oom();
                return;
        }

        print(...)
           if (!debug_objects_enabled)
                return;

        fixup(...)

The debug object splat is skipped because debug_objects_enabled is false,
but the fixup callback is invoked unconditionally, which makes the timer
disfunctional.

This is only a problem in debug_object_assert_init() and
debug_object_activate() as both have to handle statically initialized
objects and therefore must handle the error pointer return case
gracefully. All other places only handle the found/not found case and the
NULL pointer return is a signal for OOM. Otherwise they get a valid shadow
object.

Plug the hole by checking whether debug objects are still enabled before
invoking the print and fixup function in those two places.

Fixes: b84d435cc228 ("debugobjects: Extend to assert that an object is initialized")
Reported-by: syzbot+5e8dda76ca21dae314b6@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/874iiwlzlb.ffs@fw13
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/debugobjects.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -768,6 +768,14 @@ int debug_object_activate(void *addr, co
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+
+	/*
+	 * lookup_object_or_alloc() might have raced with a concurrent
+	 * allocation failure which disabled debug objects.
+	 */
+	if (!debug_objects_enabled)
+		return 0;
+
 	debug_print_object(&o, "activate");
 
 	switch (o.state) {
@@ -945,6 +953,15 @@ void debug_object_assert_init(void *addr
 		return;
 	}
 
+	/*
+	 * lookup_object_or_alloc() might have raced with a concurrent
+	 * allocation failure which disabled debug objects. Don't run the fixup
+	 * as it might turn a valid object useless. See for example
+	 * hrtimer_fixup_assert_init().
+	 */
+	if (!debug_objects_enabled)
+		return;
+
 	/* Object is neither tracked nor static. It's not initialized. */
 	debug_print_object(&o, "assert_init");
 	debug_object_fixup(descr->fixup_assert_init, addr, ODEBUG_STATE_NOTAVAILABLE);


