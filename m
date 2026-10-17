Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9832E8DEB;
	Sat, 17 Oct 2026 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255790; cv=none; b=kLwQFpKiRNFz4CIVZu7RvNfEWlo0JDWes8jtC6wo9vr0WG8Qzt26y4FjloiEjr3LNKdIvZqa+ifMkPAS5jY3wFNK3Adb3lKS2GxDCjNL+647cBuLr9tM2iI9bCDoJQB/e5J0qdwkb18o9niEU5dhmFF4MVVh6ObOuEUCgGaHcDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255790; c=relaxed/simple;
	bh=sXhTE5oEY0tcwgEGGKHhSZHQQ6jLaeRw7attdAYT0T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJYCGJeNrmslDDQHrliLcJnE5KNv0CFgNHrakXDudeuPx+uvQhftcRS4LQmyeKQf8d4Qkw2M8GWl3aFAiLkq6H3/GMftQbbeQgRbDvm39dCpgS43yW4Q4WTifBEqBuFUUUQUOS/XoM9+fjv/G9Z88nB2s81doakcH8ej5T6w8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f87PmJh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f87PmJh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9434C1F000C4;
	Sat, 17 Oct 2026 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255789;
	bh=61CI8MWgGXZf7jugm6fd2NST4ag3Bi39FNwt/4SQGzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f87PmJh/J9AFaWH+fcP2/9bLDUyMjg750b1Xa9l2egSiP5STtxamGO4/voxbD8Kxm
	 Moys0it2ZlcVZgWaii88OB8Dz4CLK0wyslRAtK1lIB6bw9/8LkmnZUEtN2EGxL+yzg
	 a0Uc2ZGjODyyHOEZpn1fCSsIC6gAKkaENephSH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0022/1674] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Sat, 17 Oct 2026 17:38:14 +0200
Message-ID: <20261017160431.709925911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 28a289beaf226b30b1e6e7d7b1a2946fe2d6e852 ]

rtw_restruct_wmm_ie() scans in_ie for a WMM IE with:

	while (i < in_len) {
		...
		if (i + 5 < in_len && in_ie[i] == 0xDD && ...) {
			...
			break;
		}
		i += (in_ie[i + 1] + 2); /* to the next IE element */
	}

When the "i + 5 < in_len" match check fails simply because i is
within 5 bytes of the end of the buffer (i.e. no WMM IE was found
near the tail of in_ie), execution falls through to
"i += (in_ie[i + 1] + 2)", which reads in_ie[i + 1]. If i == in_len
- 1 at that point, this is a 1-byte out-of-bounds read of an
attacker-influenced IE buffer built from association/scan data.

Commit a75281626fc8f ("staging: rtl8723bs: fix potential
out-of-bounds read in rtw_restruct_wmm_ie") added the "i + 5 <
in_len" guard to the match condition itself, but did not add an
equivalent guard before the fallthrough advance, so the same class
of OOB read remained reachable through the non-matching path.

Add an explicit bounds check before advancing to the next IE.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-4-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 97618a3636994..6994c7081476c 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2015,6 +2015,9 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
-- 
2.53.0



