Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC4502761;
	Thu, 17 Sep 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667498; cv=none; b=lUIoRRIynkUJ2XyJ4gqYWQxGHsIbC+G32TQJ9ErmOvplDp3gq9r/gHyoahVyHXFe1jWan79bxLFV1YUj7GKy/B3u55flZ6dpbWEhMiA/3EYqLTOLadsS/LxxJi9e3yeabB4Mx1x7o/Sz8Nyk5J69sZ3v+nbNQm+SNEzgLpHMO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667498; c=relaxed/simple;
	bh=mAOajevdAl5RAEBVYX5NM4ziMR1Nt/aKl7VOtPxRzb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ+rU1Mp1Tjy2qlkF+ddXhue4CZksgY0vYv+FHLBaJtM7uk4tJ1c2hCCwqKb1lZ/7srcIdVD/HTwTELBwhFoHg1nLjynp7N7cm3uWEOLrQ66ieF4Edtp2t95VlfjmtO2UAZPCYFXTfs7N25wLrN3OrRQSTj2htnTyzS0cMNPBMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wymUr5Q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wymUr5Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18991F000FF;
	Thu, 17 Sep 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667497;
	bh=twcNEJD+60bo5XsxrH8Z+VObxoz04+y8E4GXJpAW/mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wymUr5Q9IuBxkpcq4t+ZBizpE4hxT+9YPm/D5S0y1hmIY7MQuTJRbi15hGDq2gXNG
	 24/WujKEA9eNu5zogHIoYxA2IRRyVhDz3h2FJo8gN28vy4+g5gEdTGVdoBp73Ies1V
	 aTs73s84gHZAD1RAoD7q3PXr8R2T5nYtwJ/y+PhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coster <matt.coster@imgtec.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0113/1102] bitfield: wire __bf_shf to __builtin_ctzll
Date: Thu, 17 Sep 2026 16:00:56 +0100
Message-ID: <20260917151542.340253063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63928f1732230..20978c60b565d 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -42,7 +42,7 @@
  *  reg |= FIELD_PREP(REG_FIELD_C, c);
  */
 
-#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+#define __bf_shf __builtin_ctzll
 
 #define __scalar_type_to_unsigned_cases(type)				\
 		unsigned type:	(unsigned type)0,			\
-- 
2.53.0



