Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435613D6664;
	Fri,  4 Sep 2026 05:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498864; cv=none; b=bt7+TP03dTDUlgVgcuRp32QuGPwveJZ00N+wlFH+lY81Ul70/YOQSnK8t/OZF4WJXXzVWD0bErWXYkj8VdEyzQ/EVLPljOx0N1xbVzO3IOcag2pJ5JIMMw851mXefGp3YQSfIozdnvbq2pD2UTPVt1K3lVkGKvxWckQ2qdu5e5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498864; c=relaxed/simple;
	bh=ZgHPGQX6mShzeMuIH6lAh38V6eIWOixAbBq4eApwPrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/DWVukZb801UkQzxbVh1N+vhnMvv9NNjgwejEyVes0E9GXllLU6vxs9o1QqcF30J2t0I67e4PZz71iR568y2v1bGvG4g7KwUXROQB/k2gVQvd97HUzvjfANyyo39HCBcUVakgfcEBpgyKAAGDwKj28cWYVkY+gyByh2MKIaHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFDfjV0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFDfjV0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5631F00A3D;
	Fri,  4 Sep 2026 05:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498863;
	bh=mllgXdg+fQudvHzl4blgxdmUI1x1mLHCr2ioWAZQG5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFDfjV0IR8qi7JFJJ7EtIXPs0M6W9299ifHWkj1W+rE3VwFRu3LRKT0XPWeOMjLo1
	 iXnHPhjdloCwUmgQpbEgvWbSwruSDGU0GsgJDGgj7EjrxfZWKfByoHSgwzCKMAfWt/
	 BjCGlA63qAN+8hdI7FGnYXPWQ7JqKC+xfHorlM3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 212/713] nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update
Date: Fri,  4 Sep 2026 06:53:00 +0200
Message-ID: <20260904045808.569808224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 0a5a548861ab09e79a6b3062ac17e410323af3cd upstream.

clients_still_reclaiming() uses separate test_bit() and clear_bit()
calls on NFSD_NET_SOMEBODY_RECLAIMED. A concurrent set_bit() from
the OPEN or LOCK reclaim path arriving between the test and clear
is silently lost, causing the next laundromat tick to end grace
prematurely.

Replace with test_and_clear_bit() to make the read-and-clear atomic.

Fixes: 8c67a210c90c ("nfsd: convert nfsd_net boolean flags to unsigned long flags word")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-13-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6936,9 +6936,8 @@ static bool clients_still_reclaiming(str
 		if (atomic_read(&nn->nr_reclaim_complete) == size)
 			return false;
 	}
-	if (!test_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
+	if (!test_and_clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
 		return false;
-	clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags);
 	/*
 	 * If we've given them *two* lease times to reclaim, and they're
 	 * still not done, give up:


