Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3181BC086;
	Wed, 20 Nov 2024 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107562; cv=none; b=QNV5we4/AgE4YjqxEPpWf7Xvm9g78HtjLz+y3UVqXLkIP+uSOQmaFGkmcIXwezVMADxBUprswPwrOhQizsIrELL0Vyidnb3SeEh0+DXsPAtY+ZsG+7ojnWJWZmUAVeC8gSGoJNNDPKtY/dV4+u7t5enGX6B7WdZVjvuCW3AgqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107562; c=relaxed/simple;
	bh=tJ+4CI9JqdPCjvGko3Vaw/jvj1qEAsUzqPDu98dzREk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbGGgsXEZLzosW7Vz7RemYEJx1nXVWkqr/pBbnL6JLT9iwiq/oE+ciAXWYDR5rIv+te+sEqYCdSCDluWbNz5C0mNqjkYjReD5lJ/1G2cu09pGLiDP25sr+w3N/UkDu3rBdzwe061RGNhBV9SC9FWj8pF/0rYh+8FHTZzRGoDpnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEH000NJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEH000NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43339C4CED8;
	Wed, 20 Nov 2024 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107562;
	bh=tJ+4CI9JqdPCjvGko3Vaw/jvj1qEAsUzqPDu98dzREk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEH000NJjOvJXi26Kjr48T/k4iADxmNb42hAW8tPTZ5anQTvxjWCN4ILABv8EyEe9
	 UDgAowAuG/1i2umPUmQf/3Zc2COo+qZXlwFn9CjMyucL5lQ0dn8eVM5AFYd0rkOZ0n
	 MawLeO+uUIzWdBXcT+cxfczEk3ppXiVNOF0s4+nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 078/107] btrfs: fix incorrect comparison for delayed refs
Date: Wed, 20 Nov 2024 13:56:53 +0100
Message-ID: <20241120125631.442179839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 7d493a5ecc26f861421af6e64427d5f697ddd395 upstream.

When I reworked delayed ref comparison in cf4f04325b2b ("btrfs: move
->parent and ->ref_root into btrfs_delayed_ref_node"), I made a mistake
and returned -1 for the case where ref1->ref_root was > than
ref2->ref_root.  This is a subtle bug that can result in improper
delayed ref running order, which can result in transaction aborts.

Fixes: cf4f04325b2b ("btrfs: move ->parent and ->ref_root into btrfs_delayed_ref_node")
CC: stable@vger.kernel.org # 6.10+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-ref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 65d841d7142c..cab94d141f66 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -298,7 +298,7 @@ static int comp_refs(struct btrfs_delayed_ref_node *ref1,
 		if (ref1->ref_root < ref2->ref_root)
 			return -1;
 		if (ref1->ref_root > ref2->ref_root)
-			return -1;
+			return 1;
 		if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY)
 			ret = comp_data_refs(ref1, ref2);
 	}
-- 
2.47.0



