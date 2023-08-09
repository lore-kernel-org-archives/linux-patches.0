Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B96717731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BEDC433CC;
	Wed,  9 Aug 2023 11:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579249;
	bh=rkaZj6OX91dzWLu+RQ8mn7ezGZqVz24/ckZySYJX/f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9PMw/YBI8HADKsdb8JjAtDC3qwaP1h/9LaD45xVix02XofbG5mj2blftCi2RX6g4
	 14DaxeZn3TIKIiRUrPlfcqWoKbVJtd2Zjzhesf7UjHhNGYxbycG2acW7kbRZ6kHUpu
	 Z1RVoqw+WAi91mNKkdx6XRTL9W8vumB9l3yHwtcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/204] debugobjects: Recheck debug_objects_enabled before reporting
Date: Wed,  9 Aug 2023 12:41:06 +0200
Message-ID: <20230809103646.884012192@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 8b64d420fe2450f82848178506d3e3a0bd195539 ]

syzbot is reporting false a positive ODEBUG message immediately after
ODEBUG was disabled due to OOM.

  [ 1062.309646][T22911] ODEBUG: Out of memory. ODEBUG disabled
  [ 1062.886755][ T5171] ------------[ cut here ]------------
  [ 1062.892770][ T5171] ODEBUG: assert_init not available (active state 0) object: ffffc900056afb20 object type: timer_list hint: process_timeout+0x0/0x40

  CPU 0 [ T5171]                CPU 1 [T22911]
  --------------                --------------
  debug_object_assert_init() {
    if (!debug_objects_enabled)
      return;
    db = get_bucket(addr);
                                lookup_object_or_alloc() {
                                  debug_objects_enabled = 0;
                                  return NULL;
                                }
                                debug_objects_oom() {
                                  pr_warn("Out of memory. ODEBUG disabled\n");
                                  // all buckets get emptied here, and
                                }
    lookup_object_or_alloc(addr, db, descr, false, true) {
      // this bucket is already empty.
      return ERR_PTR(-ENOENT);
    }
    // Emits false positive warning.
    debug_print_object(&o, "assert_init");
  }

Recheck debug_object_enabled in debug_print_object() to avoid that.

Reported-by: syzbot <syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/492fe2ae-5141-d548-ebd5-62f5fe2e57f7@I-love.SAKURA.ne.jp
Closes: https://syzkaller.appspot.com/bug?extid=7937ba6a50bdd00fffdf
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index bacb00a9cd9f9..b6217c797554b 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -280,6 +280,15 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 	struct debug_obj_descr *descr = obj->descr;
 	static int limit;
 
+	/*
+	 * Don't report if lookup_object_or_alloc() by the current thread
+	 * failed because lookup_object_or_alloc()/debug_objects_oom() by a
+	 * concurrent thread turned off debug_objects_enabled and cleared
+	 * the hash buckets.
+	 */
+	if (!debug_objects_enabled)
+		return;
+
 	if (limit < 5 && descr != descr_test) {
 		void *hint = descr->debug_hint ?
 			descr->debug_hint(obj->object) : NULL;
-- 
2.39.2



