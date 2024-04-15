Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4B2381B9;
	Mon, 15 Apr 2024 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192034; cv=none; b=YknwGX4NL07JkraEd52JiOiBnPE6yewESG2j3QyrRBQ3lECba5BPzFnxMDQ5SIISRnQM/15a6S2D7A1Pk7op9iejjywYxLRJ2BvBuVCSMXaFXIfntFrtaJ8U57ADPCghqSdhsvxOHiKG2G7cRU+ema9n1YdWS1n70L+AaumX6tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192034; c=relaxed/simple;
	bh=abgiGBxj3maymcVir2JJtaWyyV8X46jqiqjrjj9cF2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNYiDTAu68aAu/53kCbJf+Jxp4XQ8ZvrmUhAwLD70fTJ77xSfKeOpGKYCpRRfgzs7Ev90AQQiEaeJCNq16mwgU+ywWcIjZ2VAstdckIjc6bZCud3ezrmrGinAECMpiD5gZXZyQQWUuQ6+5/Ezl8tE1KrGi/VQRrPR9Jc/MFMQ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atMl37UQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atMl37UQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E522C113CC;
	Mon, 15 Apr 2024 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192034;
	bh=abgiGBxj3maymcVir2JJtaWyyV8X46jqiqjrjj9cF2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atMl37UQLGKIaRggkkidZpj7qIuJLbEB3bmBZx3yR4Uk6MNdPAcItrlQsOHCCx5EP
	 GppEPir+y8jITvjSPUe5rP1G7pJERKaqWd0OnE5UTf3BakatinQzOlZOUvCd8wmasn
	 hQ9QnDEZxGyKm1LPMP5QpCIYjdfWU107Zl4aFwBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 43/69] btrfs: qgroup: convert PREALLOC to PERTRANS after record_root_in_trans
Date: Mon, 15 Apr 2024 16:21:14 +0200
Message-ID: <20240415141947.462543702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 211de93367304ab395357f8cb12568a4d1e20701 upstream.

The transaction is only able to free PERTRANS reservations for a root
once that root has been recorded with the TRANS tag on the roots radix
tree. Therefore, until we are sure that this root will get tagged, it
isn't safe to convert. Generally, this is not an issue as *some*
transaction will likely tag the root before long and this reservation
will get freed in that transaction, but technically it could stick
around until unmount and result in a warning about leaked metadata
reservation space.

This path is most exercised by running the generic/269 fstest with
CONFIG_BTRFS_DEBUG.

Fixes: a6496849671a ("btrfs: fix start transaction qgroup rsv double free")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -700,14 +700,6 @@ again:
 		h->reloc_reserved = reloc_reserved;
 	}
 
-	/*
-	 * Now that we have found a transaction to be a part of, convert the
-	 * qgroup reservation from prealloc to pertrans. A different transaction
-	 * can't race in and free our pertrans out from under us.
-	 */
-	if (qgroup_reserved)
-		btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
-
 got_it:
 	if (!current->journal_info)
 		current->journal_info = h;
@@ -741,8 +733,15 @@ got_it:
 		 * not just freed.
 		 */
 		btrfs_end_transaction(h);
-		return ERR_PTR(ret);
+		goto reserve_fail;
 	}
+	/*
+	 * Now that we have found a transaction to be a part of, convert the
+	 * qgroup reservation from prealloc to pertrans. A different transaction
+	 * can't race in and free our pertrans out from under us.
+	 */
+	if (qgroup_reserved)
+		btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
 
 	return h;
 


