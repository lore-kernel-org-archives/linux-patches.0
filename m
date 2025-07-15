Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F9A2E3AE2;
	Tue, 15 Jul 2025 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587190; cv=none; b=KXZvsGZOqy+/xga9Q3u2GFIaelYzJ7hfaWLzU6AF+RHM00FKfHIL+hc6Jn3URB2bRHJej6xS5yNBAo8NGHSUEJn2+1yH/6Jmb3K/tWwUTu67tcgAVbJooLaqzhXIf/ZobJ8rPsOw7k66709w+ooHvjgOkFDECNiLG/US4ryBMOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587190; c=relaxed/simple;
	bh=MJ8Gcj9K7Ihcdktdk19IUN9uaLsT7mhxK+OnlQN0Qh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az6y8fxPYwdoC244cCrWUNCw56N7HKzGCxy5qAtLsGQaEMtNgBvd56DCOWqy77yFc3sJ6Wo1759SThJsWAKMruObkjdxwG4zEDA7d8iiJw+hHmYBbidWDElp+LX2nl7N/BWvzBuzVuoI1nqBKLJY+gJLQ+hL+AHAq0V+YL3BvuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKnE9Va5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKnE9Va5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8538BC4CEE3;
	Tue, 15 Jul 2025 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587189;
	bh=MJ8Gcj9K7Ihcdktdk19IUN9uaLsT7mhxK+OnlQN0Qh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKnE9Va5HjnAh/OojKLtLCjGdZmNzLCbZdhfneJ4Ofv5aNu+ooAp5wlzM6MtH2ZnK
	 9tBoY1B+Adc5LcPFCL9MAc5bFUpsmk1zxo6a9/8z+FIiJkoQjQd+J2KGYOVXRMPqXD
	 9Wih+Ltdlo3dxkHGJkzQ1JJMjpmNaOG9OMQ1b05c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.15 189/192] selftests/bpf: adapt one more case in test_lru_map to the new target_free
Date: Tue, 15 Jul 2025 15:14:44 +0200
Message-ID: <20250715130822.508776317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 5e9388f7984a9cc7e659a105113f6ccf0aebedd0 upstream.

The below commit that updated BPF_MAP_TYPE_LRU_HASH free target,
also updated tools/testing/selftests/bpf/test_lru_map to match.

But that missed one case that passes with 4 cores, but fails at
higher cpu counts.

Update test_lru_sanity3 to also adjust its expectation of target_free.

This time tested with 1, 4, 16, 64 and 384 cpu count.

Fixes: d4adf1c9ee77 ("bpf: Adjust free target to avoid global starvation of LRU map")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20250625210412.2732970-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_lru_map.c |   33 +++++++++++++++--------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -138,6 +138,12 @@ static int sched_next_online(int pid, in
 	return ret;
 }
 
+/* Derive target_free from map_size, same as bpf_common_lru_populate */
+static unsigned int __tgt_size(unsigned int map_size)
+{
+	return (map_size / nr_cpus) / 2;
+}
+
 /* Inverse of how bpf_common_lru_populate derives target_free from map_size. */
 static unsigned int __map_size(unsigned int tgt_free)
 {
@@ -410,12 +416,12 @@ static void test_lru_sanity2(int map_typ
 	printf("Pass\n");
 }
 
-/* Size of the LRU map is 2*tgt_free
- * It is to test the active/inactive list rotation
- * Insert 1 to 2*tgt_free (+2*tgt_free keys)
- * Lookup key 1 to tgt_free*3/2
- * Add 1+2*tgt_free to tgt_free*5/2 (+tgt_free/2 keys)
- *  => key 1+tgt_free*3/2 to 2*tgt_free are removed from LRU
+/* Test the active/inactive list rotation
+ *
+ * Fill the whole map, deplete the free list.
+ * Reference all except the last lru->target_free elements.
+ * Insert lru->target_free new elements. This triggers one shrink.
+ * Verify that the non-referenced elements are replaced.
  */
 static void test_lru_sanity3(int map_type, int map_flags, unsigned int tgt_free)
 {
@@ -434,8 +440,7 @@ static void test_lru_sanity3(int map_typ
 
 	assert(sched_next_online(0, &next_cpu) != -1);
 
-	batch_size = tgt_free / 2;
-	assert(batch_size * 2 == tgt_free);
+	batch_size = __tgt_size(tgt_free);
 
 	map_size = tgt_free * 2;
 	lru_map_fd = create_map(map_type, map_flags, map_size);
@@ -446,23 +451,21 @@ static void test_lru_sanity3(int map_typ
 
 	value[0] = 1234;
 
-	/* Insert 1 to 2*tgt_free (+2*tgt_free keys) */
-	end_key = 1 + (2 * tgt_free);
+	/* Fill the map */
+	end_key = 1 + map_size;
 	for (key = 1; key < end_key; key++)
 		assert(!bpf_map_update_elem(lru_map_fd, &key, value,
 					    BPF_NOEXIST));
 
-	/* Lookup key 1 to tgt_free*3/2 */
-	end_key = tgt_free + batch_size;
+	/* Reference all but the last batch_size */
+	end_key = 1 + map_size - batch_size;
 	for (key = 1; key < end_key; key++) {
 		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 		assert(!bpf_map_update_elem(expected_map_fd, &key, value,
 					    BPF_NOEXIST));
 	}
 
-	/* Add 1+2*tgt_free to tgt_free*5/2
-	 * (+tgt_free/2 keys)
-	 */
+	/* Insert new batch_size: replaces the non-referenced elements */
 	key = 2 * tgt_free + 1;
 	end_key = key + batch_size;
 	for (; key < end_key; key++) {


