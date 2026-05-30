Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1938E30EF7D;
	Sat, 30 May 2026 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163576; cv=none; b=GbTpZq7syGBVh6Y2qS4g+nbqZP9RdO9n266CrYWyKzKnQRizJl0s9AuRmzwpoJgOCP4/BKZULSVOBIv6wQIBHS5kKMteXcqPLr8KKgVygy8Fajbi7q7IxcMa4rmQtjGFiqOPICLpCJ6xHY6S8ueIhrsrBa5rWXVm6wmHuUkYC/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163576; c=relaxed/simple;
	bh=kiOLFtVGo3w/0zcxr7OLA/nyoTMvz0A9M3K1hHkFkyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFzTFZ23Fd1m0A2/gYPP27dlLOzatGtvePuPA5mKf3BH6IfDyyGgIxjX16WlWTcc/A6CHwt4hoF3KIrWU+sgzXFJ9Y6G86mXhfvzh7ps7exIb3BMm9xj8M5QKx5BuHJI9ugbOWIvEetRt2l6iMhzEBOFnQoG8UyqtJ5Hwf4Wwj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBJ4nN1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBJ4nN1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600791F00893;
	Sat, 30 May 2026 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163575;
	bh=gJc9nt58NUwhD267omAx9JkBMGyATgarmnycEXOlqKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBJ4nN1kq1hKX4sdDVewppBZRVTsbbqRnD8w/OCLDdGXhiGoWbVN8wt4eswvQGuKp
	 IutbjMkC1PBqv3g/bqlrrI7nvMOkP+zi7O1yHYxa5vA/THcyPq0fvg/XZuAdW8jgmF
	 XFxLEDrLDoQFbD7vYUSD3n96Q684VcnH2grX9xRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 260/776] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Sat, 30 May 2026 17:59:34 +0200
Message-ID: <20260530160247.257870390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -971,9 +971,15 @@ int run_unpack(struct runs_tree *run, st
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


