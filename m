Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0059B13B5B8;
	Tue, 18 Jun 2024 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715263; cv=none; b=S6cpTUmTYTilwU69ucmbP9jp3wIncB+BM+B8XuCdhA24dh+0yRMiG81FTi3p6VU3KNK+rJZIDEBV4eQ7LxacULTeqATGXbH+dlphtYfyF70hTcB3WCNM6Rms9K2txuOuRjETUcKO6aW8sCh6G4L+L9elhpa4v6wDf/MP6q4UakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715263; c=relaxed/simple;
	bh=KEJyMblAc+cl6Nsr2lPZ+XLJMFHi3dV5PThLqfg+9cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fijxVOAb0HMXtMSXyukxcCuJ267rS3p5oJb8bGpNImGjklYtCNVn72uyq4NW8iBm/S8uUarysrN4/ar6CkSWhuq8sBw45QmJA2u+rrYJ4JNv7fX7KpM3AKpSw3Okzn5v1FDwnt6Gd2Rx9fqVPLPffYKsZOoGd95lMSjrtSR13z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNFvJpGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNFvJpGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7859AC3277B;
	Tue, 18 Jun 2024 12:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715262;
	bh=KEJyMblAc+cl6Nsr2lPZ+XLJMFHi3dV5PThLqfg+9cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNFvJpGUbpImz0rPL0Aw2AlW5kIjLjiERq1X4L2Dwcbk45CLogyjDZ30mRcvHtK5u
	 TynGJduJp3or4PH/yB1wwcxXqifa7iovebNtlcJtHGqdUT/egyu/n2hgf8eSObct1g
	 +TR2c3+v4X5akPrKZ2ABHomTfZCcvDK1C5qwBK1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/770] Revert "fanotify: limit number of event merge attempts"
Date: Tue, 18 Jun 2024 14:31:43 +0200
Message-ID: <20240618123416.928520437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

Temporarily revert commit ad3ea16746cc ("fanotify: limit number of
event merge attempts") to enable subsequent upstream commits to
apply and build cleanly.

Stable-dep-of: 8988f11abb82 ("fanotify: reduce event objectid to 29-bit hash")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c3af99e94f1d1..1192c99536200 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -129,15 +129,11 @@ static bool fanotify_should_merge(struct fsnotify_event *old_fsn,
 	return false;
 }
 
-/* Limit event merges to limit CPU overhead per event */
-#define FANOTIFY_MAX_MERGE_EVENTS 128
-
 /* and the list better be locked by something too! */
 static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 {
 	struct fsnotify_event *test_event;
 	struct fanotify_event *new;
-	int i = 0;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 	new = FANOTIFY_E(event);
@@ -151,8 +147,6 @@ static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 		return 0;
 
 	list_for_each_entry_reverse(test_event, list, list) {
-		if (++i > FANOTIFY_MAX_MERGE_EVENTS)
-			break;
 		if (fanotify_should_merge(test_event, event)) {
 			FANOTIFY_E(test_event)->mask |= new->mask;
 			return 1;
-- 
2.43.0



