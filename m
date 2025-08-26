Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76F0318143;
	Tue, 26 Aug 2025 13:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214827; cv=none; b=AF7PuUmD5Mh2AYQSGbPZobbHE/GLPdaaTiN9WpNZtAMVdSypyQcgEMU4stS5qnuu+5Z4aI8punz25p1MEiZTy806CW7loOMjgryqpqPE9g0R6r7bzUolc4JSHJ5wxXnaDjJWhsMxgD6OkDy5caE0BzYy+M62tSIS35dy8El4Qd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214827; c=relaxed/simple;
	bh=ZWcUwexZOJeav2v4SZtqSznXZB5hif0xU+PrZJtTyC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOWMTGYc6hR2amWip086GkZtY46OnZt7HGMCM3eW46pCCp240QXcJhb2mKSLn6g4Tk2guODhzwtjxmSsbUVI8V75Xxsu3YEo+Oe+tHVBfrkn1VcyO0SrNgEBx8KaKqjXR1Fm/wTaTyilnH3hzyOmLfKDDpZBwqILtiUmMA701oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKjC0e+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKjC0e+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2CBC4CEF1;
	Tue, 26 Aug 2025 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214827;
	bh=ZWcUwexZOJeav2v4SZtqSznXZB5hif0xU+PrZJtTyC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKjC0e+qB2gUL3+GPlHx9yJTLam3aP22tgE9WFHUkgo5mlPqeYqbvdrNNk7kx5bl3
	 68eHf92CtpMHg5j2DA5V/SVyv6T39UDepgjOzRE2TCxHd31mha2DGQZpUHokxQGH0w
	 BP1OIip3kmdj87n91NJIrj9g11fpIyFotL1L/qOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 253/482] btrfs: abort transaction during log replay if walk_log_tree() failed
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826110937.018241177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7252,11 +7252,14 @@ again:
 
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


