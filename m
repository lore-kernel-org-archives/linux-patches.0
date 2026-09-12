Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89482389472;
	Sat, 12 Sep 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236996; cv=none; b=R/bIrC5nqkPWxLJrma4r8KmdY7ByEWMQ0GEzXB8Ehj1vcg77COt07RHGJWm4gsxC8OYEroH8hyUk2oLLodfpRGvljZGHBl3hOHYeVlkYcA/KbZiWaZjB2OGUHEYypyRXMD7S8eiOpPH/xhEg5oLc0UwSiqpDdUSq769grMhOuR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236996; c=relaxed/simple;
	bh=P+r9arV0Sx1OB6NBiNom0nmsslTNuMSwe/3p2+BKUOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qntpze0psTsDZa6D2X+Q1fcsoSAhwblLNyfVOjs8rlFVaB5EeT/YwiDkNmW8HP1cQcwL/edqTV45A/t6cWcYvIek42b6jDmyaTfCllCWH/wbcf8y5kHnIExulA/1pCvduOE+i9lWjtTRRHQ5oAZnMRjDCzMHESGt7er7K3utnDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psnXh0Sv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psnXh0Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096D81F000FF;
	Sat, 12 Sep 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236995;
	bh=V9c8B0zUoBKu8lgwuZp4Ud4Yuu+9yLtMOG0qZfpbWjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psnXh0SvQWcK1h2tFSFhHJjABWqCirEBKocMBHi5i/YvdL7xwszN3tlRPgYHGamiP
	 MnHfZDyF+cEgt6BIE+Uy4UuT1Wmtok2o+HLFlQ95Vga+BiMmf5hTGnu+o7V35AZ0Mk
	 JcREHntHDNjKrTwQ3mRUkNtuFc07i4q0SvBA2RzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 5.15 126/935] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Sat, 12 Sep 2026 08:52:36 +0200
Message-ID: <20260912065529.714060433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit f574296be7f46eb60beca851240b526df232f480 upstream.

On a readdir downcall, orangefs_devreq_write_iter() frees
op->downcall.trailer_buf with vfree() when copy_from_iter_full() fails,
but does not clear the pointer before goto Efault. The waiter in
do_readdir() is then woken with a negative status and frees the same
pointer again on its r < 0 path, causing a deterministic double-free.
A client holding /dev/pvfs2-req triggers it by sending a readdir
downcall whose declared trailer_size exceeds the bytes it supplies.

Clear the pointer after freeing so the readdir-side vfree() becomes a
no-op.

Fixes: 382f4581e67f ("orangefs: rewrite readdir to fix several bugs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/devorangefs-req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/devorangefs-req.c
+++ b/fs/orangefs/devorangefs-req.c
@@ -474,6 +474,7 @@ static ssize_t orangefs_devreq_write_ite
 			         op->downcall.trailer_size, iter)) {
 		gossip_err("%s: failed to copy trailer.\n", __func__);
 		vfree(op->downcall.trailer_buf);
+		op->downcall.trailer_buf = NULL;
 		goto Efault;
 	}
 


