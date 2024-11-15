Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B71D126C17;
	Fri, 15 Nov 2024 06:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653100; cv=none; b=Uur3a3LavgABUlBM/4DyPy2hlFz7n6uKqQjHc5nQrFFIMuj58N/KnfUzVX3oKc6d0A5otT3glYCHFCyQnPlXTgzzH0z8428675H/f6EzHjak4fZ0v8iKCQvOUg0SoB9gtSDcuzgjaQKjZi33X+EEJSH83/AdRdZe6Y3o2NknsDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653100; c=relaxed/simple;
	bh=8uWpb6ICf8nkQBmDb6jzAXUPx6yDtPQKAd1BkaZLPYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzbsTEYcRhGMi3777lmciEfE518ghhOTHbcZ+JRoeHIYCVoveFYxFz/86SLSLZRF63IbGCYZmqkje9mvYqIW20WLbmaV6GTKSGMUfWqEM55dEG8VAyIs0kv/Wjgtau9VDzs4WqiSou10RMHK7aNulexk/rJD3jXXrMDadU4b/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+O5HtpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+O5HtpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF648C4CECF;
	Fri, 15 Nov 2024 06:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653100;
	bh=8uWpb6ICf8nkQBmDb6jzAXUPx6yDtPQKAd1BkaZLPYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+O5HtpIg8r6cCWVLx0GOlJ+e1qnP6w6fW/Z5uqG8j5Vj4O5fJnsjlWlu1Wp43+g8
	 ytkzLYw7KusN4T5k1rWLe/tFbEaThAdYYjonnoLqwQUsADPDAdtjgCKh3ZBpZzbvo0
	 Rj1Gx77118tPxNTErYfxhHzuE5FnodM0dDRRv7oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b415c07907a2990d1a3@syzkaller.appspotmail.com,
	Chen Ridong <chenridong@huawei.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/66] security/keys: fix slab-out-of-bounds in key_task_permission
Date: Fri, 15 Nov 2024 07:37:19 +0100
Message-ID: <20241115063723.214326698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5ca620d31cd30..5ec89db5a7c1b 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -772,8 +772,11 @@ static bool search_nested_keyrings(struct key *keyring,
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



