Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A5173351;
	Wed,  3 Jul 2024 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003467; cv=none; b=eNH2httxjuJifpddUZCZqgU2sjESbfVUdX3ly1HMfGHDHwztx52KUFpb2ypEOzRGPhC7lV/VIxOZkRk1vEbOpPP/XweI5CuVlSXkW6etN0CT10WE8Z5y9Hi/HUEQ0SyDoYFmMjIjFLyNWlVQYH57nIeWG2uc961NCgJ5WncLuXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003467; c=relaxed/simple;
	bh=V75Ply1UlpJt/4OhJQ6LQvGbuCYE4q/XvGjAnKM6GoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAHtfpQ/jyNmlUw+U9opcVdi6iMFaPZkv7sX6NH6OAZrGX2xuSnB7M0k7jyqqvuM+WnkxH8y2G3xaSGUsRacpbUWJIUXCXAJhNVY/CBjIxxSMB4kv4fdN7Bn4u34xFSPYKTT2BDTS125kAURHmpo35M1vXG3bJHJMtxwjdmRRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NbijB0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NbijB0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3515C2BD10;
	Wed,  3 Jul 2024 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003467;
	bh=V75Ply1UlpJt/4OhJQ6LQvGbuCYE4q/XvGjAnKM6GoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NbijB0yYAE+qSJA0xkaxoUyfsyyU1VYPMQ/oEIHhg0E490Q+no9nQt7P6g1ARaAM
	 sROKA0jTbdfG+/o1fxfo8uwMZ5t2rYgewY2YZz1wNlusiZdS9sUHtpmEs0ue2DnMYa
	 8zpnne6Dqm4pmF9NQhVfHK6KuQ5jwfnLp951FcPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/139] nilfs2: Remove check for PageError
Date: Wed,  3 Jul 2024 12:38:43 +0200
Message-ID: <20240703102831.427718858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 79ea65563ad8aaab309d61eeb4d5019dd6cf5fa0 ]

If read_mapping_page() encounters an error, it returns an errno, not a
page with PageError set, so this test is not needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Stable-dep-of: 7373a51e7998 ("nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index eb7de9e2a384e..24cfe9db66e02 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -194,7 +194,7 @@ static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
 	if (!IS_ERR(page)) {
 		kmap(page);
 		if (unlikely(!PageChecked(page))) {
-			if (PageError(page) || !nilfs_check_page(page))
+			if (!nilfs_check_page(page))
 				goto fail;
 		}
 	}
-- 
2.43.0



