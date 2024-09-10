Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4705E192581;
	Tue, 10 Sep 2024 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962693; cv=none; b=e9HUp02w5iA1Q8DaEvX/vsu3gK8Bt2eRp35xktifboVB3DNKolvritLCdnXj3Bh72J5qw0l9UvqkeIUPMEutlWWXjdcxEek0Ws33tm3ZzGoOlebfI4Ug4KbHT5+F2X2MFywqJ18REWvize1NaY9FLpyoOI+yUhTYwvEASR6h8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962693; c=relaxed/simple;
	bh=196ycIMGKaN3v8nAAksoHcYeau6Mzn7Gx1SaW4EphN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JklGwyPG5PDmPHvLhM9B6nppm0//QLGOxUy+qBGAaOiX7eoBFGiIFAGAHMGziCows9sQWF/LRBaEwKyZhTeI9ZHXBxZCcc0Zys8VvqrMWSZH+Ae+CqVOLT++a9Z5z+DdNwzXmjxdgb/Acs0/a3DmPZVIH0PbDr8I0hl2Ni4fCT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjepIxwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjepIxwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E65C4CEC3;
	Tue, 10 Sep 2024 10:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962693;
	bh=196ycIMGKaN3v8nAAksoHcYeau6Mzn7Gx1SaW4EphN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjepIxwyxtbzfDU7E+zWKY79BXuMgTnt+2m3DYIltB6ovteR5NEHOKpEy6XoAiSLd
	 kEnt+Uo59EnZjCbRQT2qIsATWlvJ4zH2RNRLVeGqAi5uVO8gzRk9W0y4MVxQ861hXg
	 IjnwRdNgb1B7v1AIw3/+OHUQxe3DRwT2Ax/X2ToI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/121] lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()
Date: Tue, 10 Sep 2024 11:32:47 +0200
Message-ID: <20240910092550.222049709@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



