Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F227C84E;
	Thu, 19 Feb 2026 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466668; cv=none; b=Nn9h1ETp5rw/vWfPnA95hJ7p2dQtDonJ8RX9EBzkcyTowiToSHOfb6Dyr4Vn+lVtd3eluxc7HMUzYw6UxsI8EQ/B/b5hUukjlyF5G01pZiOHB6Lj3gSE8Ly67Qtqj4swxVpZhOcD+02dCPNi9P2wenfig3386Xxegj433PjKYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466668; c=relaxed/simple;
	bh=MVqRvrLQPFbJEeqA9cWcn4Tv0F7Rsw3ktTfs1h5d4kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHWQ1I2hNlx0IQrpRLZsX8OLK6iMxFfoKoUbyrMwtRbUswHo4Na9azzP9S4wc7NFD+yVZlDj6CC1QQKVeeMwQcfoHtYzbV3MyfrxWDoOXsJkN9Rx8doMXFYS6pZES//TP8IcFMcPjul053bGUG+Y9cZ9L8sL54BklLxNUGo0TTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ingiEvPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ingiEvPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2FEC116D0;
	Thu, 19 Feb 2026 02:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466668;
	bh=MVqRvrLQPFbJEeqA9cWcn4Tv0F7Rsw3ktTfs1h5d4kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ingiEvPl1Ne8X8+cQHN+rNs9bErxWdpl3k/G5CN99bxU09TCcsdV1lE8lBeo3u7HI
	 bcU7aRaNNJLgBDDgefS8yzLXASH9ZnfIXrHGUVR00KMcI0NkqjbbvO9nGj/d1Gsc3V
	 BlYHFF0jVZephxu4TE/ZIAWj1KKfzRXMIplufsBgjjuKieFNTQfhgMEdKiO3yUhXsR
	 +vlNEfL69BEHBVxMHyRfhNSmcZbBDAVV9TN3caSErZBYBmevPBlGBGwp11gk4SzyBm
	 Bb/+timyIDgPebjdMV8X7FRS4VK5ab8YSqINvwzTlWdopu9ApBPHQNwN4y6Q7T0VNR
	 tflK4uADJ+nRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] tty: vt/keyboard: Split apart vt_do_diacrit()
Date: Wed, 18 Feb 2026 21:03:40 -0500
Message-ID: <20260219020422.1539798-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 0a76a17238f805b231d97b118232a5185bbb7a18 ]

After commit bfb24564b5fd ("tty: vt/keyboard: use __free()"), builds
using asm goto for put_user() and get_user() with a version of clang
older than 17 error with:

  drivers/tty/vt/keyboard.c:1709:7: error: cannot jump from this asm goto statement to one of its possible targets
                  if (put_user(asize, &a->kb_cnt))
                      ^
  ...
  arch/arm64/include/asm/uaccess.h:298:2: note: expanded from macro '__put_mem_asm'
          asm goto(                                                       \
          ^
  drivers/tty/vt/keyboard.c:1687:7: note: possible target of asm goto statement
                  if (put_user(asize, &a->kb_cnt))
                      ^
  ...
  arch/arm64/include/asm/uaccess.h:342:2: note: expanded from macro '__raw_put_user'
          __rpu_failed:                                                   \
          ^
  drivers/tty/vt/keyboard.c:1697:23: note: jump exits scope of variable with __attribute__((cleanup))
                  void __free(kfree) *buf = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacruc),
                                      ^
  drivers/tty/vt/keyboard.c:1671:33: note: jump bypasses initialization of variable with __attribute__((cleanup))
                  struct kbdiacr __free(kfree) *dia = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacr),
                                                ^

Prior to a fix to clang's scope checker in clang 17 [1], all labels in a
function were validated as potential targets of all asm gotos in a
function, regardless of whether they actually were a target of an asm
goto call, resulting in false positive errors about skipping over
variables marked with the cleanup attribute.

