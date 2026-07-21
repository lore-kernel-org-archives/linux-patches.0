Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDF407CDA;
	Tue, 21 Jul 2026 22:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672524; cv=none; b=Se1NXuOXK1aI7D//OJA8ZCYoAEubFmfGiTsq7RFNEYI+vFXwe9s6yMU8STvEmz6Y+Q5z99thDNxMmlJczSlw/cTcSUw3DH5UlaWD7DaNQN9fAKlyXuPkuFNKqYd849Js+hnjOoEKueDJrWpCxqg9H8OGnnqt+iMPJ5IGGADrxMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672524; c=relaxed/simple;
	bh=MixZVOJ/CjUJ4ZzCk/BunQ2dvHiwT6X4J1kgIRdgCRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIqc7n0HzBDrck2A6IzgIlADsH8IdBBGzZNdX/3N+QhhO77wM4MRVMtGpqqVM/ZYsb8ZQ6WjtXVSznTIEwqVsAA+RZaTt7uOisdywlzI/GB5oLcAo/g/ZSxktGhDluKAkcqAPFS6iLHaCv2/g4blKMPrCf5zpLBoVAGMxLMDHF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19TbpY42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19TbpY42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288E11F000E9;
	Tue, 21 Jul 2026 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672523;
	bh=gxAJ3ZSFbwpda/mvwSRzTuK5PuAbolGNDctJBkQE/BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19TbpY42BmOLVYhhbzQs5snodndt17gg9EgB4KRMn+xA4KGKwbxRuqauHoCd+kwAG
	 wQ8DsLsfgrRKPIH2/dFRsYm/0HJ3SeMdOaIIRI4l0dPcBgtVXUDk7qEqjeFfDsSIWt
	 z6jgjQkW13PRvJYob910l2CMCTOLr7fulpxDMPic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 657/843] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152420.845824125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1917eb2db750ecbdf710f79a8042eaa545a063c7 upstream.

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -675,10 +675,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	} else


