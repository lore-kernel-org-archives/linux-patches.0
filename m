Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625691;
	b=JIfBeukaUQyFLzH5+eND+pAxsKvreQpP6lN3PG0i+bpQYbXVktkF0T2rOsp/zuvROw8e
	 CKOOKfonp2EF4oTTh2H+ytaKoT1MNSekm8SCVQ4iMHODyTb6wWMDj/mG0jf5+Quand6AA
	 3ggk6F86kPgBlucPZuxyvc2MSZqY6GsAe+N3dujvSx4rAbn1FpaBAeFv02ddmyLiKXodl
	 AfeA5l/NLzGO4TOTEpb2Rmi08XA/nCYSEGY0bn1BWJ71qrDbKxIFGbkAdEi8Go3DRTeg5
	 LNpl8vcratLzuKP5LsIidDjGTQqGNN7aGjQoQH1gnHEePv6s6PVAFXrf3jf0DpsFGiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vpXt8rkrHO4XXymq7u0/yeIBTbXqw3OYdNg3+v3jHBA=;
	b=IScIdz5914q8InINKa+RkPbfs9qz0bCig9zogMh5xOaaw6mubuqAA5v6+t0zKHZtkTcF
	 tSdNsP8M2VV7wWMWejCz1JOQExWUBF/DkAWb4puf4k9OhGn1LJ4cCTUxc6DGvpt9MP/68
	 GCdcILqXI+pSBThvOh/h2clTdkZ039eoa1yV473ghLEVN+jrbXPLfyKNEi88onakh2001
	 EhKZ/fIhmpo/Vm+rR/+ksfmzl2tUUebHRvFH7tGUBwGPQdyABURZLoS00G2Jbl1mNLedQ
	 S5hhNCQyF/7dW2tfp+ZxJ83HlWVIw5C3XRjgtPaEgGlEwZmM0MqGosm02Lxoy581Cgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/R55OOg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6F606A323;
	Wed, 25 Nov 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/R55OOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C441F000C4;
	Wed, 25 Nov 2026 16:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625691;
	bh=vpXt8rkrHO4XXymq7u0/yeIBTbXqw3OYdNg3+v3jHBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/R55OOgDtBiucHaQjSa04EAZsqz9HIid03X7wimXMEcz5zGgl7IHsPwvn54XYVPo
	 xn4Pk8DtvQmrTVkzFtYslptJTxkLxKrVySQ6RqjUXYB5B48JBr+gor2lWGxy35wwMl
	 H+aIU4+pM44pQ0yJ6+TjDJsGJBmeXRfjC4Qfm3Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 563/816] backing-file: pass RWF_NOAPPEND to synchronous writes
Date: Wed, 25 Nov 2026 15:35:11 +0100
Message-ID: <20261125143902.213688707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit afa735786a89bde4959db52f20e3579de54ec740 upstream.

pwritev2() with RWF_NOAPPEND ignores the offset and appends the data on
an overlayfs or FUSE passthrough file that was opened with O_APPEND, and
the call still returns success. The flag must make the write go to the
given offset even though the file is in append mode. Any user who can
write to the file is affected, with the default mount options.

overlayfs and FUSE passthrough forward the reads and writes on their
files to a backing file on an underlying filesystem, through the helpers
in fs/backing-file.c.

The flag works for the file that the user opened: kiocb_set_rw_flags()
clears IOCB_APPEND in the write's kiocb. It also copies RWF_NOAPPEND
into ki_flags, as it does with every RWF_ flag.

overlayfs and FUSE passthrough then pass the write on to the backing
file. They opened it with the open flags of the user's file, so it is in
append mode too.

For a synchronous write, do_backing_file_write_iter() calls
vfs_iter_write(), which sets up a new kiocb for the backing file. That
kiocb starts out with IOCB_APPEND set. vfs_iter_write() is only given
the flags of the user's kiocb that are in BACKING_IOCB_MASK, and
RWF_NOAPPEND is not one of them. So nothing clears IOCB_APPEND again,
and the data goes to the end of the file while the call returns success.

An asynchronous write reuses the flags of the user's kiocb and is not
affected.

Reproduced by calling pwritev2() with RWF_NOAPPEND at offset 0, on an
overlayfs file and on a FUSE passthrough file opened with O_APPEND: the
data was at the end of the file afterwards.

Fix this by adding RWF_NOAPPEND to BACKING_IOCB_MASK.

Fixes: 73fa7547c70b ("vfs: add RWF_NOAPPEND flag for pwritev2")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261101123440.3184069-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/backing-file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -103,8 +103,13 @@ struct backing_aio {
 
 static struct kmem_cache *backing_aio_cachep;
 
+/*
+ * RWF_NOAPPEND stays set in ki_flags.  Pass it on, because the backing file is
+ * in append mode as well and a new kiocb for it starts with IOCB_APPEND.
+ */
 #define BACKING_IOCB_MASK \
-	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND)
+	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND | \
+	 (__force int) RWF_NOAPPEND)
 
 static rwf_t iocb_to_rw_flags(int flags)
 {


