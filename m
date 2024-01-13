Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557361EF1C;
	Sat, 13 Jan 2024 10:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxqIq6Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6450C433C7;
	Sat, 13 Jan 2024 10:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140144;
	bh=O2ybDPFZCpFtp3sDjRHcRkkqQvUVSS6RiY07fGqjuhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxqIq6NnKpCylg8LhWT5hBjZDZL2TPXn0jqYBJouc9uzD17biSJtd5kNC5Ado8oLO
	 OJYworGBJ2ip56sWJRJfryrtzX1HNsH2QCKC7Zf1LQV+VGZCd5ejE37SvxILf5yCbI
	 g82UMPl4OjnWQ15p9euy7FbPg9sMBVsuU3XWOurc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 1/4] cifs: fix flushing folio regression for 6.1 backport
Date: Sat, 13 Jan 2024 10:50:39 +0100
Message-ID: <20240113094204.068608649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
References: <20240113094204.017594027@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

filemap_get_folio works differenty in 6.1 vs. later kernels
(returning NULL in 6.1 instead of an error).  Add
this minor correction which addresses the regression in the patch:
  cifs: Fix flushing, invalidation and file size with copy_file_range()

Suggested-by: David Howells <dhowells@redhat.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode
 	int rc = 0;
 
 	folio = filemap_get_folio(inode->i_mapping, index);
-	if (IS_ERR(folio))
+	if ((!folio) || (IS_ERR(folio)))
 		return 0;
 
 	size = folio_size(folio);


