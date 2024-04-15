Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEB71B32;
	Mon, 15 Apr 2024 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191043; cv=none; b=pd+nrx0iV/ynWD4gTjOIEnG8avYGYEmwYtWnekNk3JeBBe54uh/Yb3XmS1pLvNKWFWmy3SIqhiRS2ZnjtBKt3oh3kZIP2jYHCyflqgj/YSLeLRQIijH8Ck9rD02KTL3571/mvK1yRLb0YS3hFGGFysoLq5YcLmelwoT0CMHlCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191043; c=relaxed/simple;
	bh=fhE+pqEKez2NbjQlwJ0vN4mDqcerst7fQp5czS2FC08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQHNBBThYE/VpxCXLPCO1oWbuAdqxDz1DhKrsnhoCN4ZxEFsSxbBXKMIfGTRnPMXNuCXfrynt+zJhKfIXdv5EiOKcybCKmPqd1VhyTJbuj1tJEqml8N3GAdjWE0BC0mjVZFyeVG9wpkNndrLTsEF975SS+7A3IsA1DE3Bav0rxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bntKl9Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bntKl9Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1501C113CC;
	Mon, 15 Apr 2024 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191043;
	bh=fhE+pqEKez2NbjQlwJ0vN4mDqcerst7fQp5czS2FC08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bntKl9IlZIzP3nhzYyYXcGhmPDDTI2dytZDhhWB8L7Gtc+0+oJUE3bkb0CpGRJiCc
	 C2mPtn+5Hl9aCM74fo7QJ2Ery6MMXahJUMqpXECXaCaRaHL29yR0dyzTuGg4a3R3fj
	 m++sQdgaWOEPSvDkF30SrD6VpzTtgtvnMGNcu4f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Xiubo Li <xiubli@redhat.org>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.8 006/172] ceph: redirty page before returning AOP_WRITEPAGE_ACTIVATE
Date: Mon, 15 Apr 2024 16:18:25 +0200
Message-ID: <20240415142000.167559459@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b372e96bd0a32729d55d27f613c8bc80708a82e1 upstream.

The page has been marked clean before writepage is called.  If we don't
redirty it before postponing the write, it might never get written.

Cc: stable@vger.kernel.org
Fixes: 503d4fa6ee28 ("ceph: remove reliance on bdi congestion")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -795,8 +795,10 @@ static int ceph_writepage(struct page *p
 	ihold(inode);
 
 	if (wbc->sync_mode == WB_SYNC_NONE &&
-	    ceph_inode_to_fs_client(inode)->write_congested)
+	    ceph_inode_to_fs_client(inode)->write_congested) {
+		redirty_page_for_writepage(wbc, page);
 		return AOP_WRITEPAGE_ACTIVATE;
+	}
 
 	wait_on_page_fscache(page);
 


