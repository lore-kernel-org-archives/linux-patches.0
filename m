Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EB542049;
	Thu, 15 Jan 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495918; cv=none; b=gxDbLaBGNCFTdKA3q/QzBgFJ8i4YUwDIzeFlvN9ZbkmxWyoippU6cxwHpkFtNF8yquJoriR06IqifxzEHpwfZrIYcV6MVC2fXaNNW1nNYAgnSgsNKbUhfoFC7epBWeOZzDLOENNmNMzUoCPbeT3SuJkFWi8ulUCWvPDHq8DxtxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495918; c=relaxed/simple;
	bh=Yvnb3zVyxlQjbwhrJtfXTJZlx6zsy1PpRzf9T4yaovU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7bGR3JfyiiJQgN2/ZO8uIUn9tr3/RbnDh1Z7fnKCdsSVu+WBAOLlsul4dzNAakggNAJO7gk4dEt2/pfk9Fa4aYEQ9C8YN3jy+Zmp8fPCK1LBrqMDyYHJDvVwzdw306iyVDFvlBE9iP9/0XAA566+NNStRVR4/3a8lnPI6yIv/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guTpbHGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guTpbHGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF3AC116D0;
	Thu, 15 Jan 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495917;
	bh=Yvnb3zVyxlQjbwhrJtfXTJZlx6zsy1PpRzf9T4yaovU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guTpbHGmK6vUFd+btn996z1B2TWyZinBeu2l+1+RddzhXWQhMKPLmWuuOHI8Y311/
	 JjC+EEBA+r+p7HOiD1VKLQdcnJLAUBIBVXRW5BAARb5vHENCuq0Ib9yX+YZfiooRLb
	 Z1Su2+5SpMGFXO+/vXIr5J0mF8vPPQZHAYlFbcGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 014/181] rust_binder: remove spin_lock() in rust_shrink_free_page()
Date: Thu, 15 Jan 2026 17:45:51 +0100
Message-ID: <20260115164202.835707641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 361e0ff456a8daf9753c18030533256e4133ce7a upstream.

When forward-porting Rust Binder to 6.18, I neglected to take commit
fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope") into
account, and apparently I did not end up running the shrinker callback
when I sanity tested the driver before submission. This leads to crashes
like the following:

	============================================
	WARNING: possible recursive locking detected
	6.18.0-mainline-maybe-dirty #1 Tainted: G          IO
	--------------------------------------------
	kswapd0/68 is trying to acquire lock:
	ffff956000fa18b0 (&l->lock){+.+.}-{2:2}, at: lock_list_lru_of_memcg+0x128/0x230

	but task is already holding lock:
	ffff956000fa18b0 (&l->lock){+.+.}-{2:2}, at: rust_helper_spin_lock+0xd/0x20

	other info that might help us debug this:
	 Possible unsafe locking scenario:

	       CPU0
	       ----
	  lock(&l->lock);
	  lock(&l->lock);

	 *** DEADLOCK ***

	 May be due to missing lock nesting notation

	3 locks held by kswapd0/68:
	 #0: ffffffff90d2e260 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x597/0x1160
	 #1: ffff956000fa18b0 (&l->lock){+.+.}-{2:2}, at: rust_helper_spin_lock+0xd/0x20
	 #2: ffffffff90cf3680 (rcu_read_lock){....}-{1:2}, at: lock_list_lru_of_memcg+0x2d/0x230

To fix this, remove the spin_lock() call from rust_shrink_free_page().

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251202-binder-shrink-unspin-v1-1-263efb9ad625@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/page_range.rs | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index 9379038f61f5..fdd97112ef5c 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -727,8 +727,5 @@ fn drop(self: Pin<&mut Self>) {
     drop(mm);
     drop(page);
 
-    // SAFETY: We just unlocked the lru lock, but it should be locked when we return.
-    unsafe { bindings::spin_lock(&raw mut (*lru).lock) };
-
     LRU_REMOVED_ENTRY
 }
-- 
2.52.0



