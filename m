Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F51A94A;
	Tue,  8 Apr 2025 12:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114012; cv=none; b=hs91+hzN9upj4eMEwd3pYec0twvY74seSMcxMMnYW94qQW7yRBssCM9DMU7qeQoSRhtCxgcZGlGYF/glA1vC9XMRd/8p/PiiFqcAp2I9DooMswaU9fy6Z9OBj3ViIrRP3xClFUb2XShGyMK8u5xu3J0AEPka+37e9Qp8ruletJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114012; c=relaxed/simple;
	bh=GXwQI7BMsQistbBUT96wFjbiyPKjzweEsGFdUwomASM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9V7+uG91MN84XNsk1Dk4EuAjmYlgBDNXBV3o3BMZueWopYgy0agw7L7eK8KGDcaMc0rORHG/aTgnlcZ2N46oKzegx42dOopIOgqynOlHQ/ylo8GmZxKpkXHAn/1dSwDdV0kmlM8sQpMNrVNgVkM0vaccOsOYUBsIwkfPi1W4tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+po1u2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+po1u2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B8C4CEE5;
	Tue,  8 Apr 2025 12:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114012;
	bh=GXwQI7BMsQistbBUT96wFjbiyPKjzweEsGFdUwomASM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+po1u2MrBOdfiom39XEUMtAq88Dredb+35CCDqFo6k/59K/2sbe3p5cvQBY4VIe3
	 CDHCirMU3podGVAhUGoR+Ct6W3/pLcodEjzhQ7KoP1C0YOtbNeC/AIGrtcTjbbgei3
	 LAWF8D8zk29eUDle2s4wJJB7DlxPzb9X5ClUwibI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/154] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:50:44 +0200
Message-ID: <20250408104818.631905926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



