Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75481586CB;
	Tue, 23 Jul 2024 18:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759928; cv=none; b=pq5q1No717cv5SpaR8efDGMlt9GAgorcytssOhcp4KtPuqf3xfNbchbC8DanR6tYnDzKgpQZAx6n4mYndZBBuGH+COJRUqeHn2zieW3h43KucaSSksVO2mgdY+3s8LUeHCo9YM7ko0CSglsuJUE/I1Exw0GYizCmnYgw1csSrZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759928; c=relaxed/simple;
	bh=7Kb6fA3FhOkCE1X2AH1vXxPO5OacMg5tLa4I2APKoMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi6yM5azF5OxM6oiEluxDtarkdzyko10DA3lTbkOBYLqUesH5pwy5bnpPnJtTw5RHFA5LEDizRtDpzHYdSZucWKEmMcATxsNCalUmq/XmOab1c9Ibp/LsCPYEl3L9sGSr3bGikf9k2OHYGQ7xDIIi18Fnt2nvj3UBtvET7Rc7yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvsJe1NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvsJe1NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487ECC4AF09;
	Tue, 23 Jul 2024 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759928;
	bh=7Kb6fA3FhOkCE1X2AH1vXxPO5OacMg5tLa4I2APKoMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvsJe1NCmTErrCIwAux4Gi44Pryc4ZO2cqQLu9AAftYyZucauYNHGFztG93M+DNSF
	 F1qE8vTaaq3n1/HNCPpEZJpOCkI2xBSq0FyAkllsq97KazdcmCt1aiJXbmRQF1zldv
	 Lxuq9T4ADQbWNVWP6nSxLqXZCDWsDp2zuChBpMfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 046/163] nfs: propagate readlink errors in nfs_symlink_filler
Date: Tue, 23 Jul 2024 20:22:55 +0200
Message-ID: <20240723180145.251569344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 134d0b3f2440cdddd12fc3444c9c0f62331ce6fc ]

There is an inherent race where a symlink file may have been overriden
(by a different client) between lookup and readlink, resulting in a
spurious EIO error returned to userspace. Fix this by propagating back
ESTALE errors such that the vfs will retry the lookup/get_link (similar
to nfs4_file_open) at least once.

Cc: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/symlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index 0e27a2e4e68b8..13818129d268f 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -41,7 +41,7 @@ static int nfs_symlink_filler(struct file *file, struct folio *folio)
 error:
 	folio_set_error(folio);
 	folio_unlock(folio);
-	return -EIO;
+	return error;
 }
 
 static const char *nfs_get_link(struct dentry *dentry,
-- 
2.43.0



