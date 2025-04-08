Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318232676E1;
	Tue,  8 Apr 2025 11:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112724; cv=none; b=p5QaYfdYBZjM3XQ70/nzlsDVOsYWgzCXNqxptNwksxIrjQ5njmsPIvYHWGdn7uJ8z1psmiu3KxaOr8rJcaeHKm4t3ImNT/j+wIkTV8TfR+J2oIVNuxBURm3SOsh/jD6iO467eF0Lcvhp2rkbkc/SGdJshog7TThLutnZA4rOVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112724; c=relaxed/simple;
	bh=1n15NZyuteYo6ZHQjjZoHqT+JZbbvVeM9zBlUomVJV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehHwGocsx4KXmTG9SLlgmveZpcXHpsESJ72taiS3rxhKCmFWjUbQ4rI8uRITQU4SxeEnITcyD1SJjr095Qbq/54dkaBc6qxDK9Mozf/cDSZ595XyEo4TLn4gVhrNEytfCNowE444qbwrzrYNFRIWPPB75SKui7WdFjRhKHQ/Vjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeZYORpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeZYORpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8486C4CEE5;
	Tue,  8 Apr 2025 11:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112724;
	bh=1n15NZyuteYo6ZHQjjZoHqT+JZbbvVeM9zBlUomVJV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeZYORpveksChB3ShD0TNO0nF3hVlFoiZXczhM4y2qPoGgUR/nKGWBT6euepRKBFM
	 w4bhqbjVF1PO4OhVmhL1zLWgXqSIjdDzn+TAlyZeq/glyL2Gupz/cxQlOnoqlA7KCX
	 uFDMt/sdWu8ki+0wcHbZe49yhi2nxBh4tSKw6eeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/279] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:49:18 +0200
Message-ID: <20250408104831.055631460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tanya Agarwal <tanyaagarwal25699@gmail.com>

[ Upstream commit af324dc0e2b558678aec42260cce38be16cc77ca ]

The static code analysis tool "Coverity Scan" pointed the following
implementation details out for further development considerations:
CID 1309755: Unused value
In sw842_compress: A value assigned to a variable is never used. (CWE-563)
returned_value: Assigning value from add_repeat_template(p, repeat_count)
to ret here, but that stored value is overwritten before it can be used.

Conclusion:
Add error handling for the return value from an add_repeat_template()
call.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_compress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/842/842_compress.c b/lib/842/842_compress.c
index c02baa4168e16..055356508d97c 100644
--- a/lib/842/842_compress.c
+++ b/lib/842/842_compress.c
@@ -532,6 +532,8 @@ int sw842_compress(const u8 *in, unsigned int ilen,
 		}
 		if (repeat_count) {
 			ret = add_repeat_template(p, repeat_count);
+			if (ret)
+				return ret;
 			repeat_count = 0;
 			if (next == last) /* reached max repeat bits */
 				goto repeat;
-- 
2.39.5



