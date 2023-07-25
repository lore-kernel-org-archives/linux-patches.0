Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DDB15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A5C433C8;
	Tue, 25 Jul 2023 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282804;
	bh=XHcGXGuhvoMuvi/gJHx84dsIHkJEGprisf7ZJ/Re1d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RM7sbDMRiYd+a3qzjesuCzcu9HDm9mBnetDUvvYqPolszNYNecdgzhAeQctZExFK2
	 Jqeq0dQWUj9onkZsGBh2b/imByJ9JYXvpUelXhTbNK2MgQW+k0Ut238KTxYMZKoRwY
	 UxFhlXBDvlD/IeJh7f3hScdKli6Po2NnymP74u7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 005/183] maple_tree: set the node limit when creating a new root node
Date: Tue, 25 Jul 2023 12:43:53 +0200
Message-ID: <20230725104507.986648638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 3c769fd88b9742954763a968e84de09f7ad78cfe upstream.

Set the node limit of the root node so that the last pivot of all nodes is
the node limit (if the node is not full).

This patch also fixes a bug in mas_rev_awalk().  Effectively, always
setting a maximum makes mas_logical_pivot() behave as mas_safe_pivot().
Without this fix, it is possible that very small tasks would fail to find
the correct gap.  Although this has not been observed with real tasks, it
has been reported to happen in m68k nommu running the maple tree tests.

Link: https://lkml.kernel.org/r/20230711035444.526-1-zhangpeng.00@bytedance.com
Link: https://lore.kernel.org/linux-mm/CAMuHMdV4T53fOw7VPoBgPR7fP6RYqf=CBhD_y_vOg53zZX_DnA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230711035444.526-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3711,7 +3711,8 @@ static inline int mas_root_expand(struct
 	mas->offset = slot;
 	pivots[slot] = mas->last;
 	if (mas->last != ULONG_MAX)
-		slot++;
+		pivots[++slot] = ULONG_MAX;
+
 	mas->depth = 1;
 	mas_set_height(mas);
 	ma_set_meta(node, maple_leaf_64, 0, slot);


