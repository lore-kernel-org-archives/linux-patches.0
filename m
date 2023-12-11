Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51CE4437B;
	Mon, 11 Dec 2023 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v09rJPEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A42CC433C7;
	Mon, 11 Dec 2023 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320317;
	bh=LMe7R7mjFG0unsOaoug4galSgbemyKhQhGs29b0lhHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v09rJPEB7/tAsFi6FCDLkXpXYujw4TN8doqSF+CEuGayD7DYuxvxp29+cSxJi73Ac
	 V9ex2Yu+3vPJdm7Hy61ARz8JOWT8Pg3CgcvIbP6aRUaBHegcuOt7xU5mAZvbTm4ARL
	 +HOlZbVChwBS2o4cVJRzc+j3CRMfxLzOyPtHFrRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f2eb3e8cd123ffce499@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Terrell <terrelln@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/194] zstd: Fix array-index-out-of-bounds UBSAN warning
Date: Mon, 11 Dec 2023 19:19:55 +0100
Message-ID: <20231211182036.853545606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Terrell <terrelln@fb.com>

[ Upstream commit 77618db346455129424fadbbaec596a09feaf3bb ]

Zstd used an array of length 1 to mean a flexible array for C89
compatibility. Switch to a C99 flexible array to fix the UBSAN warning.

Tested locally by booting the kernel and writing to and reading from a
BtrFS filesystem with zstd compression enabled. I was unable to reproduce
the issue before the fix, however it is a trivial change.

Link: https://lkml.kernel.org/r/20231012213428.1390905-1-nickrterrell@gmail.com
Reported-by: syzbot+1f2eb3e8cd123ffce499@syzkaller.appspotmail.com
Reported-by: Eric Biggers <ebiggers@kernel.org>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nick Terrell <terrelln@fb.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/common/fse_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/common/fse_decompress.c b/lib/zstd/common/fse_decompress.c
index 2c8bbe3e4c148..f37b7aec088ec 100644
--- a/lib/zstd/common/fse_decompress.c
+++ b/lib/zstd/common/fse_decompress.c
@@ -312,7 +312,7 @@ size_t FSE_decompress_wksp(void* dst, size_t dstCapacity, const void* cSrc, size
 
 typedef struct {
     short ncount[FSE_MAX_SYMBOL_VALUE + 1];
-    FSE_DTable dtable[1]; /* Dynamically sized */
+    FSE_DTable dtable[]; /* Dynamically sized */
 } FSE_DecompressWksp;
 
 
-- 
2.42.0



