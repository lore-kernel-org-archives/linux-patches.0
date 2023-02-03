Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535991FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68C5C433EF;
	Fri,  3 Feb 2023 10:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419908;
	bh=G/su3jtvzH9r0NThXvyHeCffHzpTOyo5BMuGrBz7T14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N18GOy4tnoXBDEWyy/jHWuxWaIzDOiEZT+93EdihTbANRlQ81TWAeMzYPynmsEngH
	 rCBcXB8F4B+WKb0m6kCfNx3wQ3F8xXiJ5GMReNF+zR1QFiSDizS4RcTbB9rbI1kvHw
	 zqhfDs5XMPPyGEn0Ty7dXIg4dJxnSnoSm6W8m34U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/134] affs: initialize fsdata in affs_truncate()
Date: Fri,  3 Feb 2023 11:12:02 +0100
Message-Id: <20230203101024.632714775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Potapenko <glider@google.com>

[ Upstream commit eef034ac6690118c88f357b00e2b3239c9d8575d ]

When aops->write_begin() does not initialize fsdata, KMSAN may report
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Fixes: f2b6a16eb8f5 ("fs: affs convert to new aops")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index ba084b0b214b..82bb38370aa9 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -878,7 +878,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
-- 
2.39.0



