Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03275349CB;
	Wed, 30 Sep 2026 17:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790698; cv=none; b=edl91nNEKbYCcxfh7TMXpHF8hETun1mD8Cy3UkJdKwN4Je1bZDrLNIC0Km0DkgRawoYwEGy5kP0TYreA+TAXOch6FiRyIEfET19ENVlKKmWX/SYmOf0h9ulg1iBCFpr+IK+K+SrSPgzr9jP2XSjBteYbSjSxEAlYO1Gl+t4lP5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790698; c=relaxed/simple;
	bh=DrqQTIMHN5v33e+/c3flDnPXFAxiLXO+qFCmN69ZjeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXELhqQw1rZz1iY8hKUYSGe6GSKdvMyPKSCbQ6TmvRbSCfDv0WFjsSicjWwd9TiUawTPYgjixautmQSI0N0ds/SVQ2xmqJl77DKrbvs4dyF2p/qwps7XtNT3qgAtBSyQP95skutfO+ulr74DEcUavh52PDffK5402fnUb5No9zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8vMxo0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8vMxo0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B191F000FF;
	Wed, 30 Sep 2026 17:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790696;
	bh=2Dc/Bcxs9qYx5RRh9M8Q7/lnuHSLpANeI7M97oeU4Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8vMxo0chGgc4EfI/wotX4IADY3PR1Hh2bFTeARC83SbmJ0MHI/LmJq3UAObHBQHO
	 kYkuHsccxq3jQO9/6QkU9aY+ZAiFrrQkoYh+sKhYQxdvGQPTqMdF4QN/ghQ8/u3U2s
	 ZoMwWcqSmaFi4NMtfP8GMuJJ9xt77MjIla+VTgoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coster <matt.coster@imgtec.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/752] bitfield: wire __bf_shf to __builtin_ctzll
Date: Wed, 30 Sep 2026 17:18:33 +0200
Message-ID: <20260930152359.084276325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3db9434afcfea..78beaebb58155 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -40,7 +40,7 @@
  *  reg |= FIELD_PREP(REG_FIELD_C, c);
  */
 
-#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+#define __bf_shf __builtin_ctzll
 
 #define __scalar_type_to_unsigned_cases(type)				\
 		unsigned type:	(unsigned type)0,			\
-- 
2.53.0



