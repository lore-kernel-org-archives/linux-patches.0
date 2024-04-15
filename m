Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2B681211;
	Mon, 15 Apr 2024 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191339; cv=none; b=m+kc6NNbd9euefVoZ5miC4zEPKqLNCzz4UoUU7jYJbHaamVYw+tDea1CHew+BCj6bcaI0uNexScdXFKoxVKZApkBzsLgrj6h+HO5GYeqGvwgeplt28Ai+7DGcvNMVyTxKDliAMLll9D3naITa7psGZdeAjbW7YxY1ENF20DUsG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191339; c=relaxed/simple;
	bh=IcruxHLykUysva2eXZ90ZT6edl2pIoiGCa0Eq0zOvb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDdFpNEMkO6r1rxZDk2PnJptmSTYxlFPf9YgMjHSlaslF8lY+V14ZGciGtgEZycG6yDYIXHSCGmMFcfTZBbJL1POlnyZhhXUTm0gZXY+SXvIpibPf8YxA0kWxBCDXXns8p4yUWV8QTkHZ3ejVhHOuMpNEi2eAZtuXxMkUbon6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCGzsMD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCGzsMD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DB7C113CC;
	Mon, 15 Apr 2024 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191339;
	bh=IcruxHLykUysva2eXZ90ZT6edl2pIoiGCa0Eq0zOvb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCGzsMD26BRWLCAlv6Sero3Kowq1ZbbPs03GcMO8vYbiC6sTO/EtOaHJWv4G6E2qR
	 1/9ULEfaNQuHKL9IzkObvPanoi0bGxsRXt7r+7DZpsi3Q6UuKBtCAULdXBhLT8vc2L
	 UP+00CHzbRfZRwDkNpp8oNnNKlDvkhUvVttVJ8rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 111/172] btrfs: qgroup: convert PREALLOC to PERTRANS after record_root_in_trans
Date: Mon, 15 Apr 2024 16:20:10 +0200
Message-ID: <20240415142003.767854917@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -747,14 +747,6 @@ again:
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
@@ -788,8 +780,15 @@ got_it:
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
 


