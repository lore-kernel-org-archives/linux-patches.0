Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D83FC19;
	Thu, 25 Jul 2024 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918730; cv=none; b=bSCSf7t81i97W3oOgEk34d0shY6x/S9d8kN7erzVAlVAYMsSpN4Iqq94bWGUqzI4mzqWGZtH4hIz4/5TLc/bZdvItZmRT+aePqH4jBY+RXb8SAG9DZtxSLNAVNS10iF7nw8dHAncSd/eT++XD3YdDzPN+lvP7PFU9V7EOi1/KpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918730; c=relaxed/simple;
	bh=ioXSTDgWr1ArSZsU3AC9NXC3oiNDjJ7RpBd1a4FnFrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFMnHRwJpdAAdottJXsops+lMHpxemG6H8Ct8u6IC/oBnRQU1wfcFS8rhIsvY2Fmo1w8rgqk2MkkJ/ttGqTO9+W2gjBEUgwmuoQ0xs2D4KFqmbMXKAH5I2J5SqTGFI7fln6sP8xkl/KzrLlZZIDydx+8enCbxm1O807XsKszpXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhI0xrAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhI0xrAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F3C116B1;
	Thu, 25 Jul 2024 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918730;
	bh=ioXSTDgWr1ArSZsU3AC9NXC3oiNDjJ7RpBd1a4FnFrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhI0xrAk6L/ikLnQ4op34zv7CyqvrSg14od747DPejDzJMVTGszwCNP+/ouheNGkm
	 UrCRfY/S4Jqh6dGr2TJuKYcKapghF+fULPj8PtMVtQpaQP3DSSDLeQISDtc6QHZKs8
	 euy2ZJ5UU+0PtQbRyBLkzXXV2m7MW57dFNXCUgAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 05/16] fs/ntfs3: Validate ff offset
Date: Thu, 25 Jul 2024 16:37:18 +0200
Message-ID: <20240725142729.108065579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: lei lu <llfamsec@gmail.com>

commit 50c47879650b4c97836a0086632b3a2e300b0f06 upstream.

This adds sanity checks for ff offset. There is a check
on rt->first_free at first, but walking through by ff
without any check. If the second ff is a large offset.
We may encounter an out-of-bound read.

Signed-off-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -724,7 +724,8 @@ static bool check_rstbl(const struct RES
 
 	if (!rsize || rsize > bytes ||
 	    rsize + sizeof(struct RESTART_TABLE) > bytes || bytes < ts ||
-	    le16_to_cpu(rt->total) > ne || ff > ts || lf > ts ||
+	    le16_to_cpu(rt->total) > ne ||
+			ff > ts - sizeof(__le32) || lf > ts - sizeof(__le32) ||
 	    (ff && ff < sizeof(struct RESTART_TABLE)) ||
 	    (lf && lf < sizeof(struct RESTART_TABLE))) {
 		return false;
@@ -754,6 +755,9 @@ static bool check_rstbl(const struct RES
 			return false;
 
 		off = le32_to_cpu(*(__le32 *)Add2Ptr(rt, off));
+
+		if (off > ts - sizeof(__le32))
+			return false;
 	}
 
 	return true;


