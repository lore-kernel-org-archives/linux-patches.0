Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C128751B;
	Thu, 25 Jun 2026 13:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393029; cv=none; b=G3U14vcDXoR/lGufzh9vgULdR7f2fnPwyW4/N5QCUNT4GVhyYlKZD50v25JmKww4O8hqCXKEK8yGhRRYKNFhigtkPM1/YJOrQEdTli3FKcThPGLJYAB37g8Utl5jMl1XzppnPvsoH6Kx+RgDZwxrmYrvTYrzk+vY9JW4UrrUrHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393029; c=relaxed/simple;
	bh=n78GgRA3z9qLvdmvrii6ihJJlxeI6roZwlDC4p7/ih0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocCg0/kqLIrRmGKV/XtMwgqV59vEVk5E3HfBAe6npEBsbAYXaIDGfzLfUPiqo55T8S3LuoI9Aq6YytJqnlY+jn+C04J8C9Us9TA66/cegvcfj5H/cnhEvGZ7XTQf97URgRs6a78d1Q5TuVP+zI+zpxZbv8vZp1MtnC5kBBdIo+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeAxFqeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeAxFqeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBA1F000E9;
	Thu, 25 Jun 2026 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393028;
	bh=3FyVCcsCU0rfFppvCMirfp+VvPAlvIqnPiWi1SLUToE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeAxFqeCOTX7xevhFP3FSg26cdDua14CVsUIruPvvZz381Ne/WyA+aAq4UPSvzznb
	 gfvU5fzFtvyGWbvfKlc+dSJcI62lUVJKgWitf7z1U8Jkyrgu3yRmIa5Fk9DIBAT/j3
	 oG7Y4XlfEFfom6+jHovbBkINCHJlHC199h1ccCfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 20/49] rose: guard rose_neigh_put() against NULL in timer expiry
Date: Thu, 25 Jun 2026 14:03:32 +0100
Message-ID: <20260625125640.308669283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 2b67342c6ff899a0b83359517146a5b7b243af97 upstream.

In rose_timer_expiry(), the ROSE_STATE_2 branch calls
rose_neigh_put(rose->neighbour) without first checking whether the
pointer is NULL.  After commit 5de7665e0a07 ("net: rose: fix timer
races against user threads") the timer is re-armed when the socket is
owned by a user thread; between the re-arm and the next firing, a
device-down event or concurrent teardown via rose_kill_by_device() can
set rose->neighbour to NULL, leading to a NULL-pointer dereference
inside rose_neigh_put().

Add a NULL check before the put and clear the pointer afterwards.

Fixes: 5de7665e0a07 ("net: rose: fix timer races against user threads")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_timer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -180,7 +180,10 @@ static void rose_timer_expiry(struct tim
 		break;
 
 	case ROSE_STATE_2:	/* T3 */
-		rose_neigh_put(rose->neighbour);
+		if (rose->neighbour) {
+			rose_neigh_put(rose->neighbour);
+			rose->neighbour = NULL;
+		}
 		rose_disconnect(sk, ETIMEDOUT, -1, -1);
 		break;
 


