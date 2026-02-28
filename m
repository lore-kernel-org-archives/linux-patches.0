Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0D39B953
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302516; cv=none; b=nu6rTYj69qXwAr/dxqCVVYeCSJ0dVoVMoWtTmJLHtpfZ7dv9LQEMQawXEbqCvtLQUgJ41SGJkUbJPVi177c+x7E73a5SkEa5iTgywPzStCVINxNwgdr+JA7pw7CWJNu55XdfsVDHQfD32KnVDAqi7T3r0BkU3c9mtGiJWtlaBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302516; c=relaxed/simple;
	bh=NtkLGugsCcEXX+/HxioqjCFXT3WxMU5n3pZUZlohBxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7kA6+W/hfyquRo4zXYOHu9wq9c28EmOkYj0ufIdF59/Dcr4/njIJF69on76mp/wxllSnlJlrVM4QHoTiBmdZ77THVpyL+blGqnOtAl2YB2BzesHRIgLAjT5+yewsVyQqIoCuTDcqX6ZdGmHr7JquxthhTo/Q4T7KNjREDzBVBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AC7Kh6eD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AC7Kh6eD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F0BC19423;
	Sat, 28 Feb 2026 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302515;
	bh=NtkLGugsCcEXX+/HxioqjCFXT3WxMU5n3pZUZlohBxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AC7Kh6eDZ1ChlhwiagH1HCfQ0Gh2FN1qfZiEv0+sgZDUDg5fBkxY+9utnzAFPtLVw
	 rS0kjO60NA45tkaIFu2J9n1A0aLJfSGAE7oeGywAG0nZU1pEfHWd42HPsIRyCZ9qI0
	 OgWCGPDhEcE8xAMehxeKsE4ebFAu+h+CRGx/yiSV5Y4V2YFfhOprE6GFYT7wNX96B8
	 K/vCfLaHBaMDorRpoV2lTZa1YXR3NkjDnrKBc4c8oZVDym8WkuzPc4G7L0O6/WPcz1
	 heCl4vlhGaAa8MDh/ArPf31CK8i43GamRlZPchXLhSVWt3nFFz7+sc1d4zhvUUGJug
	 w9Tv82Hhi/B7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/164] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Sat, 28 Feb 2026 13:12:31 -0500
Message-ID: <20260228181505.1600663-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6cff41c46d02e..4593ca523490f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1540,8 +1540,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0