To workaround this error, split up the bodies of the case statements in
vt_do_diacrit() into their own functions so that the scope checker does
not trip up on the multiple instances of __free().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509091702.Oc7eCRDw-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202511241835.EA8lShgH-lkp@intel.com/
Link: https://github.com/llvm/llvm-project/commit/f023f5cdb2e6c19026f04a15b5a935c041835d14 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20251125-tty-vt-keyboard-wa-clang-scope-check-error-v1-1-f5a5ea55c578@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The current code in this tree has the `__free()` annotations from
`bfb24564b5fd8`, confirming that the prerequisite commit is present and
this fix is needed.

### Scope and Risk Assessment

- **Files changed**: 1 (drivers/tty/vt/keyboard.c)
- **Nature of change**: Pure mechanical refactoring - moving code into
  separate functions
- **Logic changes**: None - the behavior is identical
- **Risk**: Very low. The code is simply moved into helper functions. No
  logic changes, no new paths, no changed semantics.
- **Lines changed**: The diff looks large (~170 lines removed and added)
  but it's entirely code movement, not new code.

### User Impact

- **Who is affected**: Anyone building the kernel with clang < 17 on
  arm64 (or potentially other architectures using asm goto for
  put_user/get_user)
- **Severity**: Build failure - the kernel **cannot be compiled** at all
  with these toolchain combinations
- **Practical impact**: Enterprise distributions and CI systems that use
  older clang versions would be completely blocked

### Stable Criteria Assessment

1. **Obviously correct and tested**: Yes - pure code movement, reported
   by kernel test robot, authored by Nathan Chancellor (clang/compiler
   expert), signed off by Greg KH
2. **Fixes a real bug**: Yes - build failure
3. **Important issue**: Yes - build failures prevent kernel compilation
   entirely
4. **Small and contained**: Yes - single file, pure refactoring
5. **No new features**: Correct - no new features
6. **Applies cleanly**: Should apply cleanly since the prerequisite
   `bfb24564b5fd8` must also be present

### Dependency

This commit depends on `bfb24564b5fd8` ("tty: vt/keyboard: use
__free()") being present in the stable tree. The fix is only needed if
`__free()` annotations were backported. If `bfb24564b5fd8` was
backported to a stable tree, then this fix **must** also be backported
to avoid build failures with older clang.

### Verification

- **git log master -- drivers/tty/vt/keyboard.c** confirmed
  `bfb24564b5fd8` is present in the tree
- **Read of keyboard.c lines 1650-1699** confirmed the `__free(kfree)`
  annotations are present in the current codebase, making this fix
  necessary
- **git show bfb24564b5fd8** confirmed this is the prerequisite that
  introduced the problematic `__free()` usage
- Commit message includes concrete error output from the kernel test
  robot, confirming the build failure is real and reproducible
- The commit references the specific clang fix (llvm-project commit
  f023f5cdb2e6c19) confirming this is a known compiler issue
- Author is Nathan Chancellor, the primary Linux kernel clang/LLVM
  maintainer - expert in this area
- Signed-off by Greg KH (stable tree maintainer)

### Conclusion

This is a textbook **build fix** - one of the explicitly allowed
categories for stable backporting. It fixes a real compilation failure
with clang < 17 on arm64, the change is purely mechanical (code movement
into helper functions with zero logic changes), the risk is extremely
low, and it's authored by the kernel's clang expert and signed off by
the stable maintainer. The only caveat is that it requires the
prerequisite commit `bfb24564b5fd8` to be present in the stable tree.

**YES**

 drivers/tty/vt/keyboard.c | 221 ++++++++++++++++++++------------------
 1 file changed, 115 insertions(+), 106 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index d65fc60dd7bed..3538d54d6a6ac 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1649,134 +1649,143 @@ int __init kbd_init(void)
 
 /* Ioctl support code */
 
-/**
- *	vt_do_diacrit		-	diacritical table updates
- *	@cmd: ioctl request
- *	@udp: pointer to user data for ioctl
- *	@perm: permissions check computed by caller
- *
- *	Update the diacritical tables atomically and safely. Lock them
- *	against simultaneous keypresses
- */
-int vt_do_diacrit(unsigned int cmd, void __user *udp, int perm)
+static int vt_do_kdgkbdiacr(void __user *udp)
 {
-	int asize;
-
-	switch (cmd) {
-	case KDGKBDIACR:
-	{
-		struct kbdiacrs __user *a = udp;
-		int i;
+	struct kbdiacrs __user *a = udp;
+	int i, asize;
 
-		struct kbdiacr __free(kfree) *dia = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacr),
-								  GFP_KERNEL);
-		if (!dia)
-			return -ENOMEM;
+	struct kbdiacr __free(kfree) *dia = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacr),
+							  GFP_KERNEL);
+	if (!dia)
+		return -ENOMEM;
 
