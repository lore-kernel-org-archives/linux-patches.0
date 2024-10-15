Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927911AF0CE;
	Tue, 15 Oct 2024 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998418; cv=none; b=c6s57zoGlPg39EpDvMNYeVgyAXmzNj2IHP09gJpaLhP87Tsl+yBtQhNQAyl/qneBfYreicK8+gyjxzG5jt1C9BsXtOAKZbQnJRB4ZeUGsgwt7T4gksE6MTs2751gXzuxXJlo4K+EloG5eVLv1xWq6m8RjYXOG2JQAaAuxkW62KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998418; c=relaxed/simple;
	bh=w9r8q/E+THRrfZeiPswinzHiv6Vory82eSR53h98C70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkBqfCDncrJhNcJUIK2CLxhNTQLGkB+G9ZU0Z2upe+c+il7QRHSc/h+U5+vqFGqyOHYYFRlQa6MPnVeoLpdk7ayiezP20P9aTe79EiUO7x6d7d/lJeJAFaM30HtB0tOKRyzSTdX+ttcuwwN49vLw3rNFxwb42IPBkybwnMiLg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsUn4BbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsUn4BbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64FEC4CED3;
	Tue, 15 Oct 2024 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998418;
	bh=w9r8q/E+THRrfZeiPswinzHiv6Vory82eSR53h98C70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsUn4BbYWyiZoU3qUfZzr2pmUiprhJpJuDNWpG6+xwSX0qf6nkt+xMJxMRFT3+C2d
	 Ksoh6Ht+/Qn4E18JRpaZQ5OHjQygobqPrSwR1cO3yrWZOmavAZNAgnOaXoKiHScVGd
	 z4kFnj7F8rjZTdIdmw/vuc7HXsj+b7oXW4TikKVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 440/518] s390/zcore: no need to check return value of debugfs_create functions
Date: Tue, 15 Oct 2024 14:45:44 +0200
Message-ID: <20241015123933.988033996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit 7449ca87312a5b0390b765be65a126e6e5451026 ]

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

See commit 7dd541a3fb34 ("s390: no need to check return value of debugfs_create functions").

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 0b18c852cc6f ("tracing: Have saved_cmdlines arrays all in one allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/zcore.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 3841c0e77df69..5f659fa9224a3 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -302,28 +302,12 @@ static int __init zcore_init(void)
 		goto fail;
 
 	zcore_dir = debugfs_create_dir("zcore" , NULL);
-	if (!zcore_dir) {
-		rc = -ENOMEM;
-		goto fail;
-	}
 	zcore_reipl_file = debugfs_create_file("reipl", S_IRUSR, zcore_dir,
 						NULL, &zcore_reipl_fops);
-	if (!zcore_reipl_file) {
-		rc = -ENOMEM;
-		goto fail_dir;
-	}
 	zcore_hsa_file = debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir,
 					     NULL, &zcore_hsa_fops);
-	if (!zcore_hsa_file) {
-		rc = -ENOMEM;
-		goto fail_reipl_file;
-	}
-	return 0;
 
-fail_reipl_file:
-	debugfs_remove(zcore_reipl_file);
-fail_dir:
-	debugfs_remove(zcore_dir);
+	return 0;
 fail:
 	diag308(DIAG308_REL_HSA, NULL);
 	return rc;
-- 
2.43.0



