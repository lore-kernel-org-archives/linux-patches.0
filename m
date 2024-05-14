Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7403380BE3;
	Tue, 14 May 2024 11:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686685; cv=none; b=Le0SQKwIaKqOs02oR9kx+ZHxpEoJZybvK9ubpLOvH/w8Ugd7IcdpHMrk2si0SkiqRPrvTCUMx1+yIVEF1S5HQnTh8/wb8HkZBtEd3L/1InX5if3OTZQgTr7S1aFsfpFdo2ZOH2AiAB7dwDepKW2QasLYfutPJP6UdtO5GXMpKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686685; c=relaxed/simple;
	bh=+j9pXDls7pakNrT4GO32dsNezm1hMFpQNpvcrssrpNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XknjIG6ieb/pCP8DuSItJpbchJpbCrBDpPINd7FoeN54bja2q5v6jRZdTcoPEzqUv5j7x3uzKQvyshvUMgtqpDV/XS3bzVjYl0ibYwtx/St0OH6SBiOev1JshmtVsTDSmXxs51Rlt+GdgsXAuo7C//tJPT9LVIeSPj/Wwiffpng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ie3E7XOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ie3E7XOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE818C2BD10;
	Tue, 14 May 2024 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686685;
	bh=+j9pXDls7pakNrT4GO32dsNezm1hMFpQNpvcrssrpNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ie3E7XOFpJsyeZ0Rgq2kecpucA4u4wyaJidr8jZW8UEmc5I2oA6TONeo6agugiywD
	 wr+kqt/EufvUraczY4YfYlgy9jj62j8zx88NOgVrBzoWoAIiLh9e5oL2qebE2uUbw6
	 Yq6HFyD/lhIx5B6ZKbAnipH84t5nX3A7d/jYoO8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 224/236] net: fix out-of-bounds access in ops_init
Date: Tue, 14 May 2024 12:19:46 +0200
Message-ID: <20240514101028.861707359@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit a26ff37e624d12e28077e5b24d2b264f62764ad6 upstream.

net_alloc_generic is called by net_alloc, which is called without any
locking. It reads max_gen_ptrs, which is changed under pernet_ops_rwsem. It
is read twice, first to allocate an array, then to set s.len, which is
later used to limit the bounds of the array access.

It is possible that the array is allocated and another thread is
registering a new pernet ops, increments max_gen_ptrs, which is then used
to set s.len with a larger than allocated length for the variable array.

Fix it by reading max_gen_ptrs only once in net_alloc_generic. If
max_gen_ptrs is later incremented, it will be caught in net_assign_generic.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Fixes: 073862ba5d24 ("netns: fix net_alloc_generic()")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240502132006.3430840-1-cascardo@igalia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -68,12 +68,15 @@ DEFINE_COOKIE(net_cookie);
 
 static struct net_generic *net_alloc_generic(void)
 {
+	unsigned int gen_ptrs = READ_ONCE(max_gen_ptrs);
+	unsigned int generic_size;
 	struct net_generic *ng;
-	unsigned int generic_size = offsetof(struct net_generic, ptr[max_gen_ptrs]);
+
+	generic_size = offsetof(struct net_generic, ptr[gen_ptrs]);
 
 	ng = kzalloc(generic_size, GFP_KERNEL);
 	if (ng)
-		ng->s.len = max_gen_ptrs;
+		ng->s.len = gen_ptrs;
 
 	return ng;
 }
@@ -1217,7 +1220,11 @@ static int register_pernet_operations(st
 		if (error < 0)
 			return error;
 		*ops->id = error;
-		max_gen_ptrs = max(max_gen_ptrs, *ops->id + 1);
+		/* This does not require READ_ONCE as writers already hold
+		 * pernet_ops_rwsem. But WRITE_ONCE is needed to protect
+		 * net_alloc_generic.
+		 */
+		WRITE_ONCE(max_gen_ptrs, max(max_gen_ptrs, *ops->id + 1));
 	}
 	error = __register_pernet_operations(list, ops);
 	if (error) {


