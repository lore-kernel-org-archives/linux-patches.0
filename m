Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015594A33E1;
	Thu,  2 Jul 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009491; cv=none; b=IK8TdYLGotqeJzdLs4TuHtQAuR6imD9gNcXaHvVs/LCyMX1wYBkdNh62s7xSrTOJ/y/Fb4z+EKSrZIxiYAvpYCkp6gc2AHA0R4wnpRzHJtn4I/zWPDvdzNcBn2fZQMexTEohauUPIqPIDULKmjj0Kosnpnp1R9NFM2Kvgaxe3uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009491; c=relaxed/simple;
	bh=P4yXUYgun603pPj+WE71Xv+8BiOcToTZ9sorjA7hQO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P55rYXTg3Ieqp38A8PG3p7+3Y/OvXYWGW09zt4+32nzBy4bNXh+oajulqaM8EFIAOECpfJ+xXIwx+OcPMRbfX6pdu17FO09tZqXQJWsL5i6t02uC0mXhDTm/VraRnw28JFget7fs0CUaHNFoUngjbmMw9u4KlC1fx5c/v/alEJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLokxPip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLokxPip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C41F000E9;
	Thu,  2 Jul 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009486;
	bh=xzxxhwiQnshsR4ZQXQ33cW/B2XHMknvoA/JYggaip5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLokxPipkg/4XP6Yag0mz/0TVG2axWgWpp6C1G1kT/43W+BSVXY1WzvFAtG05WZ2r
	 kNu20XaT1tb9MTrKMhdmJfdW0f+FtYJ5iHUmfVNYwjzMovOsl1mZ6aUI+PMRuRf8h1
	 i1ZjXt9goHsNe+ZU3SXPebLS0Giv797XUbR9Klf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 70/96] exfat: fix potential use-after-free in exfat_find_dir_entry()
Date: Thu,  2 Jul 2026 18:20:02 +0200
Message-ID: <20260702155110.453167382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1043,12 +1043,12 @@ rewind:
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
@@ -1059,6 +1059,7 @@ rewind:
 					uniname += EXFAT_FILE_NAME_LEN;
 
 				len = exfat_extract_uni_name(ep, entry_uniname);
+				brelse(bh);
 				name_len += len;
 
 				unichar = *(uniname+len);
@@ -1077,6 +1078,7 @@ rewind:
 				continue;
 			}
 
+			brelse(bh);
 			if (entry_type &
 					(TYPE_CRITICAL_SEC | TYPE_BENIGN_SEC)) {
 				if (step == DIRENT_STEP_SECD) {


