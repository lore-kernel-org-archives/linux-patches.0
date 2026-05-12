Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DB43EDE45;
	Tue, 12 May 2026 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609337; cv=none; b=ir3vkgw8FkPdKnCglRVN6jRdJ7yNCnLuHvNIF19L08m2hTb3i7NHSAnmQimdqjCwYVEBvE0U+AKqYAekeTK/8osjgI6Mbe9G8D8d924D7T4kbdi062ZQrgC6yqk+PuKmSbSMM01vqXs/eIXOmIeetZJ93NquoFI3lZApZZj47IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609337; c=relaxed/simple;
	bh=nVQFPcWVXoyYWwjUTJV+gTi9OqnYwho+Ik8zH1mXxqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZIyOxFrQmNlNaRiIqdVFhhyKyz4pPaJu0mSvTdGN03yky5VgncnYXTwZCVmEyY8/p6os4oVtIQXdCqkbjfy80qNZnfjesxoPSQObGla8ERATQqIBm3uMyH3bKIibYulW82aeGIhZEpALFelNNsOpI7j7pnla7CqWffVx/D7O5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwxFRZgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwxFRZgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB2C2BCB0;
	Tue, 12 May 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609336;
	bh=nVQFPcWVXoyYWwjUTJV+gTi9OqnYwho+Ik8zH1mXxqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwxFRZgNodOdasaty2vEtisj5k9rak4cwBLoFwhOuScvIcxfT48U6lWCHDptfGSq3
	 8PP9ZEFpY3nV3oo9zH8QuNvwu506wfMGqxCJrkc7xoIPeRJUGNBGJPuBkIES2FFy+9
	 bsO7dBBcVRZ69ZC9qUP3WghMt+sYLXgYH6wnHaVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Arnd Bergmann <arnd@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 7.0 154/307] x86/boot/e820: Re-enable BIOS fallback if e820 table is empty
Date: Tue, 12 May 2026 19:39:09 +0200
Message-ID: <20260512173943.376420109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

commit 5772f6535227ebd104065d80afa8ed3478d34c5c upstream.

In commit:

  157266edcc56 ("x86/boot/e820: Simplify append_e820_table() and remove restriction on single-entry tables")

the check on the number of entries in the e820 table was removed. The intention
was to support single-entry maps, but by removing the check entirely, we also
skip the fallback (to, e.g., the BIOS 88h function).

This means that if no E820 map is passed in from the bootloader (which is the
case on some bootloaders, like linld), we end up with an empty memory map, and
the kernel fails to boot (either by deadlocking on OOM, or by failing to
allocate the real mode trampoline, or similar).

Re-instate the check in append_e820_table(), but only check that nr_entries is
non-zero. This allows e820__memory_setup_default() to fall back to other memory
size sources, and doesn't affect e820__memory_setup_extended(), as the latter
ignores the return value from append_e820_table().

In doing so, we also update the return values to be proper error codes, with
-ENOENT for this case (there are no entries), and -EINVAL for the case where an
entry appears invalid. Given none of the callers check the actual value -- just
whether it's nonzero -- this is largely aesthetic in practice.

Tested against linld, and the kernel boots again fine.

[ mingo: Readability edits to the comment and the changelog. ]

Fixes: 157266edcc56 ("x86/boot/e820: Simplify append_e820_table() and remove restriction on single-entry tables")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://patch.msgid.link/20260416065746.1896647-1-david@davidgow.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/e820.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 2a9992758933..eb72537bc0b1 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -450,6 +450,10 @@ __init static int append_e820_table(struct boot_e820_entry *entries, u32 nr_entr
 {
 	struct boot_e820_entry *entry = entries;
 
+	/* If there aren't any entries, we'll want to fall back to another source: */
+	if (!nr_entries)
+		return -ENOENT;
+
 	while (nr_entries) {
 		u64 start = entry->addr;
 		u64 size  = entry->size;
@@ -458,7 +462,7 @@ __init static int append_e820_table(struct boot_e820_entry *entries, u32 nr_entr
 
 		/* Ignore the remaining entries on 64-bit overflow: */
 		if (start > end && likely(size))
-			return -1;
+			return -EINVAL;
 
 		e820__range_add(start, size, type);
 
-- 
2.54.0



