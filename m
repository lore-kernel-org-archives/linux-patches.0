Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE803C1FFF;
	Thu, 15 Jan 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498104; cv=none; b=Kttp/+bXqJLs1YT964l4205XAxtD/3Z+G866xpTFaLnVbRRi4e6Z93W6xLZm81Aq3w5gfM2PGajKtQJ1/BBgZvkMkOXVH0QTBwj0BuIATIZycGgf2JBTZvNufn7AHb3NatZRo/UeZ8IcqwvYlEzqONAssSM1ask2rKCgsXb2Iak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498104; c=relaxed/simple;
	bh=kLa+EhI/THGfo95SEqsPFB6Rt/lmuG5sPSbTLdn9C3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM5YW+YEO9HUeidGBC6srlMb8sjRHcRwL+NVp+MM21tI7pe7VGRiRLRx0qw2wbaOWoaPsdZ1jvYVymIE5F7LWKPnPCWLE/BlsN179i77S3AZCAxph0B8Y4ZXyu4Tl8lBvCfkhDhK76rT2yGc4bmH78pJYq390dFQotUpxVpPb/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6fSvSyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6fSvSyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA93C116D0;
	Thu, 15 Jan 2026 17:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498104;
	bh=kLa+EhI/THGfo95SEqsPFB6Rt/lmuG5sPSbTLdn9C3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6fSvSyKPsYYxUskUsvq5MDQrL1uwzZB9iqeA+fp7Ciqs6dRho8u2tgUZmd7NiYlb
	 WOA9kQns9Qxeb2ak7WyMm0ivNJGuczopB29cQloCXwiuYI6a24iDJRED+5yiAKep4f
	 OMHvb5tU9yRSn2pSu7jlY5RHOzpX4FPSrcfJqUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 281/554] fs/ntfs3: fix mount failure for sparse runs in run_unpack()
Date: Thu, 15 Jan 2026 17:45:47 +0100
Message-ID: <20260115164256.400367184@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -937,8 +937,12 @@ int run_unpack(struct runs_tree *run, st
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
 		} else
 			return -EINVAL;


