Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08401EF0B0;
	Sat, 14 Feb 2026 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031209; cv=none; b=e/ka7NHYq++zc74hu26Pvth7kpLkp+g1QpKcD0UlP931bH9AjqPd4TVgq8E8Ou2L5iGjtrpvSqMam0+H27y16eYJtoISTnP7DUOcHcrsTpGnWMdJldS8KnfCJnvng+oJSqPgLINBaQpuC2o9zR9e1LvzYMIfA0uLQMBDz97+opM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031209; c=relaxed/simple;
	bh=z/oYzgU4t2PyZ7v/2SPXdzZhUBGX4rlVOPLQkFhjCKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkZ2EJlTwnvzJCwhbrOVxXJeHr1LBwod9k5g+4wIrUmb5Jgrx/JDpze1Qp8Ok4KD2q58zlgYqQLHnjvdysOwbAe8rBl4Q3shZoajHcFpQ85sbe1mQEwlb2rw+T5DRo2xRaPNceV2kdmmguOP/UX0oN9bUdet1c/wZs2v1BcVams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UV8C9Peq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UV8C9Peq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36D5C116C6;
	Sat, 14 Feb 2026 01:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031209;
	bh=z/oYzgU4t2PyZ7v/2SPXdzZhUBGX4rlVOPLQkFhjCKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV8C9PeqK2ZhJyRELQFjNITcMTEOKqlhUd9Q0pQLusEOwyMHnicc119pjWAAokLqq
	 6taIljEm8jCu/YYwF/jPlEBxaHDW0B+dmIWJC0MSeF+w9nkUyAg3UasN3v7rNe4Gqe
	 eKSKB8oAyTEFcXGdj21tLxsnRKui15OK/NNu3kCR3qisv+NsckNIzc11R+Kv7xLk+E
	 PO80oEKODbFgqyE0y16sKYY2D66pNbYyf3F5XsuntZ7bDWKF6sNTlsY4uvhjYEaV9D
	 X1Dz6Z8pnvUql6ouAW22T583JBIm9ELBlnTUE3eAgH5+ICRjwpd1hi7XUGtP2ks0WW
	 g9PaR/Ib0wR1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mamin506@gmail.com,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] accel/amdxdna: Fix tail-pointer polling in mailbox_get_msg()
Date: Fri, 13 Feb 2026 19:59:43 -0500
Message-ID: <20260214010245.3671907-103-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit cd77d5a4aaf8c5c1d819f47cf814bf7d4920b0a2 ]

In mailbox_get_msg(), mailbox_reg_read_non_zero() is called to poll for a
non-zero tail pointer. This assumed that a zero value indicates an error.
However, certain corner cases legitimately produce a zero tail pointer.
To handle these cases, remove mailbox_reg_read_non_zero(). The zero tail
pointer will be treated as a valid rewind event.

Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251204181603.793824-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - `mailbox_get_tailptr()` already exists in v6.14 and the fix uses
it. No dependency issues.

## Comprehensive Analysis

### 1. Commit Message Analysis

The commit title explicitly says "Fix" and the message clearly describes
the bug: `mailbox_reg_read_non_zero()` polls for a non-zero tail
pointer, **incorrectly assuming that a zero value indicates an error**.
However, zero is a legitimate tail pointer value in certain corner cases
(ring buffer rewind events). The fix removes the flawed polling function
and instead uses a simple direct read via the existing
`mailbox_get_tailptr()`.

### 2. Code Change Analysis - The Bug Mechanism

The bug is in `mailbox_reg_read_non_zero()`:

```115:129:/home/sasha/linux-
autosel/drivers/accel/amdxdna/amdxdna_mailbox.c
static int mailbox_reg_read_non_zero(struct mailbox_channel *mb_chann,
u32 mbox_reg, u32 *val)
{
        struct xdna_mailbox_res *mb_res = &mb_chann->mb->res;
        void __iomem *ringbuf_addr = mb_res->mbox_base + mbox_reg;
        int ret, value;

        /* Poll till value is not zero */
        ret = readx_poll_timeout(readl, ringbuf_addr, value,
                                 value, 1 /* us */, 100);
        if (ret < 0)
                return ret;

        *val = value;
        return 0;
}
```

This function uses `readx_poll_timeout()` with `value` as both the
variable AND the condition (the condition is just `value`, i.e.,
truthy/non-zero). It polls every 1us for up to 100us. If the tail
pointer register is zero after 100us, it returns `-ETIMEDOUT`.

The call site in `mailbox_get_msg()`:

```289:290:/home/sasha/linux-
autosel/drivers/accel/amdxdna/amdxdna_mailbox.c
        if (mailbox_reg_read_non_zero(mb_chann,
mb_chann->res[CHAN_RES_I2X].mb_tail_ptr_reg, &tail))
                return -EINVAL;
```

When the function times out (tail is legitimately zero),
`mailbox_get_msg()` returns `-EINVAL`.

**The catastrophic consequence** is in `mailbox_rx_worker()` (in v6.14):

