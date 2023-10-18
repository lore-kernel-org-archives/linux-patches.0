Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6543FE54;
	Wed, 18 Oct 2023 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0NBQx/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AC1C433C8;
	Wed, 18 Oct 2023 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697652642;
	bh=LHAZNYWjlZE9o69WQzFu8+hQ8gDUBGEq47VgG8s8Jbo=;
	h=From:Date:Subject:To:Cc:From;
	b=d0NBQx/8FT0zlB+fVZUbNnWE/GyAwzzz7pIV+Dwma+/2ur8BYFMvKqPaXK0g+aC7k
	 YBJVOzNaTz1DHqUKaYKtJyRRqs7LX64eod8ISgBjcZtt6WRJ1lh0csPAddtxZILqVD
	 KH8fLCCEPUVZB3FKUQleCdKdFdvKLN4aS1tSeIWg2wfdrIKQinxiypcohiDmoIzTE6
	 sU+cn3arw3tF62wk26PoJm8PVoYHYwUHB+pL0B2PXJAADRblAlOruQxD+F0gwD3fuv
	 voo+23LmG60T4KDOrg2uh94e+PdZjzPVzSvnxW1XBEEAdw44g1BfP0ckogdqHE9coj
	 htOWjJ8BuMkGw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 18 Oct 2023 11:10:31 -0700
Subject: [PATCH] eventfs: Use ERR_CAST() in eventfs_create_events_dir()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231018-ftrace-fix-clang-randstruct-v1-1-338cb214abfb@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJYfMGUC/x3MQQqEMAxA0atI1hNoK4rOVYZZ1Bg1IJ0hrSKId
 ze4/PD4J2RW4Qzv6gTlXbL8koV/VUBLTDOjjNYQXKi98x1ORSMxTnIgrQZQYxpz0Y0KOhraru+
 bUEcCO/yVzT33z/e6bhnL/RptAAAA
To: rostedt@goodmis.org, mhiramat@kernel.org
Cc: keescook@chromium.org, ndesaulniers@google.com, trix@redhat.com, 
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1442; i=nathan@kernel.org;
 h=from:subject:message-id; bh=LHAZNYWjlZE9o69WQzFu8+hQ8gDUBGEq47VgG8s8Jbo=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKkG8gtn+x73+DjpvvHTQGGfrms5qe6ib3NTH/5dYsv6e
 1MS01a2jlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRpxkM/9N3rpAIVniru/n1
 zDihy8cf228q/74i7JGmWcvNc7s/Jl9j+MNb9fT7wmWy626JpE1h/3/Q+ovP4dfuoRysIREXG2d
 3L+EAAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang and CONFIG_RANDSTRUCT_FULL=y, there is an error
due to a cast in eventfs_create_events_dir():

  fs/tracefs/event_inode.c:734:10: error: casting from randomized structure pointer type 'struct dentry *' to 'struct eventfs_inode *'
    734 |                 return (struct eventfs_inode *)dentry;
        |                        ^
  1 error generated.

Use the ERR_CAST() function to resolve the error, as it was designed for
this exact situation (casting an error pointer to another type).

Closes: https://github.com/ClangBuiltLinux/linux/issues/1947
Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/tracefs/event_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 1ccd100bc565..9f19b6608954 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -731,7 +731,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 		return NULL;
 
 	if (IS_ERR(dentry))
-		return (struct eventfs_inode *)dentry;
+		return ERR_CAST(dentry);
 
 	ei = kzalloc(sizeof(*ei), GFP_KERNEL);
 	if (!ei)

---
base-commit: 5ddd8baa4857709b4e5d84b376d735152851955b
change-id: 20231018-ftrace-fix-clang-randstruct-0cb6899523ac

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

