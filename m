Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018446;
	b=H79mf397rXkTBQeONR6Ypvdr19ksDRSELsYw1Lc1HgI7+oZPH1guP6JKQNf/92IMoLOX
	 0vse46PK9eOaY2a295ZJB+dWjh4e9qwTYlJD+OeS9CmhLGy/hoj6GLA2xQES4ZHoqA5AW
	 WsIYKHWk4nNcgBZ/gRta2NYWqyvdVpPyO7Jzp94u6aP6Y7k7FtwT9gsbSerK8CrG/Z7Fv
	 gF9UCIC4xGrVpYP7rcfRgqNV+sqpk/CwYEN3AP8eb9mH6RFOny5T5mXxaxhrUTkSzvjW9
	 UckA+X1p/sUZen4o+afixaKs5inKLbr6XqHc0pYTf52zFjIC0TZ9jKJYc+R5C0e4ehQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nO/LryqYYo2VwoZiFP4RaAWR8x6ze2Yog3/ornGxPjU=;
	b=yRCJ6kIZqA+i8gru2lzQ841xn2MOUnXUxzW7MdtpNsH+Rqp/nOHzTpgzdO6+zcolMlZS
	 KB1GhjwRBkwCf7a29LrN6TMI8pLN2iRuxk9i/O4Qs6iN55p6JtIIjRcMOORGSXJObfKiV
	 Mld2fi0m0bCrPJlXW1NeBkmhV4beo3ObleYAaKy87AQIt7w5PeGjiIvzFhOnkEQaLQ5rO
	 Ubs7P8GmmyZ+w7vYzyIbswf10QxR4MepV7/k1OkXvoipgn84G9/kZv/Cd+U0wGRo1HIAf
	 QPcb9a7jOQ6eLYtLV56YpGXzTn5gIxBRNfvbrVxotG1MevohHGU5ztLvvFDCskF+PvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMJog231;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2544606A320;
	Wed, 18 Nov 2026 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMJog231
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9341F000C4;
	Wed, 18 Nov 2026 16:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018446;
	bh=nO/LryqYYo2VwoZiFP4RaAWR8x6ze2Yog3/ornGxPjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMJog231jOADc2YkaJu74Dkt/Sr68lQxMAEyNs6z0cVQtmMS6ErZpLs6GKJn0KEr+
	 x2LhS0u2xn5l+z7/lWj+fNegpemZ62679BRoyBTZdhIT1lQo2syoFpJaFhy0qYIj/W
	 pAwBMk7u7aMwDn8wmxm9G0Q0L+2hp7jnyxiiKV38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1243/2651] md/raid5: protect big_stripe_tree lookup with RCU
Date: Wed, 18 Nov 2026 15:41:23 +0100
Message-ID: <20261118150332.745281060@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 73b0df929494522acf9ccc8dafea4f721166965b ]

big_stripe_tree is updated under tree_lock, and deleted radix-tree
nodes are freed after an RCU grace period.  r5c_big_stripe_cached()
used to run under an RCU read-side critical section, but that protection
was removed together with unrelated rdev lookup protection.

The lookup can now be preempted while walking the tree, allowing a
concurrent deletion and grace period to complete before the walk
resumes.  Protect the lookup locally with rcu_read_lock().  Only the
presence of the entry is used after unlocking.

Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from conf")
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Link: https://patch.msgid.link/179070265341.12871.12495446593114993799.idr-bug-88@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2600cb5ac393a..7d5427f063f27 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2970,7 +2970,9 @@ bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 		return false;
 
 	tree_index = r5c_tree_index(conf, sect);
+	rcu_read_lock();
 	slot = radix_tree_lookup(&log->big_stripe_tree, tree_index);
+	rcu_read_unlock();
 	return slot != NULL;
 }
 
-- 
2.53.0



