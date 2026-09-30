Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516151DDEB;
	Wed, 30 Sep 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789858; cv=none; b=rPmblOI+ma1aLGAfHLuib1JelAxGYI61UjO3/V79zkMYd2LDsp3Q9CKfOwMts4YwlNzPFu2tUKOTTmIIIEhhwuWfXnvE1xLqWd2jNdZsYlhs90o4zo6wVAfx4h7POPhSa/x2C/faLlg0Au7pusV2q1vmDZyNhx7V3/0ZuD/b/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789858; c=relaxed/simple;
	bh=y+7GijYHTuq4dsb4ILJoYrb051I4f3GFE8uo/3ukCR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/gH92c+Wu8iWiEqnAXauyZu57TG5hFiPalfqstUNnVJaoAzmYTBVyrVajrXG713+kHSqfneyRd2xfZr2KJU6Qtzp8Vq6WOIiU5ZbQdY2YBz1AoVq402BYdkwHVUfX+1OanAlUId8jWIprioZ53g4EdCARncILM9g/GgW1rdPFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESS7IOAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESS7IOAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0DF1F000FF;
	Wed, 30 Sep 2026 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789857;
	bh=GcMnPqh5QYBka13lkIvxPMu19HePCuSrRQAiR64Xefo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESS7IOAJS94O//5f6cn+oZFOBvltgvqVNdXrnrorTtF4rbOH5eOC1zTwGQAcnLJiC
	 mmpDImY53gxN0wtj2xxP8MaGmDmNUHzruztYtQe0hkrVzm7sgHzXOs4D3LLhB2eT3U
	 LPOi0g6B4G/Z+BlJP/Jbi+XfLMskBXmFX+9IiFck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 624/877] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Wed, 30 Sep 2026 17:25:35 +0200
Message-ID: <20260930152428.114212600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1950,6 +1950,9 @@ int rtw_restruct_wmm_ie(struct adapter *
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 


