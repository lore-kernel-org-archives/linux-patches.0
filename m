Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904C3268C73;
	Tue, 12 Aug 2025 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021131; cv=none; b=piU/cPHG/R+22kkq035Vhyil4nE2HHxN1oW2jGeZeHhMBn6MZiHD9BRdbD8CneiHEuPYB777VQq/dvFkzFmr+DwngwFXe2SprijtOxirHV8K3J+x46TPsj2aSxsi1AH8tOP6GcdLDvEihj5Wj3Oe2pM6Hsdbh9LiMrH8oYuv40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021131; c=relaxed/simple;
	bh=FiN+R9QUHs+HF+95V367Y0TTdJmRYDewAI4Cm5B0kOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jv/8X5I+Hsp0Cvx5PBoY8iJ3iW1aZF9XK1fCHBc6gsXIu2iZ+WTCrkgJiOZR0nMmIRgesunBdBdg4u3Mwp/kigRi5ACg9+P8pfH9iyhBoFeCk6Euhob5zpRcK9gFggbLYDcL8gCPl+BGaJYhOZDoKkzOmgYZYuhLfrPJSC7NY7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlEvMbAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlEvMbAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170D7C4CEF0;
	Tue, 12 Aug 2025 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021131;
	bh=FiN+R9QUHs+HF+95V367Y0TTdJmRYDewAI4Cm5B0kOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlEvMbAE/L2BYqAMGi7NbUtLarJ/0AH7TNEwrQkc8scA5cAznH+NzcrhsV8W6Orkd
	 88sR7jOlnsQRcwyh5qDtRmpuM1+Q86ly61cHOorsr4Ml+FZ1npiTT3lB9V0gvvxgll
	 pV21msiJHSHncYpvzlnwePegaT+kOCOLdcpv9ZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Hejtm=C3=A1nek?= <xhejtman@ics.muni.cz>,
	Santosh Pradhan <santosh.pradhan@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/253] NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()
Date: Tue, 12 Aug 2025 19:30:02 +0200
Message-ID: <20250812172957.939342520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1db3a48e83bb64a70bf27263b7002585574a9c2d ]

Use store_release_wake_up() to add the appropriate memory barrier before
calling wake_up_var(&dentry->d_fsdata).

Reported-by: Lukáš Hejtmánek<xhejtman@ics.muni.cz>
Suggested-by: Santosh Pradhan <santosh.pradhan@gmail.com>
Link: https://lore.kernel.org/all/18945D18-3EDB-4771-B019-0335CE671077@ics.muni.cz/
Fixes: 99bc9f2eb3f7 ("NFS: add barriers when testing for NFS_FSDATA_BLOCKED")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1876978107ca..3c98049912df 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1825,9 +1825,7 @@ static void block_revalidate(struct dentry *dentry)
 
 static void unblock_revalidate(struct dentry *dentry)
 {
-	/* store_release ensures wait_var_event() sees the update */
-	smp_store_release(&dentry->d_fsdata, NULL);
-	wake_up_var(&dentry->d_fsdata);
+	store_release_wake_up(&dentry->d_fsdata, NULL);
 }
 
 /*
-- 
2.39.5



