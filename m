Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ACD3F8E04;
	Tue, 31 Mar 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976114; cv=none; b=oxsysbYxhuTdCVi+/nRVGx3a9PiqJmCbLwoD/SxelVVQLFJ5kuxiydiUDLT7DApuhIIAwtPvUCTIwQ+YQskHLUYDFMURshzJI32gtT90EohjlCjldhMv7U43FCiF+c07LHySZgaruvONo7o6BWkaI+kXpc9IdQf5X1UDzPh5aww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976114; c=relaxed/simple;
	bh=1PYR1RXgk1B2YZ+9G7HzlcN1hZV42Vx/98Vhp+tcz2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt5yGrjKwM4gTZkNvB2DWteJvABxZBp2jz/5fZJIq4GuimmU93pqZ7tuKOgoQBfbpWgI/03Hq4+STK99sZ5WaobhafLKd0FfT1OOhivIf5F9b+hTkNKdfhtLuHTUcKZsN5k5lzC8ql1LqCjmNYoBqwGqk2RclTaR9JBTSaV6WOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnvBQjJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnvBQjJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D48C19423;
	Tue, 31 Mar 2026 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976114;
	bh=1PYR1RXgk1B2YZ+9G7HzlcN1hZV42Vx/98Vhp+tcz2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnvBQjJlHA7LhwhKOExcWhQ3teSBN5TcSyrU1eEvkKSmhWsmzWnR4hs+b7NmPuHpm
	 4N7CTTO0of+uoI2gBU3r3xKvjQmSPJA06TUZ7o2c1WebC0BwEAKWDrEFze8xYrSPC3
	 algRdGof7iKvvRNGbIqR8FJav7ElNEse09l62Ohs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hongao <hongao@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 179/244] xfs: scrub: unlock dquot before early return in quota scrub
Date: Tue, 31 Mar 2026 18:22:09 +0200
Message-ID: <20260331161748.366666004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: hongao <hongao@uniontech.com>

commit 268378b6ad20569af0d1957992de1c8b16c6e900 upstream.

xchk_quota_item can return early after calling xchk_fblock_process_error.
When that helper returns false, the function returned immediately without
dropping dq->q_qlock, which can leave the dquot lock held and risk lock
leaks or deadlocks in later quota operations.

Fix this by unlocking dq->q_qlock before the early return.

Signed-off-by: hongao <hongao@uniontech.com>
Fixes: 7d1f0e167a067e ("xfs: check the ondisk space mapping behind a dquot")
Cc: <stable@vger.kernel.org> # v6.8
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -174,8 +174,10 @@ xchk_quota_item(
 
 	error = xchk_quota_item_bmap(sc, dq, offset);
 	xchk_iunlock(sc, XFS_ILOCK_SHARED);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error)) {
+		mutex_unlock(&dq->q_qlock);
 		return error;
+	}
 
 	/*
 	 * Warn if the hard limits are larger than the fs.


