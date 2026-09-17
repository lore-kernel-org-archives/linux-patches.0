Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B96D4E323F;
	Thu, 17 Sep 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660716; cv=none; b=ChMy1ccr97ZhqZz44wYWsDMlkVhkftE3ibChma5ZvV1w2Qd311N+FReD6cChL+CHAYBOvfo/PjmoVwfGrCELzjsyLzkbs3cLtBwszTFZ/XXI71mFM4Ga8PeKzfFIIx/w2TIKBDEzj3D7cCxg729IhL2oS+44QtmrtniG9sBjB4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660716; c=relaxed/simple;
	bh=I/Fn5O73TEh9WHcmmoeL6GmxtbvXWlLnzTTxUeQx2Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeiebZLYUYljBy+YKuJ4MfPkZzi/9AOgirtWvHhlcsA4qrd/Lxt2wpF+eGTFRY/D/AfIICRehPeIo3g4fTBcWIzXzNbHiBdkcdzExPoqJivLFGZnwC7NCGQFOyLFGb7EGT2rEnzEf85a15H9Ckc2voojBtqi5RlP9G6s8nluT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwxsueIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwxsueIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011EA1F000FF;
	Thu, 17 Sep 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660715;
	bh=m/tjvWOd2/ja1Ypxt44NlTfZX/+p7KkC2BBie4t3LZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwxsueIuTWgvrsM43Jf37NVA12KG7f0sXGZSe10gFgY1CRUwn1zEYkEeeAAZoB3v7
	 cfRG5QIpI/eAp9rJwCKta19Q2J7W89z3FN/UaVFQ1MP8ZYNjT0p7tohVmZm6XNsl/3
	 mnzC8+NGKzksMT9OeElAmSI80UaJAHntUC+sXIfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 685/733] xfs: always set xfs_healthmon::first_event when inserting at front of list
Date: Thu, 17 Sep 2026 16:16:33 +0100
Message-ID: <20260917151409.854654246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 58a0c7578b25b578c16dea7db2493cfa3a08ecc2 upstream.

LOLLM complains that while __xfs_healthmon_insert is supposed to insert
an event at the head of the list, it doesn't do that correctly if the
list isn't empty.  In that case it *should* make our new event point to
the current head, and then make the head point to the new event, but
it doesn't actually update the head so we never see the new event.

Fix this by always reassigning first_event.  A subsequent patch will
clean this up to use a standard list_head, but I felt it important to
call out the bug fix first.

Cc: stable@vger.kernel.org # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_healthmon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 3ae5f4496ad1..a4efc084a8fc 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -278,8 +278,7 @@ __xfs_healthmon_insert(
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
 	event->next = hm->first_event;
-	if (!hm->first_event)
-		hm->first_event = event;
+	hm->first_event = event;
 	if (!hm->last_event)
 		hm->last_event = event;
 	xfs_healthmon_bump_events(hm);
-- 
2.55.0



