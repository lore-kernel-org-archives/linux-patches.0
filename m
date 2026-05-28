Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9541733CE8A;
	Thu, 28 May 2026 20:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000840; cv=none; b=FVLF2zt9zPb93Sd6pzn8hAkL4ytAsymkkt+VPQrH6+qjuck9TVc30uTLh0aR7ZVbyPbFH2ITeD6WmLbH/y5GLvjZznKjfzOQq93DEWqO42b0Waa2zRvWxy2IfxcMy7yASpmaIkeFAHpXsrveej9tpcdcGrwYuhsqHpPVtPz+ARs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000840; c=relaxed/simple;
	bh=hXW9V/fKyAG+QintxEPhk/qFj3gmWs0IDmVjROEkIhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsSdcwcuXvhogwa4J4HL1Wq6s/e3h2nWj6rsYH4C6txPf9wLT7H+NIeBI9J3XIlexW6GiGOh05Z87QXLrNYxKYmXlwz5AUclWZ972Tt5YMlh9iOtQXNN/626Sh0f52vHj9mBJAc4ap2sYUHf7DidahswSdGd/v28ciamNq862y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS4/7OKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS4/7OKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35461F000E9;
	Thu, 28 May 2026 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000839;
	bh=HC8faTZ/AgyclX5OwNKBQA8Dl7zkM93c1ps07PLMaBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qS4/7OKb3i1yXdOwo5dikpftxzuKcFjI8wEOzGDEVGbOJ0YO7EffpD3qmxHkqQQ/T
	 pvKqQ/wthFQXX9BvC+Pc0eT7JDTjovNxYPuRmypihjUMyeNcG5K+Tw8WOhS5Izc+Lz
	 S3HYPqjiFSh9MGnYmZNGabqVmLDMQsqqzmjQBv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/272] zonefs: handle integer overflow in zonefs_fname_to_fno
Date: Thu, 28 May 2026 21:49:21 +0200
Message-ID: <20260528194634.514745166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 3a8389d42bdf4213730f4067f8bfa78bae6564ef ]

In zonefs the file name in one of the two directories corresponds to the
zone number.

Here Alexey reported a possible integer overflow in zonefs_fname_to_fno(),
where the parsing of the zone number from the file name can overflow the
'long' data type.

Add a check for integer overflows and if the fno 'long' did overflow
return -ENOENT.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: d207794ababe ("zonefs: Dynamically create file inodes when needed")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index faf1eb87895d0..72408d8f9345c 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -610,10 +610,14 @@ static long zonefs_fname_to_fno(const struct qstr *fname)
 		return c - '0';
 
 	for (i = 0, rname = name + len - 1; i < len; i++, rname--) {
+		long digit;
+
 		c = *rname;
 		if (!isdigit(c))
 			return -ENOENT;
-		fno += (c - '0') * shift;
+		digit = (c - '0') * shift;
+		if (check_add_overflow(fno, digit, &fno))
+			return -ENOENT;
 		shift *= 10;
 	}
 
-- 
2.53.0



