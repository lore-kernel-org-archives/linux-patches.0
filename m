Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E0E2BE630;
	Mon, 13 Apr 2026 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096532; cv=none; b=mtpQ9cQqMmoiJlFGLvPsZx+DKy6OvoII2SOVokyLUU2XbOzR/beXaPx8nsQ8sQLLQlFZ/MVUUovmSgYAogmtWA3lXPHSH7wphNgcJvLNiILaanjV1/ZSO8c73a1Ct2P0FCq/jyqQAXjiZROq7UOaG6sM4DF56CmEb5D0255qlAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096532; c=relaxed/simple;
	bh=KCLPmYW/6dIdl75gg2JJLSZWiN5kKk+fNCmmDyxCFOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLobW3y5EupLf/stcoBP0jJuonbFRTJ5tqKde/5R5kp5PzG4Kb8KNQDE5m9qrXZgpPL86Iv/mHLTrXOqXBIT50wrahiTpZpvzMRztXMb/Cu77wo6gLrOUPqHbbuWt1dHk6tVIJgerbxsLnC5bnmmXIUQte1/SaTAF0XdN1XSahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3v/KmAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3v/KmAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BD8C2BCB0;
	Mon, 13 Apr 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096532;
	bh=KCLPmYW/6dIdl75gg2JJLSZWiN5kKk+fNCmmDyxCFOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3v/KmAuWE6VdgDxmuYquJR3/21497+4Ss0Wan/NWVgPNXCK9uHG236pZ/CnKrEF/
	 rp+5f6sTTwjruxQshLeegrj9zYNdGdZUsqyUx77KKvjSH7bvfTYh2HhFROfnT9gbC6
	 8Igr4l6vViA43ddu2fyajxHSCCtVOtzx3zkaqqAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	robbieko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 15/83] btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()
Date: Mon, 13 Apr 2026 17:59:43 +0200
Message-ID: <20260413155731.595739295@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: robbieko <robbieko@synology.com>

[ Upstream commit 316fb1b3169efb081d2db910cbbfef445afa03b9 ]

After commit 1618aa3c2e01 ("btrfs: simplify return variables in
lookup_extent_data_ref()"), the err and ret variables were merged into
a single ret variable. However, when btrfs_next_leaf() returns 0
(success), ret is overwritten from -ENOENT to 0. If the first key in
the next leaf does not match (different objectid or type), the function
returns 0 instead of -ENOENT, making the caller believe the lookup
succeeded when it did not. This can lead to operations on the wrong
extent tree item, potentially causing extent tree corruption.

Fix this by returning -ENOENT directly when the key does not match,
instead of relying on the ret variable.

Fixes: 1618aa3c2e01 ("btrfs: simplify return variables in lookup_extent_data_ref()")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: robbieko <robbieko@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fa83a3d8286ca..863b45092a190 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -476,7 +476,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			return ret;
+			return -ENOENT;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
-- 
2.53.0



