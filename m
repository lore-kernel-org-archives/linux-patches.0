Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C98F12C544;
	Mon, 23 Dec 2024 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970556; cv=none; b=STD/Uy+PvCXqKSOmoA2isNEEZzuo7CqVppKFHs0htS0BAXROMZKirQKaEUeITMA1/e3K6NU1BvOILbcwFCuQcvLFv1R3NvZKeh/Y78GjHEPYMKgfU3cTgk7wad5nE+q31ck5nO7HzXfmVnT8fdTgkkXX09Xg5gG3iUflJQ5/lqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970556; c=relaxed/simple;
	bh=izV76XIKgDDhOZWP7qWKc4guhlsmm3WMrnEZ7QcLwrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anzszTTMDH9Z6c1MEQILHxHjY3i6TvEtEVUi4ZFtYy98UBROqpSM/Kv3jSwk+NeLo7DB9d5kuq8uMqVrr6C0PCMYnflmZ2SB96TS6oJ3liUen6H8RVMBZdeIwhAiN14SaSGXjVhIP54ON0JHVMExyNGesnbiLHZt4Cq2zMj2wks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEltHLG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEltHLG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E62C4CED3;
	Mon, 23 Dec 2024 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970556;
	bh=izV76XIKgDDhOZWP7qWKc4guhlsmm3WMrnEZ7QcLwrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEltHLG38+rfd3FCfZQkJO19vaSE4o61vr4bm+noRkwGnJDDkBxO7//WjwThw2e6l
	 u++2n7GG0LHa75Gy34aFb/M270OKSVkI8WC+rAqiL5tXYozpH9RYaRFL76htrcGYyw
	 GXpXqDke/qxrmadG7XDEzDPxubewjWCT3MsYeWCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 099/116] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon, 23 Dec 2024 16:59:29 +0100
Message-ID: <20241223155403.409744429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1196,7 +1196,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


