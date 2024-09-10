Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C6191F94;
	Tue, 10 Sep 2024 10:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962630; cv=none; b=JlHwl95pkNOt6/0fV0cS3555QmzAsEvl58od2v9g9kn27hGffJgeWMACTY406KAZkCu/fG8qH56dwn/M0fpXlpL++6HHl7g7Nm5GtI18pFftlt2HMIOhuU9ck/KVLGLyJSE0/jvdLvoyTzqjSILh3u2eOp86QIMmCody8pVWuuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962630; c=relaxed/simple;
	bh=++va27bCCcjVsD4JjQWCe6g+KvPofa9wifQTfWjbPIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0qC+foKMuHQxe+Hf31BNSUTV7Hg5Bz5qOEvv4eaKODOwCNjxWtoKyUOo9kMXE8dXph4o9d7MXp6mysOpMYMRywocx0UD8fC/6DnvNNwp3AUzYhyOWl0TjE69x8i3IvZIXWCNlZt0nz/0s0AVfeb6JexiOFw8w9nZprB5X6voYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVmYhekJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVmYhekJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A6AC4CEC3;
	Tue, 10 Sep 2024 10:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962630;
	bh=++va27bCCcjVsD4JjQWCe6g+KvPofa9wifQTfWjbPIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVmYhekJcsF4weo1epEyijz2yfyLiXJX4t5lgPETZ5ZsTXZ88r59fU3dBfHSgbT8T
	 nLkZGNcAld6l3WZl1Cjpbap+KfnpxiNadmNssKpJkSHtXTv4eH1AlKIEE5NKVvAfa4
	 kZCobT4jlHlcAp+qIUhwzq5Y67+LCp8ULuC9qlRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 099/121] binder: fix UAF caused by offsets overwrite
Date: Tue, 10 Sep 2024 11:32:54 +0200
Message-ID: <20240910092550.544505208@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 4df153652cc46545722879415937582028c18af5 upstream.

Binder objects are processed and copied individually into the target
buffer during transactions. Any raw data in-between these objects is
copied as well. However, this raw data copy lacks an out-of-bounds
check. If the raw data exceeds the data section size then the copy
overwrites the offsets section. This eventually triggers an error that
attempts to unwind the processed objects. However, at this point the
offsets used to index these objects are now corrupted.

Unwinding with corrupted offsets can result in decrements of arbitrary
nodes and lead to their premature release. Other users of such nodes are
left with a dangling pointer triggering a use-after-free. This issue is
made evident by the following KASAN report (trimmed):

  ==================================================================
  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0xe4/0x19c
  Write of size 4 at addr ffff47fc91598f04 by task binder-util/743

  CPU: 9 UID: 0 PID: 743 Comm: binder-util Not tainted 6.11.0-rc4 #1
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   _raw_spin_lock+0xe4/0x19c
   binder_free_buf+0x128/0x434
   binder_thread_write+0x8a4/0x3260
   binder_ioctl+0x18f0/0x258c
  [...]

  Allocated by task 743:
   __kmalloc_cache_noprof+0x110/0x270
   binder_new_node+0x50/0x700
   binder_transaction+0x413c/0x6da8
   binder_thread_write+0x978/0x3260
   binder_ioctl+0x18f0/0x258c
  [...]

  Freed by task 745:
   kfree+0xbc/0x208
   binder_thread_read+0x1c5c/0x37d4
   binder_ioctl+0x16d8/0x258c
  [...]
  ==================================================================

To avoid this issue, let's check that the raw data copy is within the
boundaries of the data section.

Fixes: 6d98eb95b450 ("binder: avoid potential data leakage when copying txn")
Cc: Todd Kjos <tkjos@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240822182353.2129600-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3534,6 +3534,7 @@ static void binder_transaction(struct bi
 		 */
 		copy_size = object_offset - user_offset;
 		if (copy_size && (user_offset > object_offset ||
+				object_offset > tr->data_size ||
 				binder_alloc_copy_user_to_buffer(
 					&target_proc->alloc,
 					t->buffer, user_offset,


