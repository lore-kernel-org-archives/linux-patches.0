Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27D350128B;
	Thu, 17 Sep 2026 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661352; cv=none; b=Dp0/DxmQh+87q29tY/IS5YYQ66mvQ1aBmNRMLXEfKXntodXZu8n6BH3HlicMFzZnm54fX7d/9TLg3Fz8lKb38UGEUUkUBMIvbf6KNTV99zgLMQ44gFXPKXkBEAjsYFsuSUw+UP19UrlrRXpTPZ6C4AoovnR+RbvSMo/xlN8Cfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661352; c=relaxed/simple;
	bh=GIjRD5UyC1MXFX1dDrcEjqS08ZwkK9kOJNMJTik0a4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7ylVkW1iFsqAQblsi7aK8/oyy9XEzspKtCVD3vs510olZ3EbAWuDpA1EPpj4VvyItUxt4GtiFU/cu2FjSk6VmTg/SKEp+Dq6lkmzDgfhvwGGAMEwlRL0BcICShgFiwEMmDZLxR/60xq/ek1fSQzTF1DlqJ2on0N4DjCvXr4b78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2Xu9P0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2Xu9P0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9061F00893;
	Thu, 17 Sep 2026 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661350;
	bh=dAF1ILC4Sl5HThN1Qatq8zCWCcCYeLSpnJX6uDhifQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2Xu9P0lbgitbZzTBtphom32KDba0krOFeggyHQFNVVkPyVI3T6g//aAh4dSXLD//
	 NeHUkSSC0cc4TuZKZUQknF0VLx7vQQYTdlo6PW1H8XPZbJLfHXwCbMLzfg518pL2ai
	 ifsTX6zGAy5tYXVe2tHWIsU8OPHGw92GomzJhFWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coster <matt.coster@imgtec.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0165/1250] bitfield: wire __bf_shf to __builtin_ctzll
Date: Thu, 17 Sep 2026 15:59:20 +0100
Message-ID: <20260917151556.561798633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5355f8f806a97..2b3127e712b93 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -42,7 +42,7 @@
  *  FIELD_MODIFY(REG_FIELD_C, &reg, c);
  */
 
-#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+#define __bf_shf __builtin_ctzll
 
 #define __scalar_type_to_unsigned_cases(type)				\
 		unsigned type:	(unsigned type)0,			\
-- 
2.53.0



