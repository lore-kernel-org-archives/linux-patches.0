Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D6B377EDC;
	Fri,  4 Sep 2026 05:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500879; cv=none; b=o7yXNC4qfR+G1cPuvJPWc9DhRuDSUYTyGmIFyiAYO99o1XML6gEvi1F/Uicw6+jMcRMMAxjMPI53iZSNSvbH4ZX4RfxcD0P2MapN0Z3Iab9G6Av8koWrV2fyuM10aIYYSgckg/KqpmwU+IcFQYeXmEd0JdKer/Kzke9VjznNTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500879; c=relaxed/simple;
	bh=EZCoRvka2Gsax5/nHVUxB9E+gmR/I/IDPhIyceiR3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BATJyYti+F53ZIJsxgUwOirGFWQaRhbW6PrdXyUANBnj9TUdlgxpGSHDe6rcSxp6vWPkSxKB7pP6su4GeNxUFjjW350y3HcPuNi+ZoC3T+Tek2MgYIquqwzRBl2Ce/GcpucrfftgxUxwd735y3wLMUH1GIpQ+bUGsvLPgK4Id70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9yxR1bW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9yxR1bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9541F00A3D;
	Fri,  4 Sep 2026 05:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500878;
	bh=HZHewTPbLgsBLdWAvtF4tCv0QXCZ8XHLQaEbEPcFVlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9yxR1bWP0sfp78yUNjPdBtyPZuXbgO9bafH8I5Q3MC1GVXkiAtc6jnH+rP82YcV6
	 5Pt3tTp+T7HhEytKsHtnum+s4udHkk0vK4fbbL72EH0N7t+8U8vp8Hprg+eNXGwUMC
	 pJvfwcTDe4/2GjJFgkavQhSFUHhxpal/4xt5rpIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 169/552] cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
Date: Fri,  4 Sep 2026 06:55:26 +0200
Message-ID: <20260904045752.857657085@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 364b183230586a62660a7280c1eb20138338eeb5 upstream.

cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
cannot use cifs_resize_file_locked() to perform a proper fscache cookie
resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().

cifs_invalidate_cache() calls fscache_invalidate(), which works without
holding i_rwsem: it unconditionally increments inval_counter and sets
FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
served once the cookie is later activated by fscache_use_cookie().
Truncation to zero leaves no valid cached data, making invalidation the
correct semantic here.

Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -994,6 +994,7 @@ static int cifs_do_truncate(const unsign
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
+			cifs_invalidate_cache(inode, 0);
 		}
 	}
 	if (cfile)


