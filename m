Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020900;
	b=rcQAQr15cMHPiLxLl/r2mNgcuA8eVZyIunzjUPI5eitx+l9OIfMPPzAzBtNImo2YFbTD
	 LfEomlRw3RZHpO68R7HqmyNe06Lfe5XpqzRwnt9X8jfghNmopKtuBwKt/lQLJnHgSMlnc
	 hiczkhzIkH2uWWBGxGkdn+jEgNnEeKQwuXsNPGWIwHJs+XeVBouM564TgAB8xljQtvWjA
	 5P33hjgHNh+an7xbb7RcRcBsDYPbym+E/Rd1J/ZvcBAFRCDKtKE+VzoXiNWdikUM/xGG5
	 OLew60IrgHIopMHKA2vA60AimDXzT2AeoU0dSB34LZJrztaVlTJ5FRbioU7IKpb5zww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBh2aucmrQEG9/ADDRMYvVTcahw2wQjzFjFCZbWc2WQ=;
	b=dF59AJ5/fURzAKYEp0+eYt2Nfsh8L5VmqZyGIt5uEio9W8+jct3qM8vWpzXjgg7T7L4A
	 6qh9VLdBzkuW6o9N3bJenYpYRF0Np3SD6xTRrZNPFA8P79KjkCU8kwHu1J10Dv0JxqzzA
	 u3cmQMeTYz6oVOjvgKnfoKiHjxx5JDuxuYWhFFp4b+hO72EEZdFuSMvH4l0yxfcW2EnjB
	 EWOyisYYuIk9KzYzQz8sb1E45r2RX06zbpfL2I22P9B/EzmiQW6s37ukTlQqyArzknXfn
	 wpJ6wEliZiMs/ftY4svbG+WYnGYMKFDoDTZKMPhL8RRI7AiA24sH0sTqsL0Xu6qG+4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O01jMKXL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E2E606A332;
	Wed, 18 Nov 2026 16:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O01jMKXL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0401F000C4;
	Wed, 18 Nov 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020900;
	bh=JBh2aucmrQEG9/ADDRMYvVTcahw2wQjzFjFCZbWc2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O01jMKXLt2xUorPI6AMebkJgPnB0j8QpEYwm7INDy1gkaNRcjoBMRsn/8PesAhQ0i
	 A6vn+s94mjGP/Do+i8Zbk7QCFGt6D+wJXYYYnPvCd+u2lktUM9ejmfvBA9R2VECPNV
	 SQsh5Pl9zMCnaOMV9Wp3BF9UTRF41zpeqbi9HrxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2116/2651] bpf: Free what map_free() unlinks for sleepable readers
Date: Wed, 18 Nov 2026 15:55:56 +0100
Message-ID: <20261118150402.113241460@linuxfoundation.org>
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

[ Upstream commit 5bdd61e98da5468140aff5b5abc0e8544deaf2ee ]

bpf_local_storage_map_free() takes the elements of the map off the lists
of their owners, which are alive, and frees them, and the storage of an
owner with its last element, behind a plain RCU grace period.  Nobody uses
the map any more, but the other maps of these owners are in use.  A
sleepable program calls the get and delete helpers under
rcu_read_lock_trace() only.  While it walks the list of an owner for its
own map, or is about to lock the storage, the element it stands on, or the
storage, can be freed under it.

Whatever else takes an element off the list of a live owner frees it
behind an RCU Tasks Trace grace period, which implies a plain one.  Do so
in bpf_local_storage_map_free() as well.  It waits for these callbacks
before it frees the map.

This does not help a sleepable program that hands an owner to the helpers
which nobody holds, and which may be gone by then.

Fixes: dcf456c9a095 ("bpf: Fix usage of trace RCU in local storage.")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-31-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index cc80838f15584..4f471e0620d2c 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -429,13 +429,17 @@ static void bpf_selem_unlink_nofail(struct bpf_local_storage_elem *selem,
 	 * then freed after an RCU grace period. However, if destroy() and map_free() are
 	 * racing or rqspinlock returns errors in unlikely situations (unlink != 2), free
 	 * the selem only after both map_free() and destroy() see the selem.
+	 *
+	 * The owner that map_free() takes an selem from is alive: sleepable code, which
+	 * is in no RCU read side critical section, may be walking its list for another
+	 * map.
 	 */
 	if (unlink == 2 ||
 	    atomic_cmpxchg(&selem->state, SELEM_UNLINKED, SELEM_TOFREE) == SELEM_UNLINKED)
-		bpf_selem_free(selem, true);
+		bpf_selem_free(selem, !in_map_free);
 
 	if (free_storage)
-		bpf_local_storage_free(local_storage, true);
+		bpf_local_storage_free(local_storage, !in_map_free);
 }
 
 void __bpf_local_storage_insert_cache(struct bpf_local_storage *local_storage,
-- 
2.53.0



