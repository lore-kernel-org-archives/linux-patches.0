Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633893EDE48;
	Tue, 12 May 2026 18:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609249; cv=none; b=Jst+6KJZ5+nndzs9xdiBvXqEA/FX41I9sHWWRfhY8k5dkDaMpMuCM6TwZTVE7yomMLA2PVYlY3QYDr1YtfT9ZVuMc1eXTS3NobXByyFH9N65ZvVGrtJAgP5Oa6o71YjRPNmaDhKgo4KR0acpL+y2uKaK0dtiJpPrdng/rKPig7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609249; c=relaxed/simple;
	bh=GHsqL6JUxJasZGsFFhcjEIsVpfeIngIKscQOh/y30B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1nB6qkWgM7APSddJB6E1EdG1qSdmldnQyOl5UbrjC4toRaG8+4bIQZ1puO6SL8vDiiNPhQ1WupEhubiN6wvDabGlMHTcPWbWj9rwxMlwPaXTZCtJrhj2Vh3t1FLRnwk1dEOnHv2Xwa6Ifnuot9h+7Qk3ziwBaFiizLOlviRijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY2IUD0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY2IUD0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C25C2BCB0;
	Tue, 12 May 2026 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609249;
	bh=GHsqL6JUxJasZGsFFhcjEIsVpfeIngIKscQOh/y30B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY2IUD0c6TBnTD87ibx26CnpW0C1wSl1vnLOLj7ZUya93PUIBX1VC1R/J/lcleYwk
	 Z2p93SFVGQ2LAZevUk7T127w/zJxUz3CGUOZ1Br9HjOLslMLwBNWE6hmPOwWXqnAGL
	 XcWXfQX0npQUfPo76WK0oZgNkwiWJ5vNSZjXS9MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Walters <walters@verbum.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.0 123/307] ovl: fix verity lazy-load guard broken by fsverity_active() semantic change
Date: Tue, 12 May 2026 19:38:38 +0200
Message-ID: <20260512173942.725345572@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Walters <walters@verbum.org>

commit 0c8c88b8eb82a2a41bec5f17c076d6312dc40316 upstream.

Commit f77f281b6118 ("fsverity: use a hashtable to find the
fsverity_info") made fsverity_active() check whether the inode has the
verity flag, rather than whether the inode's fsverity_info is loaded.
This broke ovl_ensure_verity_loaded(), which wants to load the
fsverity_info for any verity inodes that haven't had it loaded yet.

Therefore, to check that the fsverity_info hasn't yet been loaded, use
fsverity_get_info(inode) == NULL instead of !fsverity_active(inode).

Also, since fsverity_get_info() now involves a hash table lookup, put
the more lightweight IS_VERITY() flag check first.

Fixes: f77f281b6118 ("fsverity: use a hashtable to find the fsverity_info")
Cc: stable@vger.kernel.org
Link: https://github.com/bootc-dev/bootc/issues/2174
Signed-off-by: Colin Walters <walters@verbum.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260505224257.23213-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1379,7 +1379,7 @@ int ovl_ensure_verity_loaded(const struc
 	struct inode *inode = d_inode(datapath->dentry);
 	struct file *filp;
 
-	if (!fsverity_active(inode) && IS_VERITY(inode)) {
+	if (IS_VERITY(inode) && fsverity_get_info(inode) == NULL) {
 		/*
 		 * If this inode was not yet opened, the verity info hasn't been
 		 * loaded yet, so we need to do that here to force it into memory.


