Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE53427F9C;
	Tue, 25 Aug 2026 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664929; cv=none; b=briT7+CZjCJnz3FjMTtw1go2gzHpXf36CVNAt0cIDQA9mUEo/rnWAZQ1uz3FFAhN8Umef2qIXnEftYRwz0pzsfdgX7X1nxQ1N8ZyBrK92LIhW7eC8F+kfCgdBEWrazHoZZohKf+eUftLMo3bEACSUw5zlz81ss/VG6NVmkqgH8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664929; c=relaxed/simple;
	bh=ljKNAeShFxM3pAVL+hMz8sZJl2UCm6+2MASgCsiW/4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJMtO8PhJieliXU5RnyI7HZGiDkvTHLTe0AnHuFPTRUJdyK1zdhfgRZVpFOdAAuhDd/DH9aAx69XOvkM/4iJdo5eBig7t2GRDospbjdUeV/u24ZoSqA6qamjbUGNQuJ/AZdTRtuX1Eg4bHTStwEXnPyQ62JX/Y9sT7krS2LV80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRVma1e+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRVma1e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559E91F000E9;
	Tue, 25 Aug 2026 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664927;
	bh=OsXEi5EDABOw4s8ZdIqqTDZ19wv2miF63VcG5HGpM/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRVma1e+xqZr+S64us7vl9QVYietsrbAeOApx996oaOgPWH09naGQpQgJyrh4QdTi
	 ahBORcu44hOyD4Beo/BBvg1Rxie3PmbRB60MU/z+kfy1f181734UIhK6SGSRJoBubl
	 MeVtPIBAY2jhL0KyL2TVIMf9JxndfqMuFI/JIRHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 004/101] xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
Date: Tue, 25 Aug 2026 15:24:42 +0200
Message-ID: <20260825132542.175153605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8ed78104722b57df69478b0b1608a408c1036085 ]

LOLLM notes the discrepancy between the comment saying that this is an
xref error and the code, which marks a (non-xref) corruption error.
This appears to be a regression.

Cc: stable@vger.kernel.org # v6.13
Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ changed `xchk_ip_xref_set_corrupt(sc, rbmip)` to `xchk_ino_xref_set_corrupt(sc, rbmip->i_ino)` since the renamed helper is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtsummary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -358,7 +358,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ip_set_corrupt(sc, rbmip);
+		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 	if (error)


