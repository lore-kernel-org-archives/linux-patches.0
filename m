Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726B2153FC;
	Thu, 12 Dec 2024 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017574; cv=none; b=qzjrjOITJLu5Ji1tq1FJRBF+yeneZ1AwYUcE4+EBOVts48onyFz9MP/gvhZNbHqHuxpohLAwzSYT40IKeBqLOqLWsBatX7B3D5uLe/k7mgRrHMz0tRNRKU8fe1Kwdb1pFI+SGOLtSSAyPUoEucuJ/mx1nV+9Z3HbLOmTQmkoHS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017574; c=relaxed/simple;
	bh=RXk/DCPR5qRv5KPeOrDDQrQe/ub5nxb4g+on17t9dgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTSrUqE8xP6CNL3tRB43YmWN/KhkKDjHsI2TcHwM7OK2b4ZlOZO5ZANk9/5MgW0vG49Y8AGtTMk80DkReRnPwXBuTeJ6Pd2nf8ykVMcA0Ye1lIv7bdr31YVOQh/Y8sWSJpPJ665DUX0BcC3FzUaPaZKpaQ+N8AYVFUmCazS0unE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lzqvfp8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lzqvfp8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398A9C4CECE;
	Thu, 12 Dec 2024 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017574;
	bh=RXk/DCPR5qRv5KPeOrDDQrQe/ub5nxb4g+on17t9dgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lzqvfp8VH6zjq8Qv9b/9LX/3IQ3WA3+lH/mLLa7GHIqMWesY3Bbadw+Rn4RHcADEq
	 XXIPq76L985/n4lDmWj40O1uxOXB8RIoEnS8RMtfXdW6c5f3lNlCGU0tibPP0B4Hkk
	 55AvRZUqKs41eFhA79UahFucjVUi3IU3h5bC/xiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Fasnacht <laurent.fasnacht@proton.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/356] netfilter: nft_set_hash: skip duplicated elements pending gc run
Date: Thu, 12 Dec 2024 15:56:11 +0100
Message-ID: <20241212144246.686214991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7ffc7481153bbabf3332c6a19b289730c7e1edf5 ]

rhashtable does not provide stable walk, duplicated elements are
possible in case of resizing. I considered that checking for errors when
calling rhashtable_walk_next() was sufficient to detect the resizing.
However, rhashtable_walk_next() returns -EAGAIN only at the end of the
iteration, which is too late, because a gc work containing duplicated
elements could have been already scheduled for removal to the worker.

Add a u32 gc worker sequence number per set, bump it on every workqueue
run. Annotate gc worker sequence number on the expired element. Use it
to skip those already seen in this gc workqueue run.

Note that this new field is never reset in case gc transaction fails, so
next gc worker run on the expired element overrides it. Wraparound of gc
worker sequence number should not be an issue with stale gc worker
sequence number in the element, that would just postpone the element
removal in one gc run.

Note that it is not possible to use flags to annotate that element is
pending gc run to detect duplicates, given that gc transaction can be
invalidated in case of update from the control plane, therefore, not
allowing to clear such flag.

On x86_64, pahole reports no changes in the size of nft_rhash_elem.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Reported-by: Laurent Fasnacht <laurent.fasnacht@proton.ch>
Tested-by: Laurent Fasnacht <laurent.fasnacht@proton.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 3a96d4a77a228..cc1ae18485faf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -24,10 +24,12 @@
 struct nft_rhash {
 	struct rhashtable		ht;
 	struct delayed_work		gc_work;
+	u32				wq_gc_seq;
 };
 
 struct nft_rhash_elem {
 	struct rhash_head		node;
+	u32				wq_gc_seq;
 	struct nft_set_ext		ext;
 };
 
@@ -331,6 +333,10 @@ static void nft_rhash_gc(struct work_struct *work)
 	if (!gc)
 		goto done;
 
+	/* Elements never collected use a zero gc worker sequence number. */
+	if (unlikely(++priv->wq_gc_seq == 0))
+		priv->wq_gc_seq++;
+
 	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
 
@@ -348,6 +354,14 @@ static void nft_rhash_gc(struct work_struct *work)
 			goto try_later;
 		}
 
+		/* rhashtable walk is unstable, already seen in this gc run?
+		 * Then, skip this element. In case of (unlikely) sequence
+		 * wraparound and stale element wq_gc_seq, next gc run will
+		 * just find this expired element.
+		 */
+		if (he->wq_gc_seq == priv->wq_gc_seq)
+			continue;
+
 		if (nft_set_elem_is_dead(&he->ext))
 			goto dead_elem;
 
@@ -364,6 +378,8 @@ static void nft_rhash_gc(struct work_struct *work)
 		if (!gc)
 			goto try_later;
 
+		/* annotate gc sequence for this attempt. */
+		he->wq_gc_seq = priv->wq_gc_seq;
 		nft_trans_gc_elem_add(gc, he);
 	}
 
-- 
2.43.0



