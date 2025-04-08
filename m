Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516EA264FA0;
	Tue,  8 Apr 2025 11:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110047; cv=none; b=FgINvk1HM+q3/qNVROv/el02BTtFQpO3ll3zVaNrpsTnAwsrgOQvk9S6YEsk+dvfhPeplzOT6iFEIIb3m8D7D2HgIREp7lOI9pE1qlAnuMEl8GF7WlTabUa9p6NhtuBT2IuTFdvae3iDUjQGXdQi+EG7+vpLr/01UZ9R+bk4/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110047; c=relaxed/simple;
	bh=mvBSP2LNd2znwl7l0L/tVZkMuQkeMeQNY/oYr5QkGc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkTK921H8+YbUypwhBZ6r3a5KQv+G5TjpUgF181R/C0UHERMYeOK0EU1mv96IbbUwBOTOyAg6BAbBcjbGB4U1eOv5cM8IQxzGXlbbg3Yc/MeCh9uY1kCJZrjaH2b4bxxp+ExhUsvjlEzL7QM0eJRpweobrY7xaBWieBL/+VHX/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s04S+cxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s04S+cxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365D1C4CEF1;
	Tue,  8 Apr 2025 11:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110046;
	bh=mvBSP2LNd2znwl7l0L/tVZkMuQkeMeQNY/oYr5QkGc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s04S+cxUqi5iZfYoH5XpdaImayT/sc8NsTVVmxXJRQAO5/RhvbXZlIo/cEC2brwRW
	 plIgoZ+eL85IObAu7HBgMCJOaoDiUJG+7Ee/4643e4x4rsOp7f/Hq84hROaFVBwPRR
	 ZQH0iF2EPKPu7Jn5uqOL5oCUP/JX/bZUp8gK5iy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/227] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:48:46 +0200
Message-ID: <20250408104824.756414316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



