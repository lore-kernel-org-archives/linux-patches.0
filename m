Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A75E3E3DB9;
	Mon,  4 May 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904884; cv=none; b=BG+OOS/0n1/5/OAx1xEljBZGz43K81ZmQgdAR3jPHpPbfeyDDBrVjYNeRphCGR8lAKv132/timc90mGWCVKPNFeCYN1W9N2iaT12CswJdsPRfId+ojhTlHUxTEdm5urbkHfvLwtcScFz80lXgd7GNxU0l+EbtlGoZa1WGzdYnnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904884; c=relaxed/simple;
	bh=mHNyCotEL8TLLiITSk7OTqORCvSmOP/CdOOpkBy46FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUX0ZkviXaGRFA9iIJIJo+KtqMFiPmrjJ3UQ702X4FLE0JU8XhphIpQgyWTZnQ3O7g73ud25/xJVsDoSLkmiFv+/ElwRcME7BjmYUxFDD88qSItpIGM5PZpED5JeGhVGODf6mOgo1YoRdaFFUMKR9ymGDQxVHUu74o2yY6Phyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fu3SFQ7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fu3SFQ7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B83C2BCB8;
	Mon,  4 May 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904884;
	bh=mHNyCotEL8TLLiITSk7OTqORCvSmOP/CdOOpkBy46FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fu3SFQ7sU+q9Qws865I3VvGZ35NBAutEQTmD2TGb1aVKvONWxsNYhSUaHRGPICnNk
	 8OFuHGK392XSXx0WyDYhy8BeTGkHdToDQBKGEmDdvieHyHB5edl5btY98EKdGy1jdQ
	 5y7RGI+S3hP1dhXVqPg2bW4ZCS6HIlV+cYCSsmCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 169/215] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Mon,  4 May 2026 15:53:08 +0200
Message-ID: <20260504135136.359294218@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Tobias Gaertner <tob.gaertner@me.com>

commit 984a415f019536ea2d24de9010744e5302a9a948 upstream.

The volume boundary check `lcn + len > sbi->used.bitmap.nbits` uses raw
addition which can wrap around for large lcn and len values, bypassing
the validation.  Use check_add_overflow() as is already done for the
adjacent prev_lcn + dlcn and vcn64 + len checks added by commit
3ac37e100385 ("ntfs3: Fix integer overflow in run_unpack()").

Found by fuzzing with a source-patched harness (LibAFL + QEMU).

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Gaertner <tob.gaertner@me.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1020,9 +1020,15 @@ int run_unpack(struct runs_tree *run, st
 			return -EOPNOTSUPP;
 		}
 #endif
-		if (lcn != SPARSE_LCN64 && lcn + len > sbi->used.bitmap.nbits) {
-			/* LCN range is out of volume. */
-			return -EINVAL;
+		if (lcn != SPARSE_LCN64) {
+			u64 lcn_end;
+
+			if (check_add_overflow(lcn, len, &lcn_end))
+				return -EINVAL;
+			if (lcn_end > sbi->used.bitmap.nbits) {
+				/* LCN range is out of volume. */
+				return -EINVAL;
+			}
 		}
 
 		if (!run)


