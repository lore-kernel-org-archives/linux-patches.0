Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7522F2B;
	Wed,  1 Feb 2023 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092EBC433EF;
	Wed,  1 Feb 2023 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675269654;
	bh=KSq1dYBd01CzJMTzCKqs3/YS7g3At35mPs1z5Nkv6oc=;
	h=From:Date:Subject:To:Cc:From;
	b=pLn5/92olQ9nSSmkCMuwj0xDGN1IQyrCHURuiCr6Yvz7DZZ1xzj0xwncGpVapYgKQ
	 x4UvvH4nl69IDx71CiE4rchBSe1rgHO7f9apalpCeBREUYDCz5ElsKhCTxmdqgeWZb
	 HW3kqmUR7ema+E5KwMX9p8Qw1Wt9kTg+3tJ54GAdsVBSliJTPlexPoHFX6Pqs9vHNt
	 FuWxniMl4FOnxoOb63OEjHbv+Hy4djOvVAgfbC4PE9ZSstEA/uplUO9Uw69qKeOtjv
	 eD10TIBYkwn0+/8XsYM8lWlorSD3E6DFhdMAVsb1GF5LWCWnkOCnMzd0JPjaGuvswv
	 cEBdt5pe/n7VA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 01 Feb 2023 09:40:22 -0700
Subject: [PATCH] f2fs: Fix type of single bit bitfield in f2fs_io_info
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230201-f2fs-fix-single-length-bitfields-v1-1-e386f7916b94@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPWV2mMC/x3NywoCMQyF4VcZsjbQqQuLryIueknbQK2SFBkY5
 t3tuPw58J0dlIRJ4b7sIPRl5XefsV4WiNX3QshpNlhjr8aaFbPNipk3VO6lETbqZVQMPDJTS4o
 puxhvjpwzHiYTvBIG8T3WE3p5HSTn8BGazv/78TyOHxPv+SWLAAAA
To: jaegeuk@kernel.org, chao@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, 
 linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2740; i=nathan@kernel.org;
 h=from:subject:message-id; bh=KSq1dYBd01CzJMTzCKqs3/YS7g3At35mPs1z5Nkv6oc=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMm3ponK+HZaB8susOx5+HD3Be2z2eVxq2sn7JBWWu25+
 rurt5dkRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjI9mWMDPfVpHOfPMr9qxNd
 +XXlDeYXhpfDFJcrCvdG5SS3y3AxcjH8Zu25G351up/Ea2X55u0n3/jZu72XDg3IWCFu69pUIRL
 ADgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  ../fs/f2fs/data.c:995:17: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
          fio->submitted = 1;
                         ^ ~
  ../fs/f2fs/data.c:1011:15: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
                          fio->retry = 1;
                                     ^ ~

  ../fs/f2fs/segment.c:3320:16: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
                  fio->in_list = 1;
                               ^ ~

There is not a bug here because the value of these fields is never
explicitly compared against (just whether it is zero or non-zero) but
it is easy to silence the warning by using an unsigned type to allow
an assignment of 0 or 1 without implicit conversion.

Fixes: 998863dadd2c ("f2fs: reduce stack memory cost by using bitfield in struct f2fs_io_info")
Link: https://github.com/ClangBuiltLinux/linux/issues/1796
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/f2fs/f2fs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 08dc64c5050e..89f6fdfeed19 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1213,12 +1213,12 @@ struct f2fs_io_info {
 	int compr_blocks;	/* # of compressed block addresses */
 	int need_lock:8;	/* indicate we need to lock cp_rwsem */
 	int version:8;		/* version of the node */
-	int submitted:1;	/* indicate IO submission */
-	int in_list:1;		/* indicate fio is in io_list */
-	int is_por:1;		/* indicate IO is from recovery or not */
-	int retry:1;		/* need to reallocate block address */
-	int encrypted:1;	/* indicate file is encrypted */
-	int post_read:1;	/* require post read */
+	unsigned int submitted:1;	/* indicate IO submission */
+	unsigned int in_list:1;		/* indicate fio is in io_list */
+	unsigned int is_por:1;		/* indicate IO is from recovery or not */
+	unsigned int retry:1;		/* need to reallocate block address */
+	unsigned int encrypted:1;	/* indicate file is encrypted */
+	unsigned int post_read:1;	/* require post read */
 	enum iostat_type io_type;	/* io type */
 	struct writeback_control *io_wbc; /* writeback control */
 	struct bio **bio;		/* bio for ipu */

---
base-commit: de6b3a5e09b29c014bd04044b023896107cfa2ee
change-id: 20230201-f2fs-fix-single-length-bitfields-df8cc78e880a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

