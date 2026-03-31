Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87209262A6;
	Tue, 31 Mar 2026 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975383; cv=none; b=sj2FbGO12MumbexzmHT7MU0fpJ8Yqu7/QJipgDh8/fPBDNy8/4QAJwo2pd8bviT6LN45xHZfhUZmiviKzVGMmN/jGmawLVSyo0H6dsUn5AgP5JPw2w0CRZW1Irib4QB3gYDYXgMiASmrryEbNhw5uSFGQ4v8vvu81xSr2rxU7Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975383; c=relaxed/simple;
	bh=TG46qTH0y6yvUksnoduzTY/hTEMnonFofboUX2kk6/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE2bdGt5b8WVq0IfhEQ8D4EC6lvHhZVcjyTZfdFqm9/Ml/aNB7/r4/oAqkwUBsUYCdAu9/+eeR4QtcVatMd8+i42Yom1ptslmdOrGBUC68bMEA8WhGaTq3wd0nTPMuXUEHJo/ZNa6Z1suZMb9QxvhQppVOeDKXvDWhfGr7DAi1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ax+mueTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ax+mueTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB805C19423;
	Tue, 31 Mar 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975383;
	bh=TG46qTH0y6yvUksnoduzTY/hTEMnonFofboUX2kk6/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ax+mueTs7768j/2dvvUyFS2z+SOcpoGdElroEfW7yMR9orhI1GD/jY9b/ApJLVmxD
	 xKZ+S3AmGysxzMe7rqlJtE3o7qnhaPddBciaId3R31Th/dusyQB2sNtU3HaETW4MOg
	 Qqk0FAEn333AkHCqBckdLxPwZZM7uPmiQjXGkqT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.19 231/342] xfrm: iptfs: only publish mode_data after clone setup
Date: Tue, 31 Mar 2026 18:21:04 +0200
Message-ID: <20260331161807.468509318@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moses <p@1g4.org>

commit d849a2f7309fc0616e79d13b008b0a47e0458b6e upstream.

iptfs_clone_state() stores x->mode_data before allocating the reorder
window. If that allocation fails, the code frees the cloned state and
returns -ENOMEM, leaving x->mode_data pointing at freed memory.

The xfrm clone unwind later runs destroy_state() through x->mode_data,
so the failed clone path tears down IPTFS state that clone_state()
already freed.

Keep the cloned IPTFS state private until all allocations succeed so
failed clones leave x->mode_data unset. The destroy path already
handles a NULL mode_data pointer.

Fixes: 6be02e3e4f37 ("xfrm: iptfs: handle reordering of received packets")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Moses <p@1g4.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2664,9 +2664,6 @@ static int iptfs_clone_state(struct xfrm
 	if (!xtfs)
 		return -ENOMEM;
 
-	x->mode_data = xtfs;
-	xtfs->x = x;
-
 	xtfs->ra_newskb = NULL;
 	if (xtfs->cfg.reorder_win_size) {
 		xtfs->w_saved = kcalloc(xtfs->cfg.reorder_win_size,
@@ -2677,6 +2674,9 @@ static int iptfs_clone_state(struct xfrm
 		}
 	}
 
+	x->mode_data = xtfs;
+	xtfs->x = x;
+
 	return 0;
 }
 