-		/* Lock the diacriticals table, make a copy and then
-		   copy it after we unlock */
-		scoped_guard(spinlock_irqsave, &kbd_event_lock) {
-			asize = accent_table_size;
-			for (i = 0; i < asize; i++) {
-				dia[i].diacr = conv_uni_to_8bit(accent_table[i].diacr);
-				dia[i].base = conv_uni_to_8bit(accent_table[i].base);
-				dia[i].result = conv_uni_to_8bit(accent_table[i].result);
-			}
+	/* Lock the diacriticals table, make a copy and then
+	   copy it after we unlock */
+	scoped_guard(spinlock_irqsave, &kbd_event_lock) {
+		asize = accent_table_size;
+		for (i = 0; i < asize; i++) {
+			dia[i].diacr = conv_uni_to_8bit(accent_table[i].diacr);
+			dia[i].base = conv_uni_to_8bit(accent_table[i].base);
+			dia[i].result = conv_uni_to_8bit(accent_table[i].result);
 		}
-
-		if (put_user(asize, &a->kb_cnt))
-			return -EFAULT;
-		if (copy_to_user(a->kbdiacr, dia, asize * sizeof(struct kbdiacr)))
-			return -EFAULT;
-		return 0;
 	}
-	case KDGKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = udp;
 
-		void __free(kfree) *buf = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacruc),
-							GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
+	if (put_user(asize, &a->kb_cnt))
+		return -EFAULT;
+	if (copy_to_user(a->kbdiacr, dia, asize * sizeof(struct kbdiacr)))
+		return -EFAULT;
+	return 0;
+}
 
