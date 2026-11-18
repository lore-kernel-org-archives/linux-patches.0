Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020979;
	b=JdX1GtQ5vxG01X4Vi1cEJ5slkv9KHewsi33McaM8VBwdpOYvyjq1RyPMt0fVCcFrz9Up
	 NmyK1/yCJuJ1bNOmWCqe8ZRjnmWfy8n7ysQL9t2A36UPg5JyoxrOxMtR6jZ36b/F16Z+E
	 8A+8r+bTWkHtPf1B0XEIgZnyYygDQCWwvH/E0shpdA0TQkW5lNH67Pi6jdHFe/b3FNrba
	 acjbod85hK+zDoyUPd02AAGxV7Trw4GPJd6qKVppHsRzuN8aj7sGxGEZsZ9PvQz9XynjF
	 L8EQgp9EzyNi4UYfG+7F3ZPudduroOeCi0waXORi9nVD0QB2ruHkS4DrwKl/6dUZi3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4o14+HtPXkvdt2hG9b4FOOhoNZzQelSLgxqLC4U/sJg=;
	b=Y3p/zAu6LCd49F7d4F9IYPc+msnyYGavwUXkSHBO9spfkvT6JIzvYciLmOCD6+vKwV/2
	 R3euDGjVLNV2f7TkxB9qSNsl3aYDOp/e7qS5NEPsCdpmGNBZLn5w1ALflA8/fG7K/DQJy
	 jswyGNuP9DHD7M9IhOGX/ZSUnej+yYYZMB9Hc1qGLqzDaH7Rf6WagnT9Pww8uB0EOmaDX
	 lWEzCFBup8uL5pN9EGBBaECOmielUATQHpb8KIwgAsdZH6y4r6dFhojG1YWV+fyRqNIXG
	 OvHE235zHX4TmwCfj19N1AkrporTTzWcJf6VAvOTBv4blh3Pi6zlNgphBYxPgOVWDUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JabMup2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B285606A320;
	Wed, 18 Nov 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JabMup2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E7F1F000C5;
	Wed, 18 Nov 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020979;
	bh=4o14+HtPXkvdt2hG9b4FOOhoNZzQelSLgxqLC4U/sJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JabMup2gorFAv70W4KPMjOnxwEDpowvrUqIlj9AHrfBUdJGeyVfCGVfAcYn1at1UO
	 jaKkBiConK5DrHUkidam0HHO6Mkna9ovacMg76cPQz6KicnYrpUUF0W4mgtlcUVw4O
	 5/fRLD6dWYVSi9cPpPN0x604FFl3rkeNfNvmgVTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2104/2651] bpf: Link the first element after its storage is published
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150401.720612090@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit bd897919e4dc18bbfdfc58b696fb948b8bc2c79a ]

bpf_local_storage_alloc() links the first element of a new storage to the
bucket of its map, and then publishes the storage in the owner with
cmpxchg().  If another cpu has been faster, the element is taken out of
the bucket again and is freed together with the storage.

In between the iterator over a sk_storage map can find the element.  It
stays linked to a storage that points to the socket, but the socket knows
nothing of that storage: bpf_sk_storage_free() neither unlinks the element
nor waits for anybody who uses the storage.  So nothing tells the iterator
that the socket has gone away.

Three cpus that create the first storage of a new AF_UNIX socket at the
same time, and a fourth that reads the iterator, are enough: in 20 seconds
its program was shown some 4000 elements of storages that had lost.  If the
socket is closed in time, the program is handed a freed socket.

Link the element once the storage is published.  Both happens under the
lock of the bucket, which holds off whoever finds the element through the
owner and wants to unlink it.

Fixes: c69d2ddb2072 ("bpf: Using rcu_read_lock for bpf_sk_storage_map iterator")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-17-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index a4e6bb97ddcc7..cc80838f15584 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -507,8 +507,6 @@ int bpf_local_storage_alloc(void *owner,
 	if (err)
 		goto uncharge;
 
-	bpf_selem_link_map_nolock(b, first_selem);
-
 	owner_storage_ptr =
 		(struct bpf_local_storage **)owner_storage(smap, owner);
 	/* Publish storage to the owner.
@@ -523,11 +521,17 @@ int bpf_local_storage_alloc(void *owner,
 	 */
 	prev_storage = cmpxchg(owner_storage_ptr, NULL, storage);
 	if (unlikely(prev_storage)) {
-		bpf_selem_unlink_map_nolock(first_selem);
 		raw_res_spin_unlock_irqrestore(&b->lock, flags);
 		err = -EAGAIN;
 		goto uncharge;
 	}
+	/*
+	 * Not before the storage is published: the owner does not wait for
+	 * users of a storage that it knows nothing of, so that nobody may find
+	 * such a storage through the map. b->lock holds off those who find
+	 * first_selem through the owner and want to unlink it.
+	 */
+	bpf_selem_link_map_nolock(b, first_selem);
 	raw_res_spin_unlock_irqrestore(&b->lock, flags);
 
 	return 0;
-- 
2.53.0



