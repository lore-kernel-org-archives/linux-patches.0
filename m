Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F024CDDC5;
	Wed, 30 Sep 2026 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784176; cv=none; b=mrbM6aRlbWJy0U/bdP44I/OB5Dc0iYxU+2bfuPgcuG8/2PPb9yczrs32kqCmP06FOabAsNy7k/TpNClW2nHaLg6c0qP+H/bnKbFgT7hxboZYS7awzJ7zEbLzQMzrFrqoodjb5KIddd+mwwmjTmkZrOVbtszujRPrGrOE//N14U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784176; c=relaxed/simple;
	bh=X2vINqQ8XIycAB0cri+fBWr7A2JnZ4Eus21FUGGUrCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXSEd9u5mQjH4G7biM8IMvmNn2vu3CT/9sE+ecWAkoG0GHgo8emJOG3ZNduHc7n+q8OPghTwl6PlXSDsjUyyszTK/cr9x5DYbA+6/miZbM+P2buZKjIU5d/ed6LmmOO32gdowH0Rp2l5OX0kvHdV4xitVNN40VCG+xeJjYSJIg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOM+OJGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOM+OJGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8A11F00898;
	Wed, 30 Sep 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784173;
	bh=bQxp+OfRhTbNwykj3Q3OaNWiZt4Z1W9+LHoh36BuJwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOM+OJGA+4gBcGe/h79la+m+wpjYk/VbRo6ZISHWhiIri79OKcRLeOWgCm4dSblSH
	 L4FtI7376eiMMU4ykqg/Wi60rsveF3KGxYZuGv1qFwe4bXuy/PDsYpjl5pLr7IxtyR
	 bV7lKa141nkwOuGZ8yQUDeAkXSBa9SDa3S72s/no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coster <matt.coster@imgtec.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/982] bitfield: wire __bf_shf to __builtin_ctzll
Date: Wed, 30 Sep 2026 17:13:16 +0200
Message-ID: <20260930152418.085116671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yury Norov <ynorov@nvidia.com>

[ Upstream commit 09472f591aa0b72c2dd6c693f48b2d6fea66c7ba ]

__bf_shf() is currently based on built-in ffsll. It's more
straightforward to wire it to __builtin_ctzll, which makes it a pure
rename.

Worth to notice that __builtin_ffsll() is buggy on GCC before 14.1:

  int main() {
      sizeof(struct {
          int t : !(__builtin_ffsll(~0ULL) + 1 < 0);
      });
  }

  test.c: In function 'main':
  test.c:3:21: error: bit-field 't' width not an integer constant
      3 |                 int t : !(__builtin_ffsll(~0ULL) + 1 < 0);
        |                     ^

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124699
Reported-by: Matt Coster <matt.coster@imgtec.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603222211.A2XiR1YU-lkp@intel.com/
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 35622ff2c9951..65646d4917658 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -43,7 +43,7 @@
  *  reg |= FIELD_PREP(REG_FIELD_C, c);
  */
 
-#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+#define __bf_shf __builtin_ctzll
 
 #define __scalar_type_to_unsigned_cases(type)				\
 		unsigned type:	(unsigned type)0,			\
-- 
2.53.0



