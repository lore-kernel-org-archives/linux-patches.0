Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90158494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356D8C4339E;
	Fri, 10 Mar 2023 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459115;
	bh=+pvfP/Cc/CmsuT57ZpwsTph4NdMYNSmLsN5I4gbxsBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqZTJXT6g/bmBUrog+3IFH0ncQZqpRHrvRhVtL9wLxT4+nn2YecADG5iRHH9JWz10
	 RUl5eVCKENO+5eFOmae9mXouQpH2ETz1CF754AGyluU5XwM+CAdOuDctOkLWkOUsv9
	 VXwv7ltlsKNhkscmuh/L8RMRHPCiBdJajaAvoFQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Biggers <ebiggers@google.com>,
	Tejun Heo <tj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 222/357] f2fs: fix cgroup writeback accounting with fs-layer encryption
Date: Fri, 10 Mar 2023 14:38:31 +0100
Message-Id: <20230310133744.535961764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 844545c51a5b2a524b22a2fe9d0b353b827d24b4 upstream.

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), f2fs encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -496,7 +496,7 @@ int f2fs_submit_page_bio(struct f2fs_io_
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
@@ -575,7 +575,7 @@ alloc_new:
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
 
@@ -652,7 +652,7 @@ alloc_new:
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 	f2fs_trace_ios(fio, 0);


