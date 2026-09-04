Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223E1348C47;
	Fri,  4 Sep 2026 05:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500874; cv=none; b=gW2Ce1eHnOBT4JKTYMb6Jw0ErAreCIOwEzb4xvSF62fP6e5ypKSh/7JihrtMFYXazypNy1KXfMFnuNWLUtOOl5QMc46P/8W9eqa7/W9naiYsDhx5OLuSwE5Whh8KdYku03Cyr02Ok9Kgx6pCfA/EAH93ylQjfZ1sf0u3rRBBfJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500874; c=relaxed/simple;
	bh=cd/g+7PDoDPgvtMpYRPdoZsKtTTI1LRWVBhigGPR0eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvkvSbuu6GJbdzQsSSrTldXElf9VdhWxuSiUv/svsSmC7j2wAp+7ppUwX8IMwmM6LwDO60oX8DHV2HWsa4UxbKW+AmlkyvdMKTD1ATyZ600BGnI9C6Jj6Ykgnt4yDxkKVC535X6SRl2WPmU/ZVCx7/WBAVHEnusyn65DvqCWyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHCxsrSS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHCxsrSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3851F00A3D;
	Fri,  4 Sep 2026 05:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500873;
	bh=HE0+f8Vee08xfLvXCmMSNrNemiP+t3AuS3/3wPCrMro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHCxsrSSZHr2PoW0kEDRcKAHw8EzRQgFKaaLsl6HbX7obqj3+PYudrPSMcwvNVpbn
	 KwNAfo45gRhb5uZqakWt0S0e/2bkiBWR0JLygJ0IMxhbkPRrwQfT2sv8YeNmxk/oEV
	 XcHod4UjnpSuEKpQRr3x5NB75hxuCjBR3cwfQVO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 167/552] cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
Date: Fri,  4 Sep 2026 06:55:24 +0200
Message-ID: <20260904045752.812930591@linuxfoundation.org>
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

commit b96db32fed8dfb2478d7c208f89bf383beed1535 upstream.

When the else branch of cifs_file_set_size() finds a writable file handle
via find_writable_file(), it borrows tcon and server from the handle's
tlink, attempts the handle-based set_file_size() RPC, and then releases
the handle with cifsFileInfo_put().

If set_file_size() fails, execution falls through to the path-based
fallback, which reuses the borrowed tcon and server under the
"if (tcon == NULL)" guard.  Since tcon is not NULL at that point, the
guard is skipped.  If cifsFileInfo_put() dropped the last reference on a
tlink that was already removed from the tlink tree (TCON_LINK_IN_TREE
cleared, as happens during reconnection or session teardown),
cifs_put_tlink() will have freed tcon; the subsequent set_path_size()
call is then a use-after-free.

Setting tcon = NULL after cifsFileInfo_put() causes the existing guard
to take the cifs_sb_tlink() path, which acquires a fresh reference for
the path-based operation or fails cleanly if the session is gone.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3080,6 +3080,7 @@ int cifs_file_set_size(const unsigned in
 							size, false);
 			cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
 			cifsFileInfo_put(open_file);
+			tcon = NULL;
 		}
 	}
 


