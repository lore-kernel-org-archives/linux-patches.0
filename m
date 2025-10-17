Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546A337110;
	Fri, 17 Oct 2025 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714722; cv=none; b=V81VBVZwL5ceSvbai3Z56NZ6bOMJBV7yfp3H7uvIQKUvp0Rw0Xi+Gigf7ZMHUfTYUe76Gs/NGNL4t1QrX84+OeXPLLKmdQ5U2TisGhvKkzP/YY9FK/g80IaR8PmTNKiKZR5KbSPYnU4v4cQMRUQvAvv4jsd2yAVXzPjn94JfN9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714722; c=relaxed/simple;
	bh=OlTtjqTaPmvhKNBWSGqvoAqZ9UFqbxikzS+H/h0Dfu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJe1pbDki/f1yD2H/nmCBFysu8e3hCaMWkJxes3BvHhJKTIUTmd6qPmVa2fD6aLD0izJAgQWPMqAOmeJRh3lVTk9WyZIgaa25h969Lte6WjV+EwB+EDzIuiAdVEkuo458wYzDY43aU6CQripdilwK+7JhA4lIeZNq+Q00FGZgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/K1vbwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/K1vbwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80DBC4CEE7;
	Fri, 17 Oct 2025 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714722;
	bh=OlTtjqTaPmvhKNBWSGqvoAqZ9UFqbxikzS+H/h0Dfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/K1vbwYb/l8n63hCIluwPrj2EqgWcM6kIVRbwMp9DCXH8PL8rTB0rv/7DrpupVYx
	 UGPa2oj+gJBOyM1LtVYV5lI1Y5RxjZXKZrCA9PG0ybsPRpkHh6mLWt9WCUnA/RguWv
	 ZJrcatAcP1H+KPkjp+tXWx4FBeBHB1pYtK4mSnpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 210/277] NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()
Date: Fri, 17 Oct 2025 16:53:37 +0200
Message-ID: <20251017145154.796372612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ab1c282c010c4f327bd7addc3c0035fd8e3c1721 upstream.

Commit 5304877936c0 ("NFSD: Fix strncpy() fortify warning") replaced
strncpy(,, sizeof(..)) with strlcpy(,, sizeof(..) - 1), but strlcpy()
already guaranteed NUL-termination of the destination buffer and
subtracting one byte potentially truncated the source string.

The incorrect size was then carried over in commit 72f78ae00a8e ("NFSD:
move from strlcpy with unused retval to strscpy") when switching from
strlcpy() to strscpy().

Fix this off-by-one error by using the full size of the destination
buffer again.

Cc: stable@vger.kernel.org
Fixes: 5304877936c0 ("NFSD: Fix strncpy() fortify warning")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1372,7 +1372,7 @@ try_again:
 		return 0;
 	}
 	if (work) {
-		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
+		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);