```377:386:/home/sasha/linux-
autosel/drivers/accel/amdxdna/amdxdna_mailbox.c
                /* Other error means device doesn't look good, disable
irq. */
                if (unlikely(ret)) {
                        MB_ERR(mb_chann, "Unexpected ret %d, disable
irq", ret);
                        WRITE_ONCE(mb_chann->bad_state, true);
                        disable_irq(mb_chann->msix_irq);
                        break;
                }
```

Any return other than `0` or `-ENOENT` causes:
1. `bad_state = true` is set **permanently** (never reset)
2. `disable_irq()` is called (in v6.14)
3. All future work items check `bad_state` and immediately return
4. The mailbox channel is **permanently dead** - no more firmware
   communication is possible
5. The AMD AI Engine accelerator becomes non-functional

**When does tail=0 legitimately occur?** The ring buffer protocol uses a
TOMBSTONE marker when wrapping. After the writer (firmware, for the I2X
channel) writes a TOMBSTONE at the end of the buffer and wraps to the
start, the tail pointer can be zero briefly or permanently depending on
the firmware's message scheduling. The commit describes this as a "valid
rewind event."

### 3. Fix Correctness

The fix replaces the flawed polling function with a direct register
read:
```c
tail = mailbox_get_tailptr(mb_chann, CHAN_RES_I2X);
```

This is obviously correct because the existing validation in
`mailbox_get_msg()` properly handles a zero tail:
- `tail > ringbuf_size || !IS_ALIGNED(tail, 4)` → 0 passes (aligned and
  within bounds)
- `head == tail` → if head is also 0, returns `-ENOENT` (empty buffer,
  which is the correct behavior)
- If head != 0 and tail == 0, the function processes messages normally
  (rewind scenario)

### 4. Scope and Risk Assessment

- **Size**: 1 file changed, 1 insertion, 18 deletions (net -17 lines)
- **Scope**: Entirely self-contained within the mailbox driver
- **Risk**: Very low - the fix removes a polling function and replaces
  it with a simple direct read, relying on already-existing validation
  code
- **Regression potential**: Near zero - all the defensive checks (bounds
  validation, alignment, empty-buffer check) remain intact

### 5. Dependencies

- No dependencies on other commits
- `mailbox_get_tailptr()` already exists in v6.14 (line 152)
- The patch applies cleanly to v6.14.y stable (surrounding code is
  identical)

### 6. User Impact

- Affects users of AMD AI Engine (XDNA) accelerators (Ryzen AI NPUs)
- The bug causes the accelerator to become permanently non-functional
  when the tail pointer is legitimately zero
- This is a **device-killing bug** that requires driver reload/reboot to
  recover
- The amdxdna driver exists in stable trees starting from v6.14

### 7. Stability Indicators

- Has `Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>`
- Author is `Lizhi Hou <lizhi.hou@amd.com>` - an AMD engineer and the
  primary amdxdna driver developer
- The fix was accepted via the drm subsystem merge path

### Conclusion

This commit fixes a real, severe bug where a false positive error
detection (treating zero tail pointer as invalid) permanently kills the
mailbox communication channel in the AMD XDNA accelerator driver. The
consequence is the accelerator device becoming completely non-functional
until driver reload/reboot. The fix is small (net -17 lines), obviously
correct (removes incorrect assumption, relies on existing validation),
self-contained (single file, no dependencies), and applies cleanly to
the v6.14 stable tree. It meets all stable kernel criteria.

**YES**

 drivers/accel/amdxdna/amdxdna_mailbox.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index 858df97cd3fbd..a60a85ce564cb 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -112,22 +112,6 @@ static u32 mailbox_reg_read(struct mailbox_channel *mb_chann, u32 mbox_reg)
 	return readl(ringbuf_addr);
 }
 
-static int mailbox_reg_read_non_zero(struct mailbox_channel *mb_chann, u32 mbox_reg, u32 *val)
-{
-	struct xdna_mailbox_res *mb_res = &mb_chann->mb->res;
-	void __iomem *ringbuf_addr = mb_res->mbox_base + mbox_reg;
-	int ret, value;
-
-	/* Poll till value is not zero */
-	ret = readx_poll_timeout(readl, ringbuf_addr, value,
-				 value, 1 /* us */, 100);
-	if (ret < 0)
-		return ret;
-
-	*val = value;
-	return 0;
-}
-
 static inline void
 mailbox_set_headptr(struct mailbox_channel *mb_chann, u32 headptr_val)
 {
@@ -286,8 +270,7 @@ static int mailbox_get_msg(struct mailbox_channel *mb_chann)
 	u32 start_addr;
 	int ret;
 
-	if (mailbox_reg_read_non_zero(mb_chann, mb_chann->res[CHAN_RES_I2X].mb_tail_ptr_reg, &tail))
-		return -EINVAL;
+	tail = mailbox_get_tailptr(mb_chann, CHAN_RES_I2X);
 	head = mb_chann->i2x_head;
 	ringbuf_size = mailbox_get_ringbuf_size(mb_chann, CHAN_RES_I2X);
 	start_addr = mb_chann->res[CHAN_RES_I2X].rb_start_addr;
-- 
2.51.0

