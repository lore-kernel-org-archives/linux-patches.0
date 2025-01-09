Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD291FCFF4;
	Thu,  9 Jan 2025 10:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417464; cv=none; b=m1amYoWHzEoz+FgF0la6brfcV8Iz8JegC4m0nDvmyKLYy60VlCADepU0n1922w+K88YY/dN0Xo3GPNuLL62EF7SIChR3bsPwT4aM83KK/Go1BfmIgpSFfkNS2Qv91FddzcrQW8Knaffn0KBhKybdt9eanZAcJEfJImBJBkiReNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417464; c=relaxed/simple;
	bh=RuSFpt4jOMNZyV0PNlTyU45SM3deU00IivtE19pR7dY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=sbeNeCS5nuVGgYoZmLqC+5T/69Q2gHYE7mtGAr5XMWLT74qrtjWCQ2NzXDKFI5KGurCI2LLXtBu+iJ/TGyEmFvUFXsemhQ0oKbLQ9+iGL2kxQZTcTAvg17+TgerbwxCBpV2wc2MwnPmYjCO+4uLcCWrP0FGqno3AfcPY1hslbZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G//Ou8xM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G//Ou8xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F402C4CED2;
	Thu,  9 Jan 2025 10:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736417463;
	bh=RuSFpt4jOMNZyV0PNlTyU45SM3deU00IivtE19pR7dY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=G//Ou8xMTeZdzA8PeI/p3SY3wrDwr69dm80lz6qSpOJSsOb3rCj4fPFd9LUzjCK7O
	 ZgR74KxFcb/XQxWoLnBRdYqWLKYJJPh2OlXvwL/inWENY4b+aAf35u7S619fRprwlP
	 c9cl4Md+45rcEntl7ieRMXvnDjvvRbwmzJDatLM4=
Subject: Patch "zram: check comp is non-NULL before calling comp_destroy" has been added to the 6.1-stable tree
To: akpm@linux-foundation.org,deshengwu@tencent.com,dominique.martinet@atmark-techno.com,gregkh@linuxfoundation.org,kasong@tencent.com,patches@lists.linux.dev,sashal@kernel.org,senozhatsky@chromium.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 09 Jan 2025 11:11:01 +0100
In-Reply-To: <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
Message-ID: <2025010900-remote-segment-eca4@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    zram: check comp is non-NULL before calling comp_destroy

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     zram-check-comp-is-non-null-before-calling-comp_destroy.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From dominique.martinet@atmark-techno.com  Thu Jan  9 11:09:53 2025
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
Date: Tue,  7 Jan 2025 16:16:04 +0900
Subject: zram: check comp is non-NULL before calling comp_destroy
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, Dominique Martinet <dominique.martinet@atmark-techno.com>
Message-ID: <20250107071604.190497-1-dominique.martinet@atmark-techno.com>

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

This is a pre-requisite for the backport of commit 74363ec674cb ("zram:
fix uninitialized ZRAM not releasing backing device"), which has been
implemented differently in commit 7ac07a26dea7 ("zram: preparation for
multi-zcomp support") upstream.

We only need to ensure that zcomp_destroy is not called with a NULL
comp, so add this check as the other commit cannot be backported easily.

Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Link: https://lore.kernel.org/Z3ytcILx4S1v_ueJ@codewreck.org
Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1733,7 +1733,8 @@ static void zram_reset_device(struct zra
 	zram_meta_free(zram, zram->disksize);
 	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(zram->comp);
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
 	zram->comp = NULL;
 	reset_bdev(zram);
 


Patches currently in stable-queue which might be from dominique.martinet@atmark-techno.com are

queue-6.1/zram-check-comp-is-non-null-before-calling-comp_destroy.patch
