Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828942;
	b=NYXKrS6oTrCuAYo8if6ZV8LWNFWdzIaqMTRnO5HRPFQvAQ+9ZXFNUFvfhOlzb9HQXKG0
	 uPKc0rkd4Sd9ZlX/+BKajmBIY8W2WYJ5E3BcpGYOxmQp9dvxi+LPMxsVgQ9Zu786At/9k
	 XIC5M/JMZMvEOq7FydmKkiPcHZwtI5ZNMDJfj2YC5rgDFmYwKUtJWmnbWDazpcg1shjz2
	 mjmkFu7ftqjpAZow/x2G0lYZyY35n7HNya8MCAciiU0fy1Y7Ai4o+hzjMQTSUSMknwEjb
	 eOtOoFlahR6nz2hfHONTiPhBMccmt1dMHrz8VGX3S8lUVJ9bTVp30D8w/pnHF7S0dhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4xlgU8p+1nUFUToXdXszXueW6vwpt3gYZTGZZsJBmso=;
	b=U0y+03dsFhPkd59/fC2hifpUIwlxIllWKLqAfP3XcH6BYhfq1qhSyGcEbyXu0avJLWrX
	 trBLfU/fCZNfcZD0wyjovHj7RUPfDJwv5NcHhsbI9pwz8xQiQPd/MPLz8+Yj1IzCgdPgP
	 GNWceN6N6BjtNzL+9tKNqQjJVjFEVokAQPzNn6yoHRCNo9GoIoun25Ie4xZEDD9mnrghQ
	 KlEhSCkHEU0Aj1ckCX1+98SEDG31T89k+p8RzndLQPO8k0nK2ZSJdlAxGKNIOfcGuYNwI
	 DoOdDZUosiXgMBOb2g28iPuGQKnD7uW3tBd5RWjHJxTzriq0Gf9G5tYomxlgBPI011Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvObs+Eh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D0F607264A;
	Wed,  4 Nov 2026 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvObs+Eh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B881F00A02;
	Wed,  4 Nov 2026 21:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828941;
	bh=4xlgU8p+1nUFUToXdXszXueW6vwpt3gYZTGZZsJBmso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvObs+Ehh3dsP9bE57WKmL5gTAKng0XGjfPwQ4m9fPE+THcC1WVoirPfMwfh/4tKD
	 F4h+k55k9wSge10io89+FUo5cmCFqPHAQk1xQK0dNfjfU0X0ZjQpngh/7Pa1HtqECJ
	 clA5cAe/TpKOCFtQS2sqf7ANZk3nZD+1Z2KLWy+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 340/547] xfs: release ip after unlinked list store failure
Date: Wed,  4 Nov 2026 16:08:44 -0500
Message-ID: <20261104211047.889286413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 9a263723d7c9ab0615bab3f5cc145d3d24454a5c upstream.

If, while processing an unlinked list we see an inode that has nonzero
link count, we fail to store the incore prev/next pointers, we should
release the incore inode instead of leaking it.  This was in the llm
fixes branch but fell out for -rc7.  Weird.

Cc: stable@vger.kernel.org # v7.2-rc7
Fixes: 0052633527158b ("xfs: don't ignore runtime errors in xrep_iunlink_reload_next")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1081,12 +1081,9 @@ xrep_iunlink_reload_next(
 	if (VFS_I(ip)->i_nlink != 0) {
 		error = xrep_iunlink_store_next(ragi, agino, NULLAGINO);
 		if (error)
-			return error;
+			goto rele;
 
 		error = xrep_iunlink_store_prev(ragi, agino, LINKED_AGINO);
-		if (error)
-			return error;
-
 		goto rele;
 	}
 
@@ -1100,7 +1097,7 @@ xrep_iunlink_reload_next(
 	 */
 rele:
 	xchk_irele(sc, ip);
-	return 0;
+	return error;
 }
 
 /*


