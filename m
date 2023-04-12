Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE02F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BC8C4339C;
	Wed, 12 Apr 2023 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289616;
	bh=aI4M7EE4gVaBl2iXNy36Vg5W4Jork4odzUodmoIETbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOuXqegwTmvm7WraiYDAwL81vqgATmpyNYhhLhsMs6t0XqBrSIMNWFsPANkRy8mhR
	 kg4bxlQFXd2h0l7D20jhGxl/pMZ0sIsdRJkR3IXhY4Ib5eZxQ6FUpIsVLc579EEVJA
	 /8vMosiptMFB6RU7kuFC6BGuWPvp+LK5pVDL3wa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 168/173] maple_tree: detect dead nodes in mas_start()
Date: Wed, 12 Apr 2023 10:34:54 +0200
Message-Id: <20230412082844.958316763@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit a7b92d59c885018cb7bb88539892278e4fd64b29 upstream.

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1357,12 +1357,16 @@ static inline struct maple_enode *mas_st
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
 
+retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
+			if (mte_dead_node(mas->node))
+				goto retry;
+
 			return NULL;
 		}
 


