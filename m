Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD1188A38;
	Tue, 10 Sep 2024 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965232; cv=none; b=ihHl7z9eBBJQLlD30TY5SPhFGN4wzxBJaB3V4j+uXLpyKLiS1s4WdK+f7pXoIABj3aT6Bbeon8DoIzD9riDTFM6v3nXCo9hQVvR1mue4+reP10kmAt2P/H4KjFt3nida3+eiESjv+M3ubs7wQ3u72rLSjxTrj5DuOM3Lt2stUbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965232; c=relaxed/simple;
	bh=31lougarGKOHIGsNhzLIo9/rfqxGa9j06w59OHJznyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD6Bl8ZRwgjgh8KGT/wRaxg+3Pk+AgDKYb3BwZQSgRm42szIB28xUgTWfkvUtAkylfznGEd7Dj+f9Sz2N/COLdliFDoUDK1zbYMLQO4S6JgM3gcK3KRLvKGSgCOkd/K4A5UOqZkuojlVS/8dXj3P5Gxy5LRwSx8RwqhGQcF6VQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTNsr2LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTNsr2LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148A4C4CEC3;
	Tue, 10 Sep 2024 10:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965231;
	bh=31lougarGKOHIGsNhzLIo9/rfqxGa9j06w59OHJznyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTNsr2LUN1jQBZt4PX2Qwl/AcaHfjsFDkWOYfpyHWW3pSDp+vCbJ0tQsCBT+71APi
	 z+W12Qqg7EkJ0ikOwTFTWOZEcJSLNFmgWuyntAa+nNbo0PHCuc7UgwhDBPrUJBfB2q
	 65X7r8wj+9KlNA3gWXKQsPOnz6iZ/+mRlTrxlsec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/186] lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()
Date: Tue, 10 Sep 2024 11:34:09 +0200
Message-ID: <20240910092600.932432477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit b2f11c6f3e1fc60742673b8675c95b78447f3dae ]

If we need to increase the tree depth, allocate a new node, and then
race with another thread that increased the tree depth before us, we'll
still have a preallocated node that might be used later.

If we then use that node for a new non-root node, it'll still have a
pointer to the old root instead of being zeroed - fix this by zeroing it
in the cmpxchg failure path.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/generic-radix-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index f25eb111c051..34d3ac52de89 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -131,6 +131,8 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 		if ((v = cmpxchg_release(&radix->root, r, new_root)) == r) {
 			v = new_root;
 			new_node = NULL;
+		} else {
+			new_node->children[0] = NULL;
 		}
 	}
 
-- 
2.43.0



