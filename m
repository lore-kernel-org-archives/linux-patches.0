Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7814534B4;
	Tue, 16 Jun 2026 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626209; cv=none; b=bgUKpdweVzzWi9KEG55rbwtlodzEOvs2vNLOBDra5qMSer0KS+UxoMQ1xm5o2lEEYVT157Ixr+SF1+GR4HYKyjsYhuFx+hoLdQH1VrX2odMhU1/5DyJv9mw8JFTHBENV/VxRk7WAyLHGIojr4iIbd7FGaLqgWTNoDqRYQrCJGmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626209; c=relaxed/simple;
	bh=IbUTAFMvUTIiAvnvi+nLjGyeersT0xSts9cCY6keEnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBfLYA0jPL9irQ89XyjUiEFuQWij1jQSz3It40MHTbXza/Lax+zBCiMus8wq+18IHUYYCWHMhvMGWCiK/p7F64Am6pQ0GRd2/Q5Y9CLD9dM682I4/ZUjrf3NWu0ctCnQTpWzUbJ/Ix+y4E3vnhHW+v5NsMrvuKOMxDLIOiuh2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaGG8xfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaGG8xfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D9A1F00A3A;
	Tue, 16 Jun 2026 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626208;
	bh=ix1Hpg2yWfpVdXOK5d2Zb5XxSkWLCAu2sMD5IRzuApM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaGG8xfdTOL6CGNCQymfbS3caUnZBy2FNGGBTPQUQH1ZD091Y+dzulp8U0j+vaj9Q
	 QGQKdJDeibaFBRbonCS+MB9jINJBVfhPl5peitqq3f4+SERLPjjj4E6x4XeLdw8d39
	 mUB4yQIxO70sjDLAnMtDlgS95mRk3IQVu54txUEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 251/325] mm/damon/lru_sort: handle ctx allocation failure
Date: Tue, 16 Jun 2026 20:30:47 +0530
Message-ID: <20260616145111.033070530@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit ab04340b5ae5d52c1d46b750538febcde9d889e7 upstream.

DAMON_LRU_SORT allocates the damon_ctx object for its kdamond in its init
function.  damon_lru_sort_enabled_store() wrongly assumes the allocation
will always succeed once tried.  If the damon_ctx allocation was failed,
therefore, code execution reaches to damon_commit_ctx() while 'ctx' is
NULL.  As a result, it dereferences the NULL 'ctx' pointer.  Avoid the
NULL dereference by returning -ENOMEM if 'ctx' is NULL.

Link: https://lore.kernel.org/20260529000104.7006-3-sj@kernel.org
Fixes: c4a8e662c839 ("mm/damon/lru_sort: use damon_initialized()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -339,6 +339,10 @@ static int damon_lru_sort_enabled_store(
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_lru_sort_turn(enabled);
 }
 


