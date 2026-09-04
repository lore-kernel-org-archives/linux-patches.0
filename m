Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE51415F22;
	Fri,  4 Sep 2026 06:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502529; cv=none; b=YOhwWifDm4n4GpSLUGQpfhtIxRJ2UH+CChuAojKjz51Lwph53WNL6tqs4PNxK4yMm8vsuEYi2vJWSX6GWBGOKEkG9eAF3cfub12xEhbhEvJtGRSlg37jzdew+8GNw1UEQFIzYYsphpJjkmpslooi38fLmjb5aldsSY6AK9ocrmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502529; c=relaxed/simple;
	bh=qJ4N9CBsd0eIqlKjbw4522EIes0ZwpFim94wx8Ijvg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goAbpPnUXEhV7TeKSpPhF4TTyqo1SgXbPz7HPvTpzVtsH/F9GJzbqnrUtHQ7ZH4y9uP/LgAi1sO2LZ/joS0BzIpQ9A2lYfjgcpmzFVscNkG9am514segIVOUZ227LMVCY8aM+BZKZxeqfzsv2DFxed/wW8OFyQHxEtHcIczjFU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTNmT7PN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTNmT7PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C591F00A3D;
	Fri,  4 Sep 2026 06:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502528;
	bh=qjVEH+u7T4FGilR7CHcTpNJjyMylxMxgm+W509r8Q0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTNmT7PNaDcnMMh+DzaEveIC9k7Q6EKS+YzdrLIFS3ZOvhRFYnvuQF62a23BjVCf3
	 +R5g8nxSTcApzF4PxwOugX7v0qjEoZGcBLM56oTr+QVOcC1NcdpICz3kvbCVr3vcxN
	 MpgTyArvf2SfQ+KSNjokDKntx/+QtHUgju6P0fKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.12 240/403] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Fri,  4 Sep 2026 07:00:43 +0200
Message-ID: <20260904045740.329287803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
 


