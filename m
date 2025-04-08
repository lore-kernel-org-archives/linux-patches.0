Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EF726FDAE;
	Tue,  8 Apr 2025 12:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115678; cv=none; b=ZW3NYYNc1ucHetayeVlyMDJLV5jX+O9NRqiRP8z7a939SZCra19K1ShMllbwouMrAeQ3GTbnGuiu7udm0vguKWgQaaBHT9zfoKIZCLbmxiR+3CyhLXBphmtQMvRBpdUzpVP5JFJyl0pEAtMng/Yl1M4/5ut0hT+E/DgH+ArtMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115678; c=relaxed/simple;
	bh=Eno2DnKyfdLkICJpFqDpUX8tYL9G3qX8rYNFs+CuvWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La9nFR8YDE9Gh9EfET2N8gTlywb477XkZvOBB49pDkYFr6mTzEYhLkD6E31Zb9Sk7GOFMurpRjEBeUpqZgoskGq7jTEBmCctqBp+mvbJo019skCl1WRh+v/68FGUtoSzy3ErGhKa81Uh3DjH5FeGxaiCG7Sn/eYMT9dR211wCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UemkAyUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UemkAyUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751DBC4CEE7;
	Tue,  8 Apr 2025 12:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115677;
	bh=Eno2DnKyfdLkICJpFqDpUX8tYL9G3qX8rYNFs+CuvWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UemkAyUNCdihi8QcnfmpMkJNE9JTlJdcw31Fw4+c9iyuyaP6ShF23BctlkB2fTSiz
	 sVqmYvSrDiol2FgO5TVihMi5VnSV7lAB5+dsqVHV1PKHkdi+Ifr2R7n+ytWvnUBArs
	 M9z/5EPs9NA0KmRn2KpxZUc1RikHqIDm1uJ3PaB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/204] lib: 842: Improve error handling in sw842_compress()
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104822.176229947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