-		/* Lock the diacriticals table, make a copy and then
-		   copy it after we unlock */
-		scoped_guard(spinlock_irqsave, &kbd_event_lock) {
-			asize = accent_table_size;
-			memcpy(buf, accent_table, asize * sizeof(struct kbdiacruc));
-		}
+static int vt_do_kdgkbdiacruc(void __user *udp)
+{
+	struct kbdiacrsuc __user *a = udp;
+	int asize;
 
-		if (put_user(asize, &a->kb_cnt))
-			return -EFAULT;
-		if (copy_to_user(a->kbdiacruc, buf, asize * sizeof(struct kbdiacruc)))
-			return -EFAULT;
+	void __free(kfree) *buf = kmalloc_array(MAX_DIACR, sizeof(struct kbdiacruc),
+						GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 
-		return 0;
+	/* Lock the diacriticals table, make a copy and then
+	   copy it after we unlock */
+	scoped_guard(spinlock_irqsave, &kbd_event_lock) {
+		asize = accent_table_size;
+		memcpy(buf, accent_table, asize * sizeof(struct kbdiacruc));
 	}
 
-	case KDSKBDIACR:
-	{
-		struct kbdiacrs __user *a = udp;
-		struct kbdiacr __free(kfree) *dia = NULL;
-		unsigned int ct;
-		int i;
+	if (put_user(asize, &a->kb_cnt))
+		return -EFAULT;
+	if (copy_to_user(a->kbdiacruc, buf, asize * sizeof(struct kbdiacruc)))
+		return -EFAULT;
 
-		if (!perm)
-			return -EPERM;
-		if (get_user(ct, &a->kb_cnt))
-			return -EFAULT;
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
+	return 0;
+}
 
-		if (ct) {
-			dia = memdup_array_user(a->kbdiacr,
-						ct, sizeof(struct kbdiacr));
-			if (IS_ERR(dia))
-				return PTR_ERR(dia);
-		}
+static int vt_do_kdskbdiacr(void __user *udp, int perm)
+{
+	struct kbdiacrs __user *a = udp;
+	struct kbdiacr __free(kfree) *dia = NULL;
+	unsigned int ct;
+	int i;
 
-		guard(spinlock_irqsave)(&kbd_event_lock);
-		accent_table_size = ct;
-		for (i = 0; i < ct; i++) {
-			accent_table[i].diacr =
-					conv_8bit_to_uni(dia[i].diacr);
-			accent_table[i].base =
-					conv_8bit_to_uni(dia[i].base);
-			accent_table[i].result =
-					conv_8bit_to_uni(dia[i].result);
-		}
+	if (!perm)
+		return -EPERM;
+	if (get_user(ct, &a->kb_cnt))
+		return -EFAULT;
+	if (ct >= MAX_DIACR)
+		return -EINVAL;
 
-		return 0;
+	if (ct) {
+		dia = memdup_array_user(a->kbdiacr,
+					ct, sizeof(struct kbdiacr));
+		if (IS_ERR(dia))
+			return PTR_ERR(dia);
 	}
 
-	case KDSKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = udp;
-		unsigned int ct;
-		void __free(kfree) *buf = NULL;
+	guard(spinlock_irqsave)(&kbd_event_lock);
+	accent_table_size = ct;
+	for (i = 0; i < ct; i++) {
+		accent_table[i].diacr =
+				conv_8bit_to_uni(dia[i].diacr);
+		accent_table[i].base =
+				conv_8bit_to_uni(dia[i].base);
+		accent_table[i].result =
+				conv_8bit_to_uni(dia[i].result);
+	}
 
-		if (!perm)
-			return -EPERM;
+	return 0;
+}
 
-		if (get_user(ct, &a->kb_cnt))
-			return -EFAULT;
+static int vt_do_kdskbdiacruc(void __user *udp, int perm)
+{
+	struct kbdiacrsuc __user *a = udp;
+	unsigned int ct;
+	void __free(kfree) *buf = NULL;
 
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
+	if (!perm)
+		return -EPERM;
 
-		if (ct) {
-			buf = memdup_array_user(a->kbdiacruc,
-						ct, sizeof(struct kbdiacruc));
-			if (IS_ERR(buf))
-				return PTR_ERR(buf);
-		}
-		guard(spinlock_irqsave)(&kbd_event_lock);
-		if (ct)
-			memcpy(accent_table, buf,
-					ct * sizeof(struct kbdiacruc));
-		accent_table_size = ct;
-		return 0;
+	if (get_user(ct, &a->kb_cnt))
+		return -EFAULT;
+
+	if (ct >= MAX_DIACR)
+		return -EINVAL;
+
+	if (ct) {
+		buf = memdup_array_user(a->kbdiacruc,
+					ct, sizeof(struct kbdiacruc));
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
 	}
+	guard(spinlock_irqsave)(&kbd_event_lock);
+	if (ct)
+		memcpy(accent_table, buf,
+				ct * sizeof(struct kbdiacruc));
+	accent_table_size = ct;
+	return 0;
+}
+
+/**
+ *	vt_do_diacrit		-	diacritical table updates
+ *	@cmd: ioctl request
+ *	@udp: pointer to user data for ioctl
+ *	@perm: permissions check computed by caller
+ *
+ *	Update the diacritical tables atomically and safely. Lock them
+ *	against simultaneous keypresses
+ */
+int vt_do_diacrit(unsigned int cmd, void __user *udp, int perm)
+{
+	switch (cmd) {
+	case KDGKBDIACR:
+		return vt_do_kdgkbdiacr(udp);
+	case KDGKBDIACRUC:
+		return vt_do_kdgkbdiacruc(udp);
+	case KDSKBDIACR:
+		return vt_do_kdskbdiacr(udp, perm);
+	case KDSKBDIACRUC:
+		return vt_do_kdskbdiacruc(udp, perm);
 	}
 	return 0;
 }
-- 
2.51.0

