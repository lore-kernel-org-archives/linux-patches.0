Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F720F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9925C433C8;
	Fri, 21 Jul 2023 19:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966510;
	bh=7J4d6NGuwRCd36v957zlPMCiWyDd2BfkYqaeEPDob2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0PXwMHswDqVdWmAbRkIvuDqq+Pev2SZakWU45g2fn7zNbqB/PKlJnCRklP/dUIyu
	 TlhRWzYVKZf7h8J0D+wp15xqHjCjLNpw+pTw88HNxqX1Jf/eaerZNdbZmRI/Tslcsf
	 rYrC6tBoGxsisY79HvZqhwvgm7Uc4oq+yeJZOkWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 369/532] btrfs: fix extent buffer leak after tree mod log failure at split_node()
Date: Fri, 21 Jul 2023 18:04:33 +0200
Message-ID: <20230721160634.491683236@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

commit ede600e497b1461d06d22a7d17703d9096868bc3 upstream.

At split_node(), if we fail to log the tree mod log copy operation, we
return without unlocking the split extent buffer we just allocated and
without decrementing the reference we own on it. Fix this by unlocking
it and decrementing the ref count before returning.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2637,6 +2637,8 @@ static noinline int split_node(struct bt
 
 	ret = btrfs_tree_mod_log_eb_copy(split, c, 0, mid, c_nritems - mid);
 	if (ret) {
+		btrfs_tree_unlock(split);
+		free_extent_buffer(split);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}


