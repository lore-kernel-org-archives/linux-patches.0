Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258651FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE09C433EF;
	Fri,  3 Feb 2023 10:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419333;
	bh=G/su3jtvzH9r0NThXvyHeCffHzpTOyo5BMuGrBz7T14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5t8CIzFaXmHOWqbjgVTsH3ev4efcCVJaSQ9I5Jazt8DUgy3727Ro+By4ljFBPXhL
	 VmEsjv4x5mIDOaz37qdGeJIHCHSn/cGIZ6TNLy+W7fxRKzps8rIudJPHLSpNw3EWNr
	 Dj8iqs9ItO2njvIeNn5jod0SFS382Ry1mlbg/lEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/62] affs: initialize fsdata in affs_truncate()
Date: Fri,  3 Feb 2023 11:12:03 +0100
Message-Id: <20230203101013.300404674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
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



