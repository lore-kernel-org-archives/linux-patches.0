Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBEE7B3EA;
	Wed, 21 Feb 2024 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522143; cv=none; b=AY8zBTFE7e1+jFoW9TyfrRRZRdPF4jmoPr/fPibKQfB0DTaqOnwCC00Ja2gNioXgA3liDhbFS3KP/ix2uhhsAPVV1y60kQTQLYkwldQx3oJrZ3rdHiTTRLxxleGtpScu2RnrPL0RwWv88nKeym6IHgQOPxxsGlYu6siL/KsFMc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522143; c=relaxed/simple;
	bh=rdIS2Eo574y+jEJlYZduh+DFMWE/QBUFMqJkLLYMy68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bogzQF244Yur5T5OUQzAkWuSlUabMraLMfYBSXgPtfBYf8v9OYflc3C1nT3609TswQEOshYuEKILPvSyB0CEIWuTB/nefV1nMaiHJNg6X9/nq0OlTEv6QdLDpVBF+yPrBvTM4YF1PrZzJ7U9MAkll0rGghz7RxlGe26m3Il9Y/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dcRhzcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dcRhzcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B05C433C7;
	Wed, 21 Feb 2024 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522143;
	bh=rdIS2Eo574y+jEJlYZduh+DFMWE/QBUFMqJkLLYMy68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dcRhzccz4P8wwClmAP3j70BHP5hKLmRO4CLX8A6dcWrVhSJOZDUGCfKIG78zuYB2
	 Pp6C1KnfG8AnGdLLYBmyXG17UkkJPIB5OCc+A+tx3/zHFVV8hNt/c1oUFhGaiU8YNZ
	 gRPl9T+tgnxY1l4dfspSuUxAJt2KQis/D8yyzcV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/476] afs: Hide silly-rename files from userspace
Date: Wed, 21 Feb 2024 14:01:44 +0100
Message-ID: <20240221130009.884956991@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 57e9d49c54528c49b8bffe6d99d782ea051ea534 ]

There appears to be a race between silly-rename files being created/removed
and various userspace tools iterating over the contents of a directory,
leading to such errors as:

	find: './kernel/.tmp_cpio_dir/include/dt-bindings/reset/.__afs2080': No such file or directory
	tar: ./include/linux/greybus/.__afs3C95: File removed before we read it

when building a kernel.

Fix afs_readdir() so that it doesn't return .__afsXXXX silly-rename files
to userspace.  This doesn't stop them being looked up directly by name as
we need to be able to look them up from within the kernel as part of the
silly-rename algorithm.

Fixes: 79ddbfa500b3 ("afs: Implement sillyrename for unlink and rename")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index cec18f9f8bd7..106426de5027 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -492,6 +492,14 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 			continue;
 		}
 
+		/* Don't expose silly rename entries to userspace. */
+		if (nlen > 6 &&
+		    dire->u.name[0] == '.' &&
+		    ctx->actor != afs_lookup_filldir &&
+		    ctx->actor != afs_lookup_one_filldir &&
+		    memcmp(dire->u.name, ".__afs", 6) == 0)
+			continue;
+
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
 			      ntohl(dire->u.vnode),
-- 
2.43.0



