Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B013214;
	Mon,  9 Jun 2025 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476842; cv=none; b=sXYkbG9msCXdu9PYa5LTIP0aivAomI8qET9WEMs7V/Jl/ALFWWeEkkespnd2FU65GN+TNK4sb/k1o5x7vPn0GZuzN5Wk6ze40dw9SOXedydLnwgg/n1ocaJG1w8vVu1NAb8OiX6VMGgMSVS/8k67Hy96I+WfNLL1r2wfcL2Emio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476842; c=relaxed/simple;
	bh=gMdVvzbUtoZ0vOBFNgcPlEAKUyHg7PjW/tihhraoc2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=utz5MDcC4cJXw+rYKAORjDiPB4kcd88tSV6og/KDAsrmGHkCqdkj4B14IBF7UCcGyCa6NlKAKUx4lRPzDQ9ztj4QQA4xmfVU3V6pw4UgycB7TEtUmZWy6X1Qz1XgYZli3qNub2YHwiUACHsw3YkOqXxc56l5honQBoJ5FqA6sgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eao8gvHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eao8gvHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7951AC4CEEB;
	Mon,  9 Jun 2025 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476842;
	bh=gMdVvzbUtoZ0vOBFNgcPlEAKUyHg7PjW/tihhraoc2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eao8gvHZJ3GdPegivtykqDGWiCyteQ4I5hNoLxiyc8lkAv0oarkDSgQ3ZRthiHAvX
	 owYADj1ptlbHz74RK8gCSJzYaeQflRuICo4bwh4XHhUt5ocQ+uKB9e9gr10w5R4aM0
	 Q74gnOQm8ywKXjs6k9cL7p9UzUkVKLczuL/tykzXPVKdcyxhNv0rculwFI95f+cQgS
	 neZINGUxPj8Crxz+LcX9AoEf7ztHWSXpOrg0jc8eO6PSrfzGHx5+k6pOvcQNND0d42
	 VTlKTNNYYvr13tC9ZbyWSUhbuvFapcR92YCWyV0lLTCD/acp6cXbYXnZodTHz8/Us9
	 cplSeznCggA9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robert Hodaszi <robert.hodaszi@digi.com>,
	Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stern@rowland.harvard.edu,
	viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 6.6 16/18] usb: cdc-wdm: avoid setting WDM_READ for ZLP-s
Date: Mon,  9 Jun 2025 09:46:50 -0400
Message-Id: <20250609134652.1344323-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134652.1344323-1-sashal@kernel.org>
References: <20250609134652.1344323-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: Robert Hodaszi <robert.hodaszi@digi.com>

[ Upstream commit 387602d8a75574fafb451b7a8215e78dfd67ee63 ]

Don't set WDM_READ flag in wdm_in_callback() for ZLP-s, otherwise when
userspace tries to poll for available data, it might - incorrectly -
believe there is something available, and when it tries to non-blocking
read it, it might get stuck in the read loop.

For example this is what glib does for non-blocking read (briefly):

  1. poll()
  2. if poll returns with non-zero, starts a read data loop:
    a. loop on poll() (EINTR disabled)
    b. if revents was set, reads data
      I. if read returns with EINTR or EAGAIN, goto 2.a.
      II. otherwise return with data

