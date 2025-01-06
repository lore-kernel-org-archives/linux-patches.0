Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC41DC9BC;
	Mon,  6 Jan 2025 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178191; cv=none; b=WscD7+T+1eVA10gUw3l2yexv0VxNJeX0/AemmLBIV5fUeb9ntovPLkfDVLd9azuSVo9VhG3IWqf1dQae6jSr8rhU/Kvt6z2oTbdbeJS2FKPQbZ6GAH5XfmPr7DLErYuEHmDMmPiffqkdJoZ1guHBuNU8IZTGAgiPdjg69WM1K5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178191; c=relaxed/simple;
	bh=fKei1Berpkx42oMk2US6QrF0/qz+aF6Saa1wRpSk0BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo6BS0eGGwQW4B4ut282ZLh2E0GxZ/UGSnVptswhIUxo2lUrW9eha/4pPmjGrLms1Z8/zudf88eUGESorTG3DynpMB7TYh2g661FzAqFEWHGOwdIfF83XusF3UJRH2H3fya+zywZaCFjc9Fi7d7qpVseL23rZuwzJUmZC6hIEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWhMMVkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWhMMVkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DACC4CED6;
	Mon,  6 Jan 2025 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178191;
	bh=fKei1Berpkx42oMk2US6QrF0/qz+aF6Saa1wRpSk0BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWhMMVkgQwF29Q8OSqoyBKY93kPMJGLOcSNi7kp287w2FhjZswgj/M8RCRULdvOBB
	 c5/oft7SXjAlCLMjm3EahA5r52ILvwrt5vy3x0CanZJ+5XaDRG6SfCKbkCd9j0Wacf
	 1RjJXfxjTtFLVRy9CZGU0+6UK0zPbWi1pAEo3CaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 036/138] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon,  6 Jan 2025 16:16:00 +0100
Message-ID: <20250106151134.590757025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 62e2a47ceab8f3f7d2e3f0e03fdd1c5e0059fd8b upstream.

When the server is recalling a layout, we should ignore the count of
outstanding layoutget calls, since the server is expected to return
either NFS4ERR_RECALLCONFLICT or NFS4ERR_RETURNCONFLICT for as long as
the recall is outstanding.
Currently, we may end up livelocking, causing the layout to eventually
be forcibly revoked.

Fixes: bf0291dd2267 ("pNFS: Ensure LAYOUTGET and LAYOUTRETURN are properly serialised")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1199,7 +1199,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


