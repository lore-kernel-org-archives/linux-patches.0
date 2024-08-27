Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ABC4C634;
	Tue, 27 Aug 2024 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771784; cv=none; b=em5hW4tFsuWh62TZqV4A1vYHL1PLUzNRHoZzvQuy6Ylg1swBSkQvUA8qGXLmdQLNohWu/1/tsS0nkn5j2JTaKxHJT96iR62gg+z27PEGu+2yOe8Yfkt9NtPn1ngBMpCWLbl66GdALpHm2W7XzpLN2fBXzzO5DYDIN0HDBy20V64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771784; c=relaxed/simple;
	bh=3P3r8P7YL3rkbDRIcvniJi78iPEemLpcoPHtAPwDiQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqjMT/3NXTFKqMOi3JycjZEcFmTHqGXQndwDqY6G4QsarYOixGYUJ1GTduIRqhrTTK691QUXQdd1FUJwQz0PueUeJqgYRECMFLFAxybsMTLcpYyR5auFU7Z6Cis44A8/EiAk1dGrf2yVNwc4uSu0QfryZyzTEXxvbIQoipgsHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdWiVUKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdWiVUKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AECC4AF50;
	Tue, 27 Aug 2024 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771784;
	bh=3P3r8P7YL3rkbDRIcvniJi78iPEemLpcoPHtAPwDiQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdWiVUKxhnEeRIFns1b0An+a8S6uhle1YW5whP9pWg2mJM+Mn4A09scdeV2ETSQ0N
	 +ggPNR8F8Ztme/ykP9nJtle3NdQ/5Mrnnh0C3w9YEGp/QXCKD/V5Z3YKty+jKEzk75
	 42rlSe3zpE3yFRoRzJ+QmDjQSFVDI+Sc1nvAiDN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 002/321] fuse: Initialize beyond-EOF page contents before setting uptodate
Date: Tue, 27 Aug 2024 16:35:10 +0200
Message-ID: <20240827143838.289179857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 3c0da3d163eb32f1f91891efaade027fa9b245b9 upstream.

fuse_notify_store(), unlike fuse_do_readpage(), does not enable page
zeroing (because it can be used to change partial page contents).

So fuse_notify_store() must be more careful to fully initialize page
contents (including parts of the page that are beyond end-of-file)
before marking the page uptodate.

The current code can leave beyond-EOF page contents uninitialized, which
makes these uninitialized page contents visible to userspace via mmap().

This is an information leak, but only affects systems which do not
enable init-on-alloc (via CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y or the
corresponding kernel command line parameter).

Link: https://bugs.chromium.org/p/project-zero/issues/detail?id=2574
Cc: stable@kernel.org
Fixes: a1d75f258230 ("fuse: add store request")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1615,9 +1615,11 @@ static int fuse_notify_store(struct fuse
 
 		this_num = min_t(unsigned, num, PAGE_SIZE - offset);
 		err = fuse_copy_page(cs, &page, offset, this_num, 0);
-		if (!err && offset == 0 &&
-		    (this_num == PAGE_SIZE || file_size == end))
+		if (!PageUptodate(page) && !err && offset == 0 &&
+		    (this_num == PAGE_SIZE || file_size == end)) {
+			zero_user_segment(page, this_num, PAGE_SIZE);
 			SetPageUptodate(page);
+		}
 		unlock_page(page);
 		put_page(page);
 