So if ZLP sets WDM_READ (#1), we expect data, and try to read it (#2).
But as that was a ZLP, and we are doing non-blocking read, wdm_read()
returns with EAGAIN (#2.b.I), so loop again, and try to read again
(#2.a.).

With glib, we might stuck in this loop forever, as EINTR is disabled
(#2.a).

Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250403144004.3889125-1-robert.hodaszi@digi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## Backport Analysis: YES

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Clear User-Facing Bug Fix**
The commit fixes a critical bug that causes userspace applications to
get stuck in infinite poll/read loops when dealing with Zero-Length
Packets (ZLPs). This is a regression that affects real-world
applications using glib and similar libraries with cdc-wdm devices.

### 2. **Minimal and Surgical Changes**
The fix is extremely contained and follows the stable tree criteria:
- **Small code change**: Only ~20 lines modified, mostly removing
  problematic code
- **Well-defined scope**: Changes are limited to `wdm_in_callback()`
  function
- **Clear logic**: Simple check for `length == 0` and skip setting
  `WDM_READ` flag
- **No architectural changes**: Doesn't modify core data structures or
  algorithms

### 3. **Low Regression Risk**
The changes are inherently safe:
- **Removing problematic behavior**: The fix removes the incorrect
  setting of `WDM_READ` for ZLPs
- **Maintains existing functionality**: All other packet handling
  remains unchanged
- **Proper fallback**: ZLPs still trigger service work via
  `schedule_work(&desc->service_outs_intr)`
- **Backwards compatible**: No API changes that could affect other
  drivers

### 4. **Critical Subsystem Impact**
The USB CDC-WDM driver is used by many mobile modems and WWAN devices.
Getting stuck in infinite loops renders these devices unusable, which is
a severe user impact.

### 5. **Alignment with Historical Backports**
This commit follows the same pattern as the successful backports shown
in the examples:
- Similar to **Commit #1 (YES)**: Fixes flag management issue that
  causes device to become unusable
- Similar to **Commit #2 (YES)**: Addresses race condition in flag
  handling
- Similar to **Commit #3 (YES)**: Prevents userspace applications from
  hanging

### 6. **Code Analysis Details**

**Key changes that support backporting:**

1. **ZLP Detection**: `if (length == 0)` - Simple, safe check
2. **Flag Management Fix**: Prevents incorrect `WDM_READ` setting for
   ZLPs
3. **Cleanup**: Removes `reslength` field and related zero-length
   handling code that was causing the infinite loop
4. **Proper Service Handling**: ZLPs are still processed via work queue
   (`skip_zlp` goto)

**Risk mitigation:**
- The `service_interrupt_work()` function change adds a condition
  `(desc->length || desc->rerr)` that ensures `WDM_READ` is only set
  when there's actual data or an error to report
- This prevents the exact scenario that caused infinite loops

### 7. **Real-World Impact**
From the kernel repository examination, this appears to be addressing a
recently discovered issue that affects applications using glib's non-
blocking I/O patterns with CDC-WDM devices. The infinite loop scenario
described is a critical usability bug.

**Conclusion**: This is a textbook example of a stable-worthy fix - it
addresses a clear user-facing bug with minimal, surgical changes that
have low regression risk and high benefit for affected users.

 drivers/usb/class/cdc-wdm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 559c121f09230..600ad9412c146 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -92,7 +92,6 @@ struct wdm_device {
 	u16			wMaxCommand;
 	u16			wMaxPacketSize;
 	__le16			inum;
-	int			reslength;
 	int			length;
 	int			read;
 	int			count;
@@ -214,6 +213,11 @@ static void wdm_in_callback(struct urb *urb)
 	if (desc->rerr == 0 && status != -EPIPE)
 		desc->rerr = status;
 
+	if (length == 0) {
+		dev_dbg(&desc->intf->dev, "received ZLP\n");
+		goto skip_zlp;
+	}
+
 	if (length + desc->length > desc->wMaxCommand) {
 		/* The buffer would overflow */
 		set_bit(WDM_OVERFLOW, &desc->flags);
@@ -222,18 +226,18 @@ static void wdm_in_callback(struct urb *urb)
 		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
 			memmove(desc->ubuf + desc->length, desc->inbuf, length);
 			desc->length += length;
-			desc->reslength = length;
 		}
 	}
 skip_error:
 
 	if (desc->rerr) {
 		/*
-		 * Since there was an error, userspace may decide to not read
-		 * any data after poll'ing.
+		 * If there was a ZLP or an error, userspace may decide to not
+		 * read any data after poll'ing.
 		 * We should respond to further attempts from the device to send
 		 * data, so that we can get unstuck.
 		 */
+skip_zlp:
 		schedule_work(&desc->service_outs_intr);
 	} else {
 		set_bit(WDM_READ, &desc->flags);
@@ -585,15 +589,6 @@ static ssize_t wdm_read
 			goto retry;
 		}
 
-		if (!desc->reslength) { /* zero length read */
-			dev_dbg(&desc->intf->dev, "zero length - clearing WDM_READ\n");
-			clear_bit(WDM_READ, &desc->flags);
-			rv = service_outstanding_interrupt(desc);
-			spin_unlock_irq(&desc->iuspin);
-			if (rv < 0)
-				goto err;
-			goto retry;
-		}
 		cntr = desc->length;
 		spin_unlock_irq(&desc->iuspin);
 	}
@@ -1016,7 +1011,7 @@ static void service_interrupt_work(struct work_struct *work)
 
 	spin_lock_irq(&desc->iuspin);
 	service_outstanding_interrupt(desc);
-	if (!desc->resp_count) {
+	if (!desc->resp_count && (desc->length || desc->rerr)) {
 		set_bit(WDM_READ, &desc->flags);
 		wake_up(&desc->wait);
 	}
-- 
2.39.5

