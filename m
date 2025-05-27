Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F31DB34C;
	Tue, 27 May 2025 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366136; cv=none; b=ABLUdQFFWlUDFdzj+waiqz84sm6k7sGy4XDflc9oOF77t19L5Udv/6CHVXCXU7X7n+StC8cdTdl8U+E3ogaxEtqaobH17mqz5WKmcdcV2+fn5MihrVUTAIWAthrJBi2vM6QYjhD5NfXRoJYNRDxc74Pd9IzVShQ0DKLlMlVHLqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366136; c=relaxed/simple;
	bh=JnRXje7R08+FhEoRZ0hmjCnFzKA6Nhfs/a+A0c1956M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjNLr205fQYop9nTVWwhIvPW//n4iCl45hY3F+SHO/75yt/ooRgPrAhKOJucSH4Yih6rn/jYz/TCcOWJVE2eVfAC6nS44/wKFytE2xuXgCx8PmhEBbVFHhMWHktw385m/amvX1oTtDu0P8nS0qr+nKIbECjV69ogRi23E/AUbk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FI3RUww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FI3RUww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB9FC4CEE9;
	Tue, 27 May 2025 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366135;
	bh=JnRXje7R08+FhEoRZ0hmjCnFzKA6Nhfs/a+A0c1956M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FI3RUwwdkJLbdT2ALjJBgKMEZiqUzkWAzxN4bFDAQqz8z9rUEHkb7Bkt1z4O8KHS
	 wIVPANNFCBdBSzCG2BgPI4SoQU/2EvNH8PrS3u9mEL6Rve8whkUc2IJ3ZROHZOoPlf
	 3+fcGqpyvB2M14F0JGdirTt//O1LL2Fhao25NBiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	"Erhard F." <erhard_f@mailbox.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 602/626] mm: vmalloc: only zero-init on vrealloc shrink
Date: Tue, 27 May 2025 18:28:15 +0200
Message-ID: <20250527162509.456156582@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 70d1eb031a68cbde4eed8099674be21778441c94 upstream.

The common case is to grow reallocations, and since init_on_alloc will
have already zeroed the whole allocation, we only need to zero when
shrinking the allocation.

Link: https://lkml.kernel.org/r/20250515214217.619685-2-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4097,8 +4097,8 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out "freed" memory. */
-		if (want_init_on_free())
+		/* Zero out "freed" memory, potentially for future realloc. */
+		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
@@ -4111,9 +4111,11 @@ void *vrealloc_noprof(const void *p, siz
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
 				       KASAN_VMALLOC_PROT_NORMAL);
-		/* Zero out "alloced" memory. */
-		if (want_init_on_alloc(flags))
-			memset((void *)p + old_size, 0, size - old_size);
+		/*
+		 * No need to zero memory here, as unused memory will have
+		 * already been zeroed at initial allocation time or during
+		 * realloc shrink time.
+		 */
 		vm->requested_size = size;
 		return (void *)p;
 	}


