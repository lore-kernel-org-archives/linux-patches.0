Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD36C18D636;
	Fri,  4 Sep 2026 05:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501224; cv=none; b=SsBthbNCoizkykMm7D0uLu4SIY/cg6N75uLgbmXX3yjq31SJdDOLpfkWXgRNeeklKKmu9msc3aGQYXxS6/Hg/nzmDD57dE9sd/TCdKuRYXfWnTHU5kUrlpDBqih4ZQTiWwEPbhihPkMJ18HocmzOsrYEY91K+Y535n1qYlid3/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501224; c=relaxed/simple;
	bh=f4CVZgMhc+1nU+ewWdctjvnwtKPEBQATFtQBJYrkGrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUNComCb9lxyv2VQE283zr0NykM87CoJ1nBte1nAXCBy+tg+6E/6Inzs0pFB1dsne3Ss2f6BEQwZ3ODDZJ91LnAqo0qx5flkMc/CusBaQwZD3TJ9aqXsdaiQDpWbm14fUs84wb/dSRUUPX4bz270M5wJnODDCbM/v0Sb9try7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIVXOrAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIVXOrAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131F11F00A3D;
	Fri,  4 Sep 2026 05:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501223;
	bh=fpOfKxHi5PsJugbzHvi2B/ygUGnTVCnrrQG6G0MCv/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIVXOrAQSudWWAe2I1UgrSjwVBLCQrzqrze9tBKeBDKZEVIaX/V33VVrjwkNkK4An
	 TI1GylufaKIZ2xBYOtlTZ8q9CxPq68BPUrNyucMN2KIycvU4rhvjkMsl6Gbp4rA062
	 +wl5Wa1M9b5x6KaxFYTznbh9agqkzuSeHx0WAAUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.18 333/552] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Fri,  4 Sep 2026 06:58:10 +0200
Message-ID: <20260904045757.812661562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


