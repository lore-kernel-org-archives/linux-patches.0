Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3703314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301180; cv=none; b=uO/aKv7vgcN60F2oIGEkT0iJ54/2XSq9LK1XpBu8fnQo+m3979a6wIcI1H8JJufrQSQ8GvEv1+n98YIAUe3qC7DOmVDEvpWEHKgMqUBceYfSIQau09HWu/DVV8qDMid9NoxhxTuhNPkNDsHBpFd5UT/xoOWUab9eEfkO2zuFaU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301180; c=relaxed/simple;
	bh=ymW2V39mAB1TFiYSumXS52F7+Do55tDmNccl3Rh/x7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9GsuevF20qwxO+RDSoxyVD92uMXis1WlMXo0LD31FuZP09iOJDV8ltL+yg2R3gpmvq5FsxLFOhVz2WR/srGh0h7WiYmxyZzX1NzoTV9CC9RuHzwbMrTjYvXrP8G+MCe17WjgoCibEB0DlzBCi/c4UPWLkzgzPTcsSxloAJ/B9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mneoDhl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mneoDhl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33391C19423;
	Sat, 28 Feb 2026 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301179;
	bh=ymW2V39mAB1TFiYSumXS52F7+Do55tDmNccl3Rh/x7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mneoDhl8HeDr7x4b7VS6PkJlKBvCleU9oA6TASHLi/wJ/TGGSy28/hQ+0Tb6o3ki4
	 pcLFMEfXqu/+SYCIg78oc2T1ZCERAgSe0/xl8RfUJIyo5Daa+YWry76YkHNONJbz3H
	 WPlIOc6MFolEn3oq2lt9fNPrrqWV+kWus+rARCkI1mskRdIdYOpZ5h1IxdVXZjaOEs
	 aI2QASnbazIuVdDsTsj+RerZxKFXKgoDMXY1XDTiREK6LZXR3gaELIxJA1/LUcifGU
	 ug3IqbonpslciobvCY52iBwHuLgsrfOIEbAAsHPcG20i2hjRWHWLFR74uwVzSN18nX
	 OZemsHle3rWow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/752] binder: don't use %pK through printk
Date: Sat, 28 Feb 2026 12:40:59 -0500
Message-ID: <20260228174750.1542406-348-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 56d21267663bad91e8b10121224ec46366a7937e ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log. Since commit ad67b74d2469 ("printk: hash
addresses printed with %p") the regular %p has been improved to avoid
this issue. Furthermore, restricted pointers ("%pK") were never meant
to be used through printk(). They can still unintentionally leak raw
pointers or acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

There are still a few users of %pK left, but these use it through
seq_file, for which its usage is safe.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260107-restricted-pointers-binder-v1-1-181018bf3812@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c       | 2 +-
 drivers/android/binder_alloc.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 8e2989fb56a71..a6b3bfe0d9b81 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4523,7 +4523,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %pK\n",
+				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %p\n",
 				     proc->pid, thread->pid, (u64)cookie,
 				     death);
 			if (death == NULL) {
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 979c96b74cad3..d5ed64543bbf4 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -81,7 +81,7 @@ static void binder_insert_free_buffer(struct binder_alloc *alloc,
 	new_buffer_size = binder_alloc_buffer_size(alloc, new_buffer);
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %pK\n",
+		     "%d: add free buffer, size %zd, at %p\n",
 		      alloc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -572,7 +572,7 @@ static struct binder_buffer *binder_alloc_new_buf_locked(
 	}
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
 		      alloc->pid, size, buffer, buffer_size);
 
 	/*
@@ -748,7 +748,7 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
 		ALIGN(buffer->extra_buffers_size, sizeof(void *));
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
 		      alloc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
-- 
2.51.0

