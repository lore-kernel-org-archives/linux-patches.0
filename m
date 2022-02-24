Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915137A;
	Thu, 24 Feb 2022 16:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15370C340EC;
	Thu, 24 Feb 2022 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1645719450;
	bh=vaqKWCQn/KTC6o8vuz3JHNxzJRZcTmSGl+sSsDj95XY=;
	h=From:To:Cc:Subject:Date:From;
	b=tauKN2g3+yhNNwD5/y461edh6+ZqSobOFtoMhf6FeNc+Zr94pN2Qv7gjce6BORJhB
	 L/YK8fdNXI5S/DaYCWbytS+vjMMNLSFOECYO9uhnZzT/e08U1hwdb0FwuLvIhtRAr4
	 vHJm4LrNFMY8h7tknGwIqbLyJUqctymTl6JcmCg/XKzFPCqEChYMHjc3JYSIPcHKGV
	 Z0k0AdMHgX8LMba2elef+JQUlIVZ//xVKr64pfg0DqwP8xrPZADM9ssu37k6HuxPf0
	 E7YN88Pssy+Su+gbD1IWfLwUbyQkzuafO0Ur0py14AzrHXoCNRssC1oJq2UeZIwY0s
	 CuXMsdHx8MQ+w==
From: Nathan Chancellor <nathan@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-mm@kvack.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] lib/maple_tree: Fix clang -Wimplicit-fallthrough in mte_set_pivot()
Date: Thu, 24 Feb 2022 09:17:05 -0700
Message-Id: <20220224161705.1937458-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  lib/maple_tree.c:764:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
          case maple_dense:
          ^
  lib/maple_tree.c:764:2: note: insert 'break;' to avoid fall-through
          case maple_dense:
          ^
          break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1604
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/maple_tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5132495f86a6..5d8c39cbd517 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -761,6 +761,7 @@ static inline void mte_set_pivot(struct maple_enode *mn, unsigned char piv,
 		break;
 	case maple_arange_64:
 		(&node->ma64)->pivot[piv] = val;
+		break;
 	case maple_dense:
 		break;
 	}

base-commit: 7ec16b08f9e0b656c96d20424b1cbbff4c78329c
-- 
2.35.1

