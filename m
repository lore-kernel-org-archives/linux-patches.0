Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D5C22257E;
	Tue,  8 Apr 2025 11:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113212; cv=none; b=A07ulir6d7qmeQ1udUOssqrXDnhw4C2esh+Voy8mWeyKA9iVWom8VoftDgj5Rxz2Vd1St1FAQUjIOgNLWI64pubqXPnHFLmoS+/9fLKg/1UagM3t1mGJLG+3deY4xzhg/lgIwifmWf6UPzKrZYJo4ojcAY3WU8zYX8oGXN9KVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113212; c=relaxed/simple;
	bh=sg5jmqKCWvPWeQ3tL1GxgKNfdvi9HZuaKDn6538NoHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKb5N1nEa+og3aN60nA6uyKp0QBKG9HWJtd6/jNAXVIdU7fwBBssyiT/8msjjy/jD/6egshJNoSmYBrpSuMwnaZBZMLw+0MFpPlkspqvtabkULO5yHFpFqdfkenwGSLj9dJEdZv84zu7svzaGEZmAZ2CREZHTA9sRwO/1iH79to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnXwjtfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnXwjtfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1487BC4CEEA;
	Tue,  8 Apr 2025 11:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113212;
	bh=sg5jmqKCWvPWeQ3tL1GxgKNfdvi9HZuaKDn6538NoHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnXwjtfRHqGGyfxkxfXOPDNcBIBgxoWKVm+HLGESvkIDpy0HOZNzaL8kemH0ZxSPn
	 MLUZqW4+PjgTuuGFlZoSRDP74JQQxArpo9EC/vfhH55QQjORYFsHtth0gRwCYLv2XI
	 8R6zPmNBsySDd9Tb/DgSjJQopJcTqQjKloqFLAyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/268] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:48:07 +0200
Message-ID: <20250408104830.547779253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



