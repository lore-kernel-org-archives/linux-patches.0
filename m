Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0E4E4C5C;
	Thu, 17 Sep 2026 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660589; cv=none; b=RyQSiwEo7d+KNGYSAF+8sfM7o//saI34Lk3D9Ktic18h+bQrCHLQkeO7IKxYefXOwKzQrBVEQlRqF7NHpHZiokiA88wJyaYFZECmiP/cS9NECehxB0vyi3Lk/MBzw4mB0YTDVnMnvSu1Rxr2rPFsLb+usAMwWt8InFkv0DIESb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660589; c=relaxed/simple;
	bh=pLctZQRuQIRFjfkKuXAXAKnuBCQ9i9FCIzNlF09XDqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGehPNCeoQtHtpzIaybPWGn0+mGAvmHIxcsW7l4etcyHjuujifAWghMCSJpl8xPd+teSsz4bLEUJEm7fpdm/gofNl6zwAQF6GRYSWp2Aeb9fjfAnkqYY4ZAAH9370Hquc/x9MX/WhKsCcqYdT5CcUXnBLLv6bufjcMfQJjjRnE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGi1s+Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGi1s+Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB6C1F000FF;
	Thu, 17 Sep 2026 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660588;
	bh=aZXo+3AYCNAbte9vrrnCgRFyxMiLqZiAS1arjDG4f98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGi1s+XloG/7NjG4Dg0ygE80+VqKljRzWqN15hWmvAGVcbWqo9RMnuxgC5SMDRRJJ
	 eCcjWG+KF+B1AKp6f0aJr3+PsDA3X1u+RFx5b6KEAv1g9Kon4MeDb8C+qz1tFBjS63
	 n+hq9c32D6x5mrUZEtPwMpvmlryGE/ykgu8zQ1LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 642/733] xfs: truncate quota file correctly when repairing quota file
Date: Thu, 17 Sep 2026 16:15:50 +0100
Message-ID: <20260917151408.596662812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 0fc67528f54bb91dac22093749b425207c0fc245 upstream.

LOLLM noticed that xrep_quota_data_fork screws up the unit handling when
it computes the offset at which to start truncating the quota file.
max_dquid_off is the file block offset containing the highest possible
dquot, and xfs_bunmapi_range takes the starting file block offset.
Therefore, it makes no sense to multiply max_dquid_off by the blocksize;
all we need to do is start truncating at the next block.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -455,8 +455,7 @@ xrep_quota_data_fork(
 
 	if (truncate) {
 		/* Erase everything after the block containing the max dquot */
-		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
-				max_dqid_off * sc->mp->m_sb.sb_blocksize,
+		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0, max_dqid_off + 1,
 				XFS_MAX_FILEOFF);
 		if (error)
 			goto out;


