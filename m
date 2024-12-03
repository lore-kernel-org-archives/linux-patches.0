Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134E1AB6C9;
	Tue,  3 Dec 2024 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242786; cv=none; b=PZkWk262ftmYRqwDf8KiUBIeiSOpzMGisW0XV5auwkERtgce9c8brgrhgJtzj98YkOU4X0lHEoVXOAIjmvDPDm6DLslKUoKEammYZUFmi1HsCcKfQfHjUsnCCuS9XphHezcLSp5Qj9IYbQw1/renbHCPNr6EqIn5Mvpoh4qyTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242786; c=relaxed/simple;
	bh=bWs2R4ZocihyKGIVSGanT+uKZZ6zKP/ODm/+QqZ/0+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfGi/0yBXXXp6/38vtWpHEYG06B55OLkupUXABIlSRIfPB1XbTn4cMwZLLVVEP6+ypf13+F6l/zO23dP5dOm25AW1pzMRBqx11cBmimm4Jqk5987nl2zaeFoyXaKwbj/TqC8PpDHcCzZF2vsVto1Rf7PFRUYaUYc4nxon1w5LNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Foj5+hIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Foj5+hIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4701C4CECF;
	Tue,  3 Dec 2024 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242786;
	bh=bWs2R4ZocihyKGIVSGanT+uKZZ6zKP/ODm/+QqZ/0+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Foj5+hIwPudPrOKob65x6HsgQc+QcvWXxImE5JjwShmVlAfpgWTgQAC2uuxAdE/pb
	 R/RW2OQGjli/suItiaGtbsnvVFd9VqQECZRgUIi5opQXb2o5NuuLJDjf/B35LVH5GU
	 9UU+pmyKs6Bv+7mSX36T2JH5X8RsHwge2ZmWfiDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 809/826] smb: Initialize cfid->tcon before performing network ops
Date: Tue,  3 Dec 2024 15:48:56 +0100
Message-ID: <20241203144815.313219717@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Aurich <paul@darkrain42.org>

[ Upstream commit c353ee4fb119a2582d0e011f66a76a38f5cf984d ]

Avoid leaking a tcon ref when a lease break races with opening the
cached directory. Processing the leak break might take a reference to
the tcon in cached_dir_lease_break() and then fail to release the ref in
cached_dir_offload_close, since cfid->tcon is still NULL.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 004349a7ab69d..9c0ef4195b582 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -227,6 +227,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 	cfid->dentry = dentry;
+	cfid->tcon = tcon;
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -298,7 +299,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->tcon = tcon;
 	cfid->is_open = true;
 
 	spin_lock(&cfids->cfid_list_lock);
-- 
2.43.0



