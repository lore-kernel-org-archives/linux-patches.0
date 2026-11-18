Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020897;
	b=dAJ8yWYxCtimFZOZqr2j1fT1BRgdzeAuOQ197jlpr6CBcy/I+fIWwgp7IAkNe7gA6Nlp
	 mjCoXCapkQNMnH4sBHfuGEnZthe38Ahu01WQ8XrjiwkQLDe1FDspS9EZ0HQcUknNicXXy
	 kvcCfnUI//IiUe6YMhGnZ1/4+tTCBx+d+vHR2oqOM3yQHb/CXPFtfVbP2WJXOADkP+Ne7
	 CMUi67ZCZsBT3yCKeGugjT2NSa5Ms4i35cxb/CAFlgJ0gT6A/1Yp8QOGY6uk7lKd8yCMd
	 ECitTyyerjVVgBMMvPfNULQOB29KLH1NV9r9nzDKwlrAbudSXEmH0RdTM/4b6jEkqrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=meMIs1bzHno3YHddBZCDT1SQI3LqQDCL/Y38pgub95w=;
	b=x0NPoNWMtR2nD6ZMFgOE+wIGPGcjqDsq5ILtkCrHj2LMbgQdot+jzw8CJN89NKqmJuHj
	 PeF/UJwb6Mq6KqnrbF7ZwMnTyTPL30GfkCkTpTVJ1d+wH43JJ2L2VIP6XbkaxNGaTXfp3
	 JP0T3tyEPVpZR8laXHmQ4XFzUQni7haGOU9hGWM6wqb2JeFmcicncmgirl0xlU3/bcimK
	 hGZMm1xNvC7qSTCo6Qdj5zN7Kds+z4S0lU2JiZLSCSFPNqSzwiy9FuqYv1aoK0sDr5Jow
	 bJFY5NQS8i8hrNEJyLObZQKG4L8shjx/eELLJpJUoJL7I7z1HkNspuoPKzOa2M4vD8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvmTj+Qq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D465606A332;
	Wed, 18 Nov 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvmTj+Qq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0205B1F000C4;
	Wed, 18 Nov 2026 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020897;
	bh=meMIs1bzHno3YHddBZCDT1SQI3LqQDCL/Y38pgub95w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvmTj+QqY8L91JmML3SZElSzdzwxYZjY6N0UYggMFL5qYhU+3y7zS7ru5pjqjWhwj
	 jiwh8fRwGGmEwSIeDBqYpRjJYS3uRL7hjHi2q47s0uxl7kpgN1mlUPqS+3dFJpn3gS
	 Oyb9jlbJj90mEy1+ZYrCWcJRfrfKx4s97Nd+/bZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2098/2651] bpf: Dont saturate owner_refcnt on the last unpin
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150401.526321427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 30a140c9d479974021f5c3eecb64415c96419c3f ]

bpf_local_storage_map_free() pins the owner with refcount_inc_not_zero()
while it uncharges an element.  The pin counts when
bpf_local_storage_destroy() could not get local_storage->lock: destroy()
then goes on, drops the owner's reference and spins until the count is
zero.  So the pin is the last reference whenever it is needed, and
refcount_dec() takes that for a bug: it warns "decrement hit 0; leaking
memory" and saturates the count.  Unless destroy() happens to read the
count between the two stores it spins for ever, under rcu_read_lock().

Drop the pin with refcount_dec_and_test().

Fixes: 5d800f87d0a5 ("bpf: Support lockless unlink when freeing map or local storage")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-11-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_local_storage.h | 13 +++++++++++++
 kernel/bpf/bpf_local_storage.c    |  6 +++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_storage.h
index 9e4f5c45c974d..6c643ac510799 100644
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -104,6 +104,19 @@ struct bpf_local_storage {
 	refcount_t owner_refcnt;/* Used to pin owner when map_free is uncharging */
 };
 
+/*
+ * Drop a reference got by refcount_inc_not_zero(&local_storage->owner_refcnt).
+ * bpf_local_storage_destroy() may have dropped the owner's reference meanwhile
+ * and wait for the count to reach zero, so this one can be the last.
+ */
+static inline void
+bpf_local_storage_unpin_owner(struct bpf_local_storage *local_storage)
+{
+	bool last __maybe_unused;
+
+	last = refcount_dec_and_test(&local_storage->owner_refcnt);
+}
+
 /* U16_MAX is much more than enough for sk local storage
  * considering a tcp_sock is ~2k.
  */
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 6fc6a4b672b55..a4e6bb97ddcc7 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -199,7 +199,7 @@ static void bpf_selem_unlink_storage_nolock_misc(struct bpf_local_storage_elem *
 	}
 
 	if (pin_owner)
-		refcount_dec(&local_storage->owner_refcnt);
+		bpf_local_storage_unpin_owner(local_storage);
 }
 
 /* local_storage->lock must be held and selem->local_storage == local_storage.
@@ -750,8 +750,8 @@ u32 bpf_local_storage_destroy(struct bpf_local_storage *local_storage)
 		while (refcount_read(&local_storage->owner_refcnt))
 			cpu_relax();
 		/*
-		 * Paired with refcount_dec() in bpf_selem_unlink_nofail()
-		 * to make sure destroy() sees the correct local_storage->mem_charge.
+		 * Paired with bpf_local_storage_unpin_owner() to make sure
+		 * destroy() sees the correct local_storage->mem_charge.
 		 */
 		smp_mb();
 	}
-- 
2.53.0



