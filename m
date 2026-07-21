Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE0A43E488;
	Tue, 21 Jul 2026 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671306; cv=none; b=IPg1kuJ/n8OKvjHb4FyYx9euKGqxI+2Ilfyv6y76mytG6uj9PHhnKTgSHwlQiT/B3HY8i8cAI1X6HmAtPO3yuhtBbIOaNrAzxxFtzyT8Jf/0NbuToTJMibtdVJ04nMyyxIUBsRtSS6doQ0+07r4jERRWLKW4FGjevmFAx7/+tmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671306; c=relaxed/simple;
	bh=g3NsuiE2MkHX+JzBpgB/Y7VAKtf7ZTG6X/Mf6MyHV1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZDKDexUqVg7JYXQ5bzJjGokA+YUR5pmbDLe3Pv5zY++0xgF7Uj7tMiqOpm6VJ2RhpVImGGY7EFtYFVg9wysjqkGrpZ00TI95MMe+oxBXtC9QYPKIpDYs01uUFN3Gqi3zlft9cW4gLM5F02oWoBrxB05L2NXEAn4fQad+y+HxYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mvjUzUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mvjUzUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103EE1F000E9;
	Tue, 21 Jul 2026 22:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671305;
	bh=RfDgaD12hBnMXvnE8hgaD0XxplwHZMn0NeC3dJFGkFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mvjUzUdJzCD7+gDkJmYS283Cav1oK3HUu9GJMK1lBZXHcO1MILNUd3IsJPCVXyKH
	 tpY5IgXRIWjncrvhdgGWjJ1eXJb+eubFxJ5K2rz3gSiLS9b9jGAtVV8XMyWR4JBcgZ
	 q2bozDGiTEfEMyVQefmYsU0/V96LSTGkDrazT5eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 196/843] fuse: re-lock request before returning from fuse_ref_folio()
Date: Tue, 21 Jul 2026 17:17:11 +0200
Message-ID: <20260721152410.424683810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit b5befa80fdbe287a98480effed9564712924add5 upstream.

fuse_ref_folio() unlocks the request but does not re-lock it before
returning. fuse_chan_abort() can end the request and the async end
callback (eg fuse_writepage_free()) can free the args while the
subsequent copy chain logic after fuse_ref_folio() accesses them,
leading to use-after-free issues.

Fix this by locking the request in fuse_ref_folio() before returning.

Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -914,7 +914,7 @@ static int fuse_ref_page(struct fuse_cop
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


