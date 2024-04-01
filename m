Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271D41CA8F;
	Mon,  1 Apr 2024 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988360; cv=none; b=EgkAkawT7BOANi410EET/q6Y4S9lFb2+XbboutKeYMirPFp81+4FRZDL5J7RVYM3cGCFILZ/alJjYLxTndhO6YF72G9kH5USmwb3Cxz6UDR46c+ya+f9empzuTJVhBNkloBCpYz7ORHQylAQCjphun1lOvzFcqgMShSUfttFWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988360; c=relaxed/simple;
	bh=uXRFj5m50KVclAc05+uvmqpoa7LgjGb7rRfLzzLfFzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mw4muZdbzVkMxgE2d/kKi7oW5s3c7qSi6Yg4ZI+1y4HE66tDqlyByuklYKiXXfcDQAvFIsY7RT8vX8IImRolQvR13iFe4KYywh4UpfYZsjAcwi6cEvuTWPiGzBmJZuR7ahcT7ZGqXL07Of+qpGV2w0bD983brPzOOiw0QTwtymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sm03jjIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sm03jjIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56517C433C7;
	Mon,  1 Apr 2024 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988360;
	bh=uXRFj5m50KVclAc05+uvmqpoa7LgjGb7rRfLzzLfFzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sm03jjINSvPAzTuFZA29HOY1XJV8GMJN+cHTCVx2t05W+tOewFHJVonqV4nVb2cSY
	 AJJ9dFzp8vSxsrgeC+5mHDfy7ofAo9KDR2uMb4/RyBwmGhfvYd7n9HMGM+2Exp5pAv
	 d7YLOaQIg8W/neKpnj7BGf797Hxm3KeRd+yiab/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 134/432] NFS: Read unlock folio on nfs_page_create_from_folio() error
Date: Mon,  1 Apr 2024 17:42:01 +0200
Message-ID: <20240401152557.129245616@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 11974eec839c167362af685aae5f5e1baaf979eb ]

The netfs conversion lost a folio_unlock() for the case where
nfs_page_create_from_folio() returns an error (usually -ENOMEM).  Restore
it.

Reported-by: David Jeffery <djeffery@redhat.com>
Cc: <stable@vger.kernel.org> # 6.4+
Fixes: 000dbe0bec05 ("NFS: Convert buffered read paths to use netfs when fscache is enabled")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Acked-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 7dc21a48e3e7b..a142287d86f68 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -305,6 +305,8 @@ int nfs_read_add_folio(struct nfs_pageio_descriptor *pgio,
 	new = nfs_page_create_from_folio(ctx, folio, 0, aligned_len);
 	if (IS_ERR(new)) {
 		error = PTR_ERR(new);
+		if (nfs_netfs_folio_unlock(folio))
+			folio_unlock(folio);
 		goto out;
 	}
 
-- 
2.43.0



