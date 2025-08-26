Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BB5FBF0;
	Tue, 26 Aug 2025 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213338; cv=none; b=C6GxFHgRQDzUgmkhY+GcDLfGmBGobXKQzzGr0qWx94m49g/XDhBKSLHicS72oVF+GySI81JvtnaGfGLkD6XnE5crTz/htWLwC0+/cqQYwClnlYkCvSqMQwKXIhQthK3eST1qr6aswTwYaUKtKeWigzIk9vPsELGzr4QDdBrzum0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213338; c=relaxed/simple;
	bh=i+Jj41Zw3aiakUL0piURaAgY7gQF9Igq7vFwecT70r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGR70yxZYIbK9/qw+2O1+uOMZ31HFGGV/6hsC6gCoNyRpwydweOglsSpRTiMPNEf7DcOeGe1MCndWt9ZfzARTlBpQyEEkVqpCCQkphMSIkPIglnmvVPV3g56QexbGe+dnFdjIwECdvlOkiwW5AYW5LBQxrC7ICXe9n9DhMivp88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBavY+ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBavY+ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FA2C4CEF1;
	Tue, 26 Aug 2025 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213338;
	bh=i+Jj41Zw3aiakUL0piURaAgY7gQF9Igq7vFwecT70r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBavY+ONjp0RFX0cz9KMoV0Ty06tl+CqK9OdPHxq/9Szuo+2fOQVyci/+h3YFretk
	 K08PnQdaayKi/8YYeTipLQ30s47Wq1qdTJSl3pJK2VD/+Y77edhwYZbIlkrzPJMgX4
	 ucwHcjeHzH3Z2g6BCBryWZoPNOF9sHp2kEjoGBJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 310/587] btrfs: abort transaction during log replay if walk_log_tree() failed
Date: Tue, 26 Aug 2025 13:07:39 +0200
Message-ID: <20250826111000.804363056@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2a5898c4aac67494c2f0f7fe38373c95c371c930 upstream.

If we failed walking a log tree during replay, we have a missing
transaction abort to prevent committing a transaction where we didn't
fully replay all the changes from a log tree and therefore can leave the
respective subvolume tree in some inconsistent state. So add the missing
transaction abort.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7300,11 +7300,14 @@ again:
 
 		wc.replay_dest->log_root = log;
 		ret = btrfs_record_root_in_trans(trans, wc.replay_dest);
-		if (ret)
+		if (ret) {
 			/* The loop needs to continue due to the root refs */
 			btrfs_abort_transaction(trans, ret);
-		else
+		} else {
 			ret = walk_log_tree(trans, log, &wc);
+			if (ret)
+				btrfs_abort_transaction(trans, ret);
+		}
 
 		if (!ret && wc.stage == LOG_WALK_REPLAY_ALL) {
 			ret = fixup_inode_link_counts(trans, wc.replay_dest,


