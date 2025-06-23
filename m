Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430C22173D;
	Mon, 23 Jun 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714040; cv=none; b=kPf+eG3rhfUWu5FLUfSLogUTEtffaYPI7S4X3Mberz0hSRJY2TeAn3BztLf9Psfn+zyiaOD8jRUqlEF/FE2f2PFtYqFjI8+9EuTY7rWmF1JgtSAmmsMqP7UW4uIgSS6xNX5A0Fe/P2EMH7ZplC8hYdVKLADqJmHBa5RB7itM3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714040; c=relaxed/simple;
	bh=8bOe9lXqL/UoMxgZG8qAwbpMsxCjFqcjDoRXwqu5vXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzZZZHj9oHr7VqdjaSSTRNcGtEod3URKDjSCebvohCv1JTBdwAR7BASkTVUVLuU/8PdRfK00DapZk4JyF4jaMm7Xe2sQtvAVItNTfq9b7INqDnhBo45ysxbxfle+Yvi8GNbWsJpFRs8i6I+67/LF+96CHmTJtXC6f6ni4/+PpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKgyEp1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKgyEp1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037A2C4CEEA;
	Mon, 23 Jun 2025 21:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714040;
	bh=8bOe9lXqL/UoMxgZG8qAwbpMsxCjFqcjDoRXwqu5vXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKgyEp1xsBPmj3SlMn97cuRqYoD/2xh17lDnjwxsbp5uYY1o4RUte+qKOV1rduXdk
	 M4bsPeCAKv98lhVy32cA95G7IkLA50Xw/ScjVv6Q0288r3fqfb1AQRBsE5Ni4vAIlK
	 c9wjfjSWtncYX8wUPfubmlrwBNk93piLeAbHdNl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 077/414] block: use plug request list tail for one-shot backmerge attempt
Date: Mon, 23 Jun 2025 15:03:34 +0200
Message-ID: <20250623130644.006124248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1180,20 +1180,20 @@ bool blk_attempt_plug_merge(struct reque
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


