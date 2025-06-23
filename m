Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832E1E487;
	Mon, 23 Jun 2025 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684512; cv=none; b=NZ9nh5oRrhDuMXbVu+Jzs+rjmBFLsH81capyVCB5saWWbj/pyh8SIcWSJUurv3XilHOriemoUIDeXxqjvXBuzC8d8iazMhZ+qlMMqZ8luRw8ssiLXAwyjfhC7JqMYvVXR8Z5i+EtB/343PZeCDR22yLo53OzO3U1PM0x0QbPIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684512; c=relaxed/simple;
	bh=IOdKLNmgt9kE24Tc1VJbbV9Jf6cAOUdQfX3A00wziE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNudgXUVoe+VluBuHjqKSgJaiLtzoPTlJ/CbFJy8LchYCC4fkE/fiwp2TOCfb0gFHsmvJN9FT3oYtyUNbtUTvXRrzR2eFugVavv7kIXeVungsYB0iiEMTqiqpx/yhpBBizi5taVoMIYRunmzpugXbue7/GFN6OkMWf5c7eKtkhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt14YgYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt14YgYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE81C4CEEA;
	Mon, 23 Jun 2025 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684512;
	bh=IOdKLNmgt9kE24Tc1VJbbV9Jf6cAOUdQfX3A00wziE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt14YgYchjf5M2FssSrVrXqOCqsOOnsIk07AaaZqvZQTRIxdkCDjA7R7blNkQs3Sr
	 ExjVqTOOLmsXUedST3Bs91jWOCeiYWbTjA2MvFfGtH1NUN0avO9XY/4FpijuWtjd2x
	 qPc9IpSpq6UIQVDOQVqHu1XhHkgEDoT94uXVE0gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 097/592] block: use plug request list tail for one-shot backmerge attempt
Date: Mon, 23 Jun 2025 15:00:55 +0200
Message-ID: <20250623130702.584168208@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 961296e89dc3800e6a3abc3f5d5bb4192cf31e98 upstream.

Previously, the block layer stored the requests in the plug list in
LIFO order. For this reason, blk_attempt_plug_merge() would check
just the head entry for a back merge attempt, and abort after that
unless requests for multiple queues existed in the plug list. If more
than one request is present in the plug list, this makes the one-shot
back merging less useful than before, as it'll always fail to find a
quick merge candidate.

Use the tail entry for the one-shot merge attempt, which is the last
added request in the list. If that fails, abort immediately unless
there are multiple queues available. If multiple queues are available,
then scan the list. Ideally the latter scan would be a backwards scan
of the list, but as it currently stands, the plug list is singly linked
and hence this isn't easily feasible.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-block/20250611121626.7252-1-abuehaze@amazon.com/
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Fixes: e70c301faece ("block: don't reorder requests in blk_add_rq_to_plug")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1127,20 +1127,20 @@ bool blk_attempt_plug_merge(struct reque
 	if (!plug || rq_list_empty(&plug->mq_list))
 		return false;
 
-	rq_list_for_each(&plug->mq_list, rq) {
-		if (rq->q == q) {
-			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-			    BIO_MERGE_OK)
-				return true;
-			break;
-		}
+	rq = plug->mq_list.tail;
+	if (rq->q == q)
+		return blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			BIO_MERGE_OK;
+	else if (!plug->multiple_queues)
+		return false;
 
-		/*
-		 * Only keep iterating plug list for merges if we have multiple
-		 * queues
-		 */
-		if (!plug->multiple_queues)
-			break;
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q != q)
+			continue;
+		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+		    BIO_MERGE_OK)
+			return true;
+		break;
 	}
 	return false;
 }


