Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843FE481FCF;
	Mon, 31 Aug 2026 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183479; cv=none; b=ID2iJaz2jCLiBHSmfpYoU1TrNpsW4mbMyieFofyGzvEcy9PHy6mk0HUFIxBNl/3jomqoPkjqRCAGj+5epoFLqPgXNLETHGrDuv9LMibuEU73s8j9PGH93jWVGuEpHscbr6mBEOCVado65q2tqvPW412DuQ6iSSfNowLn2z/0eCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183479; c=relaxed/simple;
	bh=WTvbIFCmj0AlBczARWAOTgWm/VllKosFFNmRIlQUsR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijr7pDHbnWoK4UUXCjzAlh8rCXODtf16mcE52PvsMsOfth+OK/RuRvcrtA91Ztp9MKRH9qxqguCHjL2675mvAjlR47zsa9B7eZ6LB+VEm5A8hy1IV5RBO8kovF1O53qqye54ILvCqMI5PT2gEK9MmHGiq95diO2sugxs7AAeG9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjLk6F+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjLk6F+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD7D1F00A3E;
	Mon, 31 Aug 2026 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183477;
	bh=iMBbkBhl5CEgmVxcV8+FTCddgpjORPB4lajnYet7LZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjLk6F+szNrrPLgt47ZkChp2O1mjPRAEkeQKOl0p8NhYK06WYIMBdct1X1o53xGDl
	 ZmZLV+8/B36H2V5uRrtoTzjB3qpl49HINRyc5rQVCu7oFiLkA5wbif6NF5slL8L5go
	 OKi+E7+kvo8nHe1kRAW35NLrqJ67AXo2X6KPJvRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.2 13/71] fuse: fix missing barrier when checking io-uring readiness
Date: Mon, 31 Aug 2026 15:33:38 +0200
Message-ID: <20260831133359.670344720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit edb310bc27f0ad83e7fd558a3caf1a94ca511654 upstream.

fuse_block_alloc() reads fch->initialized and then fch->io_uring.
fch->io_uring is set before fch->initialized, ordered by the smp_wmb()
in fuse_chan_set_intialized(), but fuse_block_alloc() has no matching
read barrier between the two loads.

This may lead a CPU to observe fch->initialized=1 but fch->io_uring=0,
and skip the check that blocks request allocation until the io-uring
queues are ready. This can reintroduce the lock-order inversion deadlock
that commit 3393ff964e0f prevents.

Add an smp_rmb() barrier to pair with the smp_wmb() in
fuse_chan_set_initialized() to prevent this.

Fixes: 3393ff964e0f ("fuse: block request allocation until io-uring init is complete")
Cc: stable@vger.kernel.org
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -85,7 +85,13 @@ void fuse_chan_set_initialized(struct fu
 
 static bool fuse_block_alloc(struct fuse_chan *fch, bool for_background)
 {
-	return !fch->initialized || (for_background && fch->blocked) ||
+	if (!fch->initialized)
+		return true;
+
+	/* Pairs with smp_wmb() in fuse_chan_set_initialized() */
+	smp_rmb();
+
+	return (for_background && fch->blocked) ||
 	       (fch->io_uring && fch->connected && !fuse_uring_ready(fch));
 }
 
@@ -120,9 +126,6 @@ static struct fuse_req *fuse_get_req(str
 			goto out;
 	}
 
-	/* Matches smp_wmb() in fuse_chan_set_initialized() */
-	smp_rmb();
-
 	err = -ENOTCONN;
 	if (!fch->connected)
 		goto out;


