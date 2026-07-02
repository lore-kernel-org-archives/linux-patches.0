Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD91351C3D;
	Thu,  2 Jul 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010055; cv=none; b=J5UUEr5UdRaXcjNghZdgKJjQAB8aogkr+KTyvd4X1IrdjcIMyoV0JMCbFYNlF8R3guepkZehmJh1pMn1INFpZCBAuE4U9+QE0e84Y59YRZSigNQbuSKmMSOOD9nh5oeb3/hLW/yQgTLvUDDA4flxdQsQKEBRovpBtfFLNCiKoCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010055; c=relaxed/simple;
	bh=qB2egGpUnaZLq9ggSN3wWCLel8iKoyl5dynsJCuMtzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfy/6LXyxQvL93+plpgMDDDpHtXyE9zN08azDpTDm5JsIRuEUS0fBW80v8GhnOyRoxcqSzVMr8Vbmsohxqqz+YeM+CXdSY8Gyxo3XP3QLTr+/RldeKkDKdyVfMnrdMUZtnZQbpgCQVzCmJ9gPCrKuCT4XOOJJxw5J8CYtgBSNbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOOL54Hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOOL54Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA141F000E9;
	Thu,  2 Jul 2026 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010053;
	bh=W2tdDb9xlrgiwawss434/Xbe3RDzDPRUBo0gs6VYCTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOOL54HxBWkwfg7IfcsvlBO5ILOdglMvm38T8U6MsFgYy9yHgh2yOP6vpvJrmMqNe
	 JiNG2/UButLuCsffxiCqiSH//IBZPBvHgPc0b66CQ1njY/Nq8gQbR0HW3AVIdTKp9v
	 nii2VRousF2wOZWdM0I2GzzIOSvE2pj1dxBaDYeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 092/129] exfat: fix potential use-after-free in exfat_find_dir_entry()
Date: Thu,  2 Jul 2026 18:20:11 +0200
Message-ID: <20260702155114.047073180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 3f5f8ee9917cc2b9076ac533492d8a200edcabb8 upstream.

In exfat_find_dir_entry(), the buffer_head obtained from
exfat_get_dentry() is released with brelse(bh) before the fall-through
TYPE_EXTEND branch reads the directory entry through ep (which points
into bh->b_data):

	brelse(bh);
	if (entry_type == TYPE_EXTEND) {
		...
		len = exfat_extract_uni_name(ep, entry_uniname);
		...
	}

After brelse() drops our reference, nothing guarantees that the
underlying page backing bh->b_data remains valid for the subsequent
exfat_extract_uni_name() read. This is the same pattern fixed in
commit fc961522ddbd ("exfat: Fix potential use after free in
exfat_load_upcase_table()").

Move brelse(bh) so it runs after ep is no longer dereferenced on
each branch.

Confirmed on QEMU x86_64 with CONFIG_KASAN=y + CONFIG_DEBUG_PAGEALLOC=y
+ CONFIG_PAGE_POISONING=y on linux-next, using a crafted exFAT image
(long filename with same-hash collisions forcing the TYPE_EXTEND path).
With a debug-only invalidate_bdev() inserted between brelse(bh) and
the ep read to make the stale-deref window deterministic, the
unpatched kernel faults:

  BUG: KASAN: use-after-free in exfat_find_dir_entry+0x133b/0x15a0
  BUG: unable to handle page fault for address: ffff88801a5fa0c2
  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
  RIP: 0010:exfat_find_dir_entry+0x1188/0x15a0

With this patch applied, the same instrumented harness completes
cleanly under the same sanitizer stack. I have not reproduced a
crash on an uninstrumented kernel under ordinary reclaim; the
instrumented A/B establishes the lifetime violation and that the
patch closes it, not an unaided triggerability claim.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -1040,12 +1040,12 @@ rewind:
 				continue;
 			}
 
-			brelse(bh);
 			if (entry_type == TYPE_EXTEND) {
 				unsigned short entry_uniname[16], unichar;
 
 				if (step != DIRENT_STEP_NAME ||
 				    name_len >= MAX_NAME_LENGTH) {
+					brelse(bh);
 					step = DIRENT_STEP_FILE;
 					continue;
 				}
@@ -1056,6 +1056,7 @@ rewind:
 					uniname += EXFAT_FILE_NAME_LEN;
 
 				len = exfat_extract_uni_name(ep, entry_uniname);
+				brelse(bh);
 				name_len += len;
 
 				unichar = *(uniname+len);
@@ -1074,6 +1075,7 @@ rewind:
 				continue;
 			}
 
+			brelse(bh);
 			if (entry_type &
 					(TYPE_CRITICAL_SEC | TYPE_BENIGN_SEC)) {
 				if (step == DIRENT_STEP_SECD) {


