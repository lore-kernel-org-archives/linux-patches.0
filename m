Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AEA13AA43;
	Tue, 27 Feb 2024 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042909; cv=none; b=fsmnIE2g1ZGeJPMXyN8DXcYRMiss0uQrDkQkp580PEdNeiRF9J4AZgCixKoukKx4NNb9wRc1MMNiNaZH2ude2pHPfkJDxNK/PU9vD4V1zQFCtkQvG5Jy1WhVKNtZGhTsM/zQUvZ7KpijGAq58M+NDk8NVoBP6rK1n793QdmuNCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042909; c=relaxed/simple;
	bh=L3JIfm2UgTlEBDaOGn/vIXk3C2WHTnnc3+Zp1wgoJMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0c8JCXffFUMBK3idDV3h7aWtV5Sd2rtIbAivKnAre5zNvc39QFxIsUIbaMizrKG/Y1+sg9suDw+ri1TlbpnYBvqx5LkAUNL4rt9zf2bvWeKTkCSmqg9MUFRS8e7j0twqqHQijCsZB+U6e0TqMS+FuIXXjGBLWNG+aDYTgf3xA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=085aUNzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="085aUNzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40F7C433F1;
	Tue, 27 Feb 2024 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042909;
	bh=L3JIfm2UgTlEBDaOGn/vIXk3C2WHTnnc3+Zp1wgoJMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=085aUNznP2yNu2wdep++K7eNmPON1BumLsONYGrb986julISei6P+sq4GZ1dF2/LJ
	 +U8FFWdrTqhVh+b9is8A3bsB5VEeCRYg78xkufQ6R8C2bNJ6qWD7oOFoYjffW0Skzq
	 CN/QusUPtzZgP012C8ZDItQ0wjjbhfjxrJc0cQXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/245] debugobjects: Recheck debug_objects_enabled before reporting
Date: Tue, 27 Feb 2024 14:25:53 +0100
Message-ID: <20240227131620.571925925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 09fddc0ea6d39..3972e2123e554 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -501,6 +501,15 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 	const struct debug_obj_descr *descr = obj->descr;
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
2.43.0



