Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8518785C;
	Fri, 15 Nov 2024 06:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652859; cv=none; b=iHf9VebhYx74FDbN7NLKusach2L6ur4rWN6d+UN/eAaRToBbUFz8bamZcv28Sdcj+25cO7EB77dziKRUSP+4rqRQ3S4a1mHSaHG7By6kMXhIhpREQDsyKVDl9sAr5LnEyGQSHY/LF3Kbuqv57MFXq9tPtYdz/ivj2RuPTTyXdyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652859; c=relaxed/simple;
	bh=aOZnyFqc06QlEIkc4ijEj/qAY17Oa/fOqGf6TPbJJ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUGz6sufeTx9KlKXokqT4rizkzqEG8wJgrdRwsBlwsDsXHD+mkAG2zf3JkG6NZi/AP7qkVyAbIdWnQJYuzQ8F1TbEYOUcSCAKX35L3yMyK+XdLhjUxFq+TLaWHzeHWBmilmGV79gH3UzCJh4Dq4P+wizgrB9Um1tHMgid+B0JIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjmIyW1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjmIyW1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574CAC4CECF;
	Fri, 15 Nov 2024 06:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652858;
	bh=aOZnyFqc06QlEIkc4ijEj/qAY17Oa/fOqGf6TPbJJ1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjmIyW1B4QSlRuiK9HjCg3QM8d0hmEOvzN0zV4V+qfZorfN4HfVIZbarEkZMA3RUF
	 oGj/5skn69t0zFiCmrdPWlmhDPMxYy4sj1LfIMhuKoZzfjAgy4CMA7LaiPWQ0d+FKm
	 jA0q7xVDjk17vp/o98X4kC4KAaBfpM+txdy92Nko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b415c07907a2990d1a3@syzkaller.appspotmail.com,
	Chen Ridong <chenridong@huawei.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/52] security/keys: fix slab-out-of-bounds in key_task_permission
Date: Fri, 15 Nov 2024 07:37:19 +0100
Message-ID: <20241115063723.083829420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 4a74da044ec9ec8679e6beccc4306b936b62873f ]

KASAN reports an out of bounds read:
BUG: KASAN: slab-out-of-bounds in __kuid_val include/linux/uidgid.h:36
BUG: KASAN: slab-out-of-bounds in uid_eq include/linux/uidgid.h:63 [inline]
BUG: KASAN: slab-out-of-bounds in key_task_permission+0x394/0x410
security/keys/permission.c:54
Read of size 4 at addr ffff88813c3ab618 by task stress-ng/4362

CPU: 2 PID: 4362 Comm: stress-ng Not tainted 5.10.0-14930-gafbffd6c3ede #15
Call Trace:
 __dump_stack lib/dump_stack.c:82 [inline]
 dump_stack+0x107/0x167 lib/dump_stack.c:123
 print_address_description.constprop.0+0x19/0x170 mm/kasan/report.c:400
 __kasan_report.cold+0x6c/0x84 mm/kasan/report.c:560
 kasan_report+0x3a/0x50 mm/kasan/report.c:585
 __kuid_val include/linux/uidgid.h:36 [inline]
 uid_eq include/linux/uidgid.h:63 [inline]
 key_task_permission+0x394/0x410 security/keys/permission.c:54
 search_nested_keyrings+0x90e/0xe90 security/keys/keyring.c:793

This issue was also reported by syzbot.

It can be reproduced by following these steps(more details [1]):
1. Obtain more than 32 inputs that have similar hashes, which ends with the
   pattern '0xxxxxxxe6'.
2. Reboot and add the keys obtained in step 1.

The reproducer demonstrates how this issue happened:
1. In the search_nested_keyrings function, when it iterates through the
   slots in a node(below tag ascend_to_node), if the slot pointer is meta
   and node->back_pointer != NULL(it means a root), it will proceed to
   descend_to_node. However, there is an exception. If node is the root,
   and one of the slots points to a shortcut, it will be treated as a
   keyring.
2. Whether the ptr is keyring decided by keyring_ptr_is_keyring function.
   However, KEYRING_PTR_SUBTYPE is 0x2UL, the same as
   ASSOC_ARRAY_PTR_SUBTYPE_MASK.
3. When 32 keys with the similar hashes are added to the tree, the ROOT
   has keys with hashes that are not similar (e.g. slot 0) and it splits
   NODE A without using a shortcut. When NODE A is filled with keys that
   all hashes are xxe6, the keys are similar, NODE A will split with a
   shortcut. Finally, it forms the tree as shown below, where slot 6 points
   to a shortcut.

                      NODE A
              +------>+---+
      ROOT    |       | 0 | xxe6
      +---+   |       +---+
 xxxx | 0 | shortcut  :   : xxe6
      +---+   |       +---+
 xxe6 :   :   |       |   | xxe6
      +---+   |       +---+
      | 6 |---+       :   : xxe6
      +---+           +---+
 xxe6 :   :           | f | xxe6
      +---+           +---+
 xxe6 | f |
      +---+

4. As mentioned above, If a slot(slot 6) of the root points to a shortcut,
   it may be mistakenly transferred to a key*, leading to a read
   out-of-bounds read.

To fix this issue, one should jump to descend_to_node if the ptr is a
shortcut, regardless of whether the node is root or not.

[1] https://lore.kernel.org/linux-kernel/1cfa878e-8c7b-4570-8606-21daf5e13ce7@huaweicloud.com/

[jarkko: tweaked the commit message a bit to have an appropriate closes
 tag.]
Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Reported-by: syzbot+5b415c07907a2990d1a3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000cbb7860611f61147@google.com/T/
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e8f2366021ea3..0f414a114729a 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -739,8 +739,11 @@ static bool search_nested_keyrings(struct key *keyring,
 	for (; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		ptr = READ_ONCE(node->slots[slot]);
 
-		if (assoc_array_ptr_is_meta(ptr) && node->back_pointer)
-			goto descend_to_node;
+		if (assoc_array_ptr_is_meta(ptr)) {
+			if (node->back_pointer ||
+			    assoc_array_ptr_is_shortcut(ptr))
+				goto descend_to_node;
+		}
 
 		if (!keyring_ptr_is_keyring(ptr))
 			continue;
-- 
2.43.0



