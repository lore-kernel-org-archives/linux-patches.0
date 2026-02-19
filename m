Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F325F2D876F;
	Thu, 19 Feb 2026 02:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466683; cv=none; b=tQ/ZVnULmw/2xidlHPQURuiU093QzDNTxhEagmrDvtRN8USj5lMOe5qIJTAoqaeajsNhTQpRw+kgtPAvd22Tjcv6/f6OB8ic5hugD/UDxlTZEUmLYyeS/a4k1fc5ZweFvofKCM1JLXlY95rD6MAvUMNLj71ZM4Twi839X0/qt2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466683; c=relaxed/simple;
	bh=PEy4M+x/13hXJFTNbqHXIFiFKwPnGI3g2c2qHSwUTgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5zsJUb4ZFtiktiFB6dzHVfMjqR5dgtfdFgv7jHwk/dMfR8YJDca/cP0+9Wr90BQEVK/IxPihaTwoGKS70FrUXvEwmk2t9vD23rVseT5LpjUD/ZjZqCD5lS8QaAX8+5YYsJcfJsnhPuntJViLzO2aBKEi+KVIPI72KdZ/rO1jCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YT9W+hOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YT9W+hOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0765C116D0;
	Thu, 19 Feb 2026 02:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466682;
	bh=PEy4M+x/13hXJFTNbqHXIFiFKwPnGI3g2c2qHSwUTgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT9W+hOlpKGRbxmfILtXzBHSS57oPP99LmEp2s0p2b58its1QyZlxwvdrY5bEsmlh
	 M7fb4LmHuYA14+ZcNJFxwwmpkOHyhcuKA/qVyYOc9SQvDM+e5WkaJMjzbaUF8ECHwN
	 9ROcVVI0SR7O7HpsZcdSZyZWpHborPkXL6O99k+KHs/DZvCnesY4ahygldJowHpOsv
	 DwgStXgzXoUuMgR0IYNpaUbYZ8mIWxSP2g03Ie04GnTmWj1hnxZF6ExllsI2bqpo+a
	 07uFJx14/4Pqq0s+vd+dOfXwCYgOhKTcBhHh3N+jRGHzlDwpBCxFnMzTLqpPKSHFU9
	 0tMQgWuAL2IpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tuo Li <islituo@gmail.com>,
	Scott Branden <scott.branden@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] misc: bcm_vk: Fix possible null-pointer dereferences in bcm_vk_read()
Date: Wed, 18 Feb 2026 21:03:51 -0500
Message-ID: <20260219020422.1539798-15-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit ba75ecb97d3f4e95d59002c13afb6519205be6cb ]

In the function bcm_vk_read(), the pointer entry is checked, indicating
that it can be NULL. If entry is NULL and rc is set to -EMSGSIZE, the
following code may cause null-pointer dereferences:

  struct vk_msg_blk tmp_msg = entry->to_h_msg[0];
  set_msg_id(&tmp_msg, entry->usr_msg_id);
  tmp_msg.size = entry->to_h_blks - 1;

To prevent these possible null-pointer dereferences, copy to_h_msg,
usr_msg_id, and to_h_blks from iter into temporary variables, and return
these temporary variables to the application instead of accessing them
through a potentially NULL entry.

Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Link: https://patch.msgid.link/20251211063637.3987937-1-islituo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The buggy commit is present in stable trees 5.15 and 6.1 (among others),
confirming the bug exists in stable kernels.

## Summary

**Bug**: Guaranteed null-pointer dereference in `bcm_vk_read()` when
user provides a buffer too small for the message. `entry` is NULL but
dereferenced in the `else if (rc == -EMSGSIZE)` branch.

**Fix quality**: Small, surgical, correct. Saves needed values from
`iter` (which is valid) into temporary variables while inside the loop,
then uses those temporaries instead of the NULL `entry` pointer. The fix
is reviewed by the subsystem maintainer and merged by Greg KH.

**Risk**: Very low. The fix only changes when values are copied (from
inside the loop to the same code path), using temporary variables. No
behavioral change for the normal path.

**Impact**: Prevents a kernel crash/oops that any user of this driver
can trigger by calling `read()` with an undersized buffer.

**Scope**: Single file, ~10 meaningful lines changed. Clean and self-
contained.

**Stable criteria**: Meets all criteria:
- Obviously correct and tested (reviewed by maintainer)
- Fixes a real bug (null-pointer dereference = kernel crash)
- Fixes an important issue (kernel crash from userspace)
- Small and contained
- No new features or APIs

## Verification

- **git blame** confirmed the buggy lines (`entry->to_h_msg[0]`,
  `entry->usr_msg_id`, `entry->to_h_blks` at lines 1055, 1061, 1062)
  originate from commit `111d746bb4767a` (Jan 2021, "misc: bcm-vk: add
  VK messaging support")
- **Code trace** verified: `entry` is initialized to NULL (line 1012),
  remains NULL in the `-EMSGSIZE` path (only set to `iter` in the
  buffer-big-enough branch), and is then dereferenced in `else if (rc ==
  -EMSGSIZE)` branch — confirmed null-pointer dereference
- **git tag** confirmed the buggy commit is present in stable trees
  p-5.15 and p-6.1
- **Diff review** confirmed the fix correctly saves values from `iter`
  (valid pointer) into temporaries before leaving the loop, and uses
  those temporaries in the error path
- **Reviewed-by: Scott Branden** (subsystem maintainer) confirms
  correctness

**YES**

 drivers/misc/bcm-vk/bcm_vk_msg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_msg.c b/drivers/misc/bcm-vk/bcm_vk_msg.c
index 1f42d1d5a630a..665a3888708ac 100644
--- a/drivers/misc/bcm-vk/bcm_vk_msg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_msg.c
@@ -1010,6 +1010,9 @@ ssize_t bcm_vk_read(struct file *p_file,
 	struct device *dev = &vk->pdev->dev;
 	struct bcm_vk_msg_chan *chan = &vk->to_h_msg_chan;
 	struct bcm_vk_wkent *entry = NULL, *iter;
+	struct vk_msg_blk tmp_msg;
+	u32 tmp_usr_msg_id;
+	u32 tmp_blks;
 	u32 q_num;
 	u32 rsp_length;
 
@@ -1034,6 +1037,9 @@ ssize_t bcm_vk_read(struct file *p_file,
 					entry = iter;
 				} else {
 					/* buffer not big enough */
+					tmp_msg = iter->to_h_msg[0];
+					tmp_usr_msg_id = iter->usr_msg_id;
+					tmp_blks = iter->to_h_blks;
 					rc = -EMSGSIZE;
 				}
 				goto read_loop_exit;
@@ -1052,14 +1058,12 @@ ssize_t bcm_vk_read(struct file *p_file,
 
 		bcm_vk_free_wkent(dev, entry);
 	} else if (rc == -EMSGSIZE) {
-		struct vk_msg_blk tmp_msg = entry->to_h_msg[0];
-
 		/*
 		 * in this case, return just the first block, so
 		 * that app knows what size it is looking for.
 		 */
-		set_msg_id(&tmp_msg, entry->usr_msg_id);
-		tmp_msg.size = entry->to_h_blks - 1;
+		set_msg_id(&tmp_msg, tmp_usr_msg_id);
+		tmp_msg.size = tmp_blks - 1;
 		if (copy_to_user(buf, &tmp_msg, VK_MSGQ_BLK_SIZE) != 0) {
 			dev_err(dev, "Error return 1st block in -EMSGSIZE\n");
 			rc = -EFAULT;
-- 
2.51.0

