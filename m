Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673EC224F6;
	Tue, 10 Sep 2024 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961952; cv=none; b=AkPmbGjonUSmy1UqMXMbALMBrmzpmVdHSkFhpQlnJx+4xiP/CvwPmHjrvQkWFFtMrAC9oXTu6Ejm35vecV1U7lpo2pHBpV2rELDW8X1OT/sXY2e1MqumF/Wz+WeCvkLEu1pvVwh1hjCWJKswuBxyS9aDfAzzVptksL8BXQoQXiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961952; c=relaxed/simple;
	bh=33tJgdjbRJxYfOhpllHzk7/W916DKSROQb1yCSd+bf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAeH7IpmiWN2XULnpZPh0UkrOuSlILSHGd6S6ICBcV34zwsxvwMX9aJzthNozU2/iJrfHxmrxpsmrfRfnedv/Dnlg8DHGDGQ58cMawrA42lLSIZQrNJmh73RfAhNnu9eZNZpQiaxhWlyqwk1rq3rOVJhBt7KbKHACYra7Msj/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/kLzdK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/kLzdK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC68BC4CEC3;
	Tue, 10 Sep 2024 09:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961952;
	bh=33tJgdjbRJxYfOhpllHzk7/W916DKSROQb1yCSd+bf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/kLzdK4ObsEfU8mQvT6y6Rpmclr3eRS2x2rI19i4dXADLMwMbR+QXM9vPIQbCmp2
	 7bj8Zp+1RxQ0idrt5yqmHHwTDTlZZkqDYEMuUuT332fqNaGiJNCDfy1M+hl5noL8+x
	 bFRyp70Fknex0jgXdwOtiv5TYHIoPFB9d+17JC1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 244/375] btrfs: replace BUG_ON() with error handling at update_ref_for_cow()
Date: Tue, 10 Sep 2024 11:30:41 +0200
Message-ID: <20240910092630.746704500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b56329a782314fde5b61058e2a25097af7ccb675 ]

Instead of a BUG_ON() just return an error, log an error message and
abort the transaction in case we find an extent buffer belonging to the
relocation tree that doesn't have the full backref flag set. This is
unexpected and should never happen (save for bugs or a potential bad
memory).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8a791b648ac5..f56914507fce 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -462,8 +462,16 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	}
 
 	owner = btrfs_header_owner(buf);
-	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID &&
-	       !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	if (unlikely(owner == BTRFS_TREE_RELOC_OBJECTID &&
+		     !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))) {
+		btrfs_crit(fs_info,
+"found tree block at bytenr %llu level %d root %llu refs %llu flags %llx without full backref flag set",
+			   buf->start, btrfs_header_level(buf),
+			   btrfs_root_id(root), refs, flags);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
 	if (refs > 1) {
 		if ((owner == btrfs_root_id(root) ||
-- 
2.43.0



