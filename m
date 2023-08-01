Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8851F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B0C433C8;
	Tue,  1 Aug 2023 09:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882070;
	bh=UsvybR/eQInHUzkWNh36Hdv50SGT0lNb8iTRR9+DykM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPQpq4G2xVm7SO5stbuc6WdWcOkQtCCtCnTPf/v0XSVp7SJncc9A+LdUIJHX5ohEs
	 HeidpJJc92tXEvJSdJtKFfGC+I6nfbDZgG0hvtR92QOjZq5s0x4jI3kaLZcSrmvi8I
	 +3a+9tAodwHYs4NdorhmufYlpc04zdGsag1w2W3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 131/155] btrfs: check if the transaction was aborted at btrfs_wait_for_commit()
Date: Tue,  1 Aug 2023 11:20:43 +0200
Message-ID: <20230801091914.854964055@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit bf7ecbe9875061bf3fce1883e3b26b77f847d1e8 upstream.

At btrfs_wait_for_commit() we wait for a transaction to finish and then
always return 0 (success) without checking if it was aborted, in which
case the transaction didn't happen due to some critical error. Fix this
by checking if the transaction was aborted.

Fixes: 462045928bda ("Btrfs: add START_SYNC, WAIT_SYNC ioctls")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -936,6 +936,7 @@ int btrfs_wait_for_commit(struct btrfs_f
 	}
 
 	wait_for_commit(cur_trans, TRANS_STATE_COMPLETED);
+	ret = cur_trans->aborted;
 	btrfs_put_transaction(cur_trans);
 out:
 	return ret;


