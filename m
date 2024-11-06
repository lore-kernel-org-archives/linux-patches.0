Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2451CC89D;
	Wed,  6 Nov 2024 13:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899201; cv=none; b=YOd8ntfRC9icUAeaFe4sAe6dPcerdGmilJc6mji6gm45a8jaQ6DS20U3NZyPvqGHULZHF7a0enlb5hyV1vOm/8nSYTu7woIzEH0RQJglx143AFwqMtspHxoLm7MDkYBt0RChUm2/UNaDfdv+Sx351dZ28igb/PcoBvQky9ioEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899201; c=relaxed/simple;
	bh=prfTi89xlTG5pIBfRRQRORGJ8b6iZlb4ZnRZ01YcO4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ranutM/Db6oj67tNXRqnc/cB1bTvK/oDQSGKhAvbb4879EGptMr8UsURewDWUmYak+127Hj92BCYABUup7N3WYNKSfNJZXt/CwmAeRcKxKkycTM5uIkHJICGTrq7ll9kCu2+j0OY2n2YT3tOhuHNaV6/CgrOrCLSbrQECmqwe94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndqigeGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndqigeGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C70C4CECD;
	Wed,  6 Nov 2024 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899201;
	bh=prfTi89xlTG5pIBfRRQRORGJ8b6iZlb4ZnRZ01YcO4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndqigeGWSvfcXSrWkQadhhusSEI296AehUPnA8sRSJygxFmw+/MOwazpZsPwZbjJp
	 H2RUUyYqemw1AVoruspmWSucsFyi7k5rS8dc3w5ceJXZSg7cLDv3+Ju4nrVSAToLXK
	 JxdnIntVaiRDd0kr+twtf2XCQzxmj8E7L40AAkWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/73] fs/ntfs3: Additional check in ni_clear()
Date: Wed,  6 Nov 2024 13:05:37 +0100
Message-ID: <20241106120300.953599958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d178944db36b3369b78a08ba520de109b89bf2a9 ]

Checking of NTFS_FLAGS_LOG_REPLAYING added to prevent access to
uninitialized bitmap during replay process.

Reported-by: syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 7a1f57dc58dfc..a74bbfec8e3ac 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -101,7 +101,9 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec &&
+	    is_rec_inuse(ni->mi.mrec) &&
+	    !(ni->mi.sbi->flags & NTFS_FLAGS_LOG_REPLAYING))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.43.0



