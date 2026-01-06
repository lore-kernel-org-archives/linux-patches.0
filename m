Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2244355034;
	Tue,  6 Jan 2026 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720200; cv=none; b=i/ORpDZcKSNvXygC30c+Od0h5X0mIrlqRjIpH86CCPupo4rtxeAaSbgDQgmrnkpvbsTkWiZxYB4fbksBmdkiCHBDR3JP3cgAWLZqa+0UFEyj7cqXE7n8kwvNcoeON0PCQ/a74lu+I3TsTL0SrulMuxbOXLMn5ptOGoF6hE2sRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720200; c=relaxed/simple;
	bh=8Z4/faM0hnpX2XEvLLJ/4Qd8wRGDfK9RZnwkw2/o7RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faSsWNTFteLB4HnL0kd2FL2TqwFQ1PcjyTdWRTyatdlus9we9CcNQgZpfHLHA07Yw/EshdmXmKMO831Nmt4A19dTMyv2OGA1B46ROog9eAm5PonDmp/LgfZuaSDzllzEJuCQ1NyW2AZPbPNTmjhShkwn2nJm17STVAE/qzKBXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CLsD62Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CLsD62Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23657C116C6;
	Tue,  6 Jan 2026 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720200;
	bh=8Z4/faM0hnpX2XEvLLJ/4Qd8wRGDfK9RZnwkw2/o7RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CLsD62QSbcDC5A6/4Qs2+tXjD+wJ4vHHGVPCmRfq8YvWSsDvvdy2ehlKRwNcCX79
	 5EYIDH/Ob/rYDBOIg77GER3X1ZAx8HLSNgi3QOPRzaQBlsv70p8jqMe6/KLDvUexwS
	 0Wb5ED59S+gxVDijym/X2EgBcfn7ic3TPIaERUCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 164/567] fs/ntfs3: fix mount failure for sparse runs in run_unpack()
Date: Tue,  6 Jan 2026 17:59:06 +0100
Message-ID: <20260106170457.394415427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 801f614ba263cb37624982b27b4c82f3c3c597a9 upstream.

Some NTFS volumes failed to mount because sparse data runs were not
handled correctly during runlist unpacking. The code performed arithmetic
on the special SPARSE_LCN64 marker, leading to invalid LCN values and
mount errors.

Add an explicit check for the case described above, marking the run as
sparse without applying arithmetic.

Fixes: 736fc7bf5f68 ("fs: ntfs3: Fix integer overflow in run_unpack()")
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -984,8 +984,12 @@ int run_unpack(struct runs_tree *run, st
 			if (!dlcn)
 				return -EINVAL;
 
-			if (check_add_overflow(prev_lcn, dlcn, &lcn))
+			/* Check special combination: 0 + SPARSE_LCN64. */
+			if (!prev_lcn && dlcn == SPARSE_LCN64) {
+				lcn = SPARSE_LCN64;
+			} else if (check_add_overflow(prev_lcn, dlcn, &lcn)) {
 				return -EINVAL;
+			}
 			prev_lcn = lcn;
 		} else {
 			/* The size of 'dlcn' can't be > 8. */


