Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030730;
	b=T/JddgGJes4ibvvqy2H7rN9lbXxW3wbJHb/h4jNsSSLOF5/SNGdu+WMuzwkVCyuEg/UG
	 9fibepw/Kh09wp8wXU5G0BbRYSFBLPl/o6q6KY2ts0fadwIhF50nVFw9ScFd+SdqLqp6I
	 l2/CNkEaFbTe4ROt0X56g/ZtlWX42DNXmPsxlCNkpO1CypuSuLv+TA3kAbdJvlmyGTLcm
	 7/v/i8Xrk9qcHZ4pyHNDp1oy4wOxMzxJqc7h5FsG1t84QaZ/MlyM780CoNUwzIgPdISvx
	 T/yCPmEGRMkwq9aDK5cI9/rKlUvT48Iun2gHJYNZgLu+dlwaB/A02FVdu1V9BkqjGJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=msTH7r33pytRbLKta4EPRgI3mhJFcylOJs33471mxlM=;
	b=QdqKnBdr0j3rnE7xEDEgnMBrtiHXLn3EdEZZvOxw4JImEluaclm+EZX7wNurhzODvPSf
	 GBsTGVtG8ax5VOTfRggm853uTx/wlgq9kwMv67EhGwf0OGTA1P+DXPnNd5g2iHefybxml
	 LCA9kzL7Mnh8ocTVj7r595sS2oV43krjn+1BcnPbY7qke+aez/8BtBI9rl8PE1VrbJjaa
	 HlWjA7SdpbkNe2VthwUIYlfjHF27zex7Maj9Xp2Y/cUxCy9oCxFgDUp7b+7iKyfUujhf5
	 GAGakMYCIH54QiKAInZlmhzQr83pOtlxpwANTnwP8x2NyFHuiaeMIsD6hXuK5eJvEdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXrmNsfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3548606A333;
	Wed, 18 Nov 2026 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXrmNsfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391FA1F000C5;
	Wed, 18 Nov 2026 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030730;
	bh=msTH7r33pytRbLKta4EPRgI3mhJFcylOJs33471mxlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXrmNsfEVpi9Q3Ello0OBvLYFX8lU0LUSXqWVbSI6piR6ZVNKN2SplxIY1XfENW0M
	 2P4i8ToqnV/J//fJ8WtSdnX8vdgazI0jn7PYcRCBqPzKSfmK1JQWc4aa1hl42FF5+l
	 6OlT9qijtmA9gZraE+5VtklKRgJQc6MSjgW8+H3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0808/1756] md/raid5: protect big_stripe_tree lookup with RCU
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150041.801837880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f06dd27290e7..668a54fb86e6a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2971,7 +2971,9 @@ bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 		return false;
 
 	tree_index = r5c_tree_index(conf, sect);
+	rcu_read_lock();
 	slot = radix_tree_lookup(&log->big_stripe_tree, tree_index);
+	rcu_read_unlock();
 	return slot != NULL;
 }
 
-- 
2.53.0



