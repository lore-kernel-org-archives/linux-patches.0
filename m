Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A102F2686B3;
	Tue,  8 Apr 2025 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111429; cv=none; b=lfzWKLnXRNhv9ckHwxFlheAkaKZp4ChX593iNU73SPHzT2n7E4pD/nPGlGNwf9P7CEZPCr7+Vh+N4MgEvZ43mpckHNOgt2Y2K8LBMPjdi7WHP8zrrRKNFWkjxKFJmlEkv3yGdDtf0cipBYGM0JWL6HmUT3QuV9ltKExw9/I3QCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111429; c=relaxed/simple;
	bh=wSUWg8JnBnktcvhaKMuGmomcYpwpb52JS+Pf3UPIaMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHdeSDh1jjT8WGeOSWv5r1+85G9xK204J0gC5ao3dqdNs0O8FLzL9CGODbMqtsptU+kYdL4ZGYtN7IHgmswxaaWd4TFtyOj7p9h0sdWavPn5Kb0BaXh0tyyhkbYkHOQeiGMHTz5m3FzWrNzD8sKmSyPm26n5jooccm51bHzar28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCFrwR2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCFrwR2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31450C4CEE5;
	Tue,  8 Apr 2025 11:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111429;
	bh=wSUWg8JnBnktcvhaKMuGmomcYpwpb52JS+Pf3UPIaMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCFrwR2iApoF0jZQy5y59t1LXwVM9xwNxloSRyt/IGkcrje0Eqd6v01qh27GpkIJr
	 ssXZDCEC28wp0iONWYuSbsjVpqg3xE2hwuF/8y4fHQquN+yZo9HsfvaZPPBt1YydcV
	 xIpycxSjvUJsHSZjtWTiSnq6rrO6O34V8WM7Pjzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 387/731] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:44:44 +0200
Message-ID: <20250408104923.278342452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



