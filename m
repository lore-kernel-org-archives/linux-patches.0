Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE853C37;
	Tue,  4 Oct 2022 14:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BDCC433D6;
	Tue,  4 Oct 2022 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664894523;
	bh=29LvEzDal7lMcf+KcEq8WBvv30fyBigvxIzqI3Lkl60=;
	h=From:To:Cc:Subject:Date:From;
	b=ZEm2Z6obrk5OW5mYmqkV/bW7P0jbV6JTaq/qP01eAHmzph4t0eLPXMZHdVt7KRtv1
	 saGsEGonUQGcgB4u0H3uiskgJ63dZzT0NPqfglHfuKQiZbo3JlkBNqiQX11YPaaEcx
	 TLJXg1vCY97+A8BbbqhcbAa3K0XFD0xEeqHvuwOkk9efJXwtS08KK/30hJ4NUsPaHP
	 KCo+Lf+SiXP6WhMvHQkRM2nQyxe9KEivOv+5w4+j/bU3GNytNLWQbrY1taRjj2QSkP
	 P3QUltcPErh5LnkmUGQZgGvv4ARZkG9zL0Wtjz8HdoFi223JkHfQSpY8GEjyBFOH96
	 kyaw89syy2uNA==
From: Nathan Chancellor <nathan@kernel.org>
To: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	ntfs3@lists.linux.dev,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] fs/ntfs3: Don't use uni1 uninitialized in ntfs_d_compare()
Date: Tue,  4 Oct 2022 07:41:45 -0700
Message-Id: <20221004144145.1345772-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  fs/ntfs3/namei.c:445:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
                  if (toupper(c1) != toupper(c2)) {
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
  ./include/linux/ctype.h:64:20: note: expanded from macro 'toupper'
  #define toupper(c) __toupper(c)
                    ^
  fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
          __putname(uni1);
                    ^~~~
  ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
  #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
                                                                        ^~~~
  fs/ntfs3/namei.c:445:3: note: remove the 'if' if its condition is always false
                  if (toupper(c1) != toupper(c2)) {
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fs/ntfs3/namei.c:434:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
                  if (!lm--) {
                      ^~~~~
  fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
          __putname(uni1);
                    ^~~~
  ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
  #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
                                                                        ^~~~
  fs/ntfs3/namei.c:434:3: note: remove the 'if' if its condition is always false
                  if (!lm--) {
                  ^~~~~~~~~~~~
  fs/ntfs3/namei.c:430:22: note: initialize the variable 'uni1' to silence this warning
          struct cpu_str *uni1, *uni2;
                              ^
                              = NULL
  2 errors generated.

There is no point in calling __putname() in these particular error
paths, as there has been no corresponding __getname() call yet. Just
return directly in these blocks to clear up the warning.

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Link: https://github.com/ClangBuiltLinux/linux/issues/1729
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/ntfs3/namei.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 315763eb05ff..5d3a6ce3f05f 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -431,10 +431,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 
 	/* First try fast implementation. */
 	for (;;) {
-		if (!lm--) {
-			ret = len1 == len2 ? 0 : 1;
-			goto out;
-		}
+		if (!lm--)
+			return len1 == len2 ? 0 : 1;
 
 		if ((c1 = *n1++) == (c2 = *n2++))
 			continue;
@@ -442,10 +440,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 		if (c1 >= 0x80 || c2 >= 0x80)
 			break;
 
-		if (toupper(c1) != toupper(c2)) {
-			ret = 1;
-			goto out;
-		}
+		if (toupper(c1) != toupper(c2))
+			return 1;
 	}
 
 	/*

base-commit: d45da67caedacd500879de5e649360cc70777af7
-- 
2.37.3

