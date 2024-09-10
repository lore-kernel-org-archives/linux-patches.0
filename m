Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A5618FDC0;
	Tue, 10 Sep 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961397; cv=none; b=LXtVjigadskuqDP5ghr9h5GtgJdUlt85QI3McPnLdKNILYmCQ4NMjs51xfJNJA+YG4Az4Ap1Ck39VjOc8iUjtKF+IFYqnCxuC9FLbT9Gk+YX1oabYDi1vwgn9ukL6lw5d5Ob1lE+q2HPtkqxgug+89BE89sD2ZYsPgMnJGxH0nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961397; c=relaxed/simple;
	bh=w59tTSiXMalU2O04zEt6Yz+f6Vdgxdd2ND9UxyyPQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQmSxZar1vc3Je71/gtG7ULIK763yODoqSABfk5FBRRL/i3L29cVxlKb4e+FDLCEnQrhHDoOKEiepIHf2oWAZu0wANdI7ZwQXjtRfI8ongms0LbQLjRa3y1999VlHi5MEjyAxYrenrC1J2lexxwVelxbTlByGszoqqQVqWNVKWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js7K6JKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js7K6JKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CE1C4CEC3;
	Tue, 10 Sep 2024 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961397;
	bh=w59tTSiXMalU2O04zEt6Yz+f6Vdgxdd2ND9UxyyPQjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js7K6JKA2zYaaRtmj5xNLowi1hc3yZDu+Rpq7233vYY+TJ51qjGD5xlyRhdsEutDo
	 hwBKT2f6aU6Xi+9TiAMXaQdic0E0zqSvH7/GZbDuU7uzcAOd9dFtpmNXtb1DQXiyoO
	 gxFfp41bl6hP4aFXSupYrLhMVKlqXPw4V6xoSfT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	syzbot+036af2f0c7338a33b0cd@syzkaller.appspotmail.com,
	Hillf Danton <hdanton@sina.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 056/375] maple_tree: remove rcu_read_lock() from mt_validate()
Date: Tue, 10 Sep 2024 11:27:33 +0200
Message-ID: <20240910092624.116546913@linuxfoundation.org>
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

From: Liam R. Howlett <Liam.Howlett@Oracle.com>

commit f806de88d8f7f8191afd0fd9b94db4cd058e7d4f upstream.

The write lock should be held when validating the tree to avoid updates
racing with checks.  Holding the rcu read lock during a large tree
validation may also cause a prolonged rcu read window and "rcu_preempt
detected stalls" warnings.

Link: https://lore.kernel.org/all/0000000000001d12d4062005aea1@google.com/
Link: https://lkml.kernel.org/r/20240820175417.2782532-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reported-by: syzbot+036af2f0c7338a33b0cd@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -7569,14 +7569,14 @@ static void mt_validate_nulls(struct map
  * 2. The gap is correctly set in the parents
  */
 void mt_validate(struct maple_tree *mt)
+	__must_hold(mas->tree->ma_lock)
 {
 	unsigned char end;
 
 	MA_STATE(mas, mt, 0, 0);
-	rcu_read_lock();
 	mas_start(&mas);
 	if (!mas_is_active(&mas))
-		goto done;
+		return;
 
 	while (!mte_is_leaf(mas.node))
 		mas_descend(&mas);
@@ -7597,9 +7597,6 @@ void mt_validate(struct maple_tree *mt)
 		mas_dfs_postorder(&mas, ULONG_MAX);
 	}
 	mt_validate_nulls(mt);
-done:
-	rcu_read_unlock();
-
 }
 EXPORT_SYMBOL_GPL(mt_validate);
 


