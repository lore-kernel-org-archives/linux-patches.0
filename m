Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7DF13B79F;
	Tue, 27 Feb 2024 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041959; cv=none; b=ioPesDE4QoOfHjK9uUzf/QRdm8b3uecQS/LpdP4qGA/Ezedf+DkwyjtHzHtJQMvqvXmVvGZezw3+dyCYPeRzwtUDrgfaQaoAWBTTdHZ33M55u3HLevveRqgQ6CI0eAczLgDh0ruwO2la1xMnOoXBZbqvlQNIXcGbIHDD6Zk6dUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041959; c=relaxed/simple;
	bh=Rr4Cj0NLbXRRp9cNRw8xcl+RE2jV9JEIw7FiqZ4MsyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIsCEQLioxL1yECaSzB0JbTrdbTz8Z1jbXthYsR0DnEbn3s/95KaIZDkqMiImKLHLebiSFYjhT9cm7aHOn8/qK8aiTXU1i30mEsDhWFiwmXYcrWL9Y/kxls8g3zKfQyiGPRByGXf5XViuaa6InHUG8OXtTL1x59JwxWtmC5xBbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW/qZJLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW/qZJLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2BEC433F1;
	Tue, 27 Feb 2024 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041959;
	bh=Rr4Cj0NLbXRRp9cNRw8xcl+RE2jV9JEIw7FiqZ4MsyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW/qZJLGvnvxwVv4MpGshgSidLJImXO+GaA0Ov6RaIoygXo4oOdou0PY9GFqaSDan
	 VqSvjjdBj2I53xmnSv/cGX8Xw84QZY1NjJMVpHOCeT/1/Zfds/VBlt0r4GD2XD3rAy
	 OfFdQdMq/Jfpb3uPlGm8ZZF7nvOlXkVNB9zGzV7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Subject: [PATCH 6.6 091/299] fs/ntfs3: Fix oob in ntfs_listxattr
Date: Tue, 27 Feb 2024 14:23:22 +0100
Message-ID: <20240227131628.837396241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 731ab1f9828800df871c5a7ab9ffe965317d3f15 ]

The length of name cannot exceed the space occupied by ea.

Reported-and-tested-by: syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 838a79157fb99..b50010494e6d0 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -219,6 +219,9 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
+		if (ea->name_len > ea_size)
+			break;
+
 		if (buffer) {
 			/* Check if we can use field ea->name */
 			if (off + ea_size > size)
-- 
2.43.0



