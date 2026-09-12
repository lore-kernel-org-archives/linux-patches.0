Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9DE33993;
	Sat, 12 Sep 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223821; cv=none; b=RiXaC5XnwyPYykukQ55cZU2wXpiWu7Z7LjOznR6X0OPFMQ1KIIjc2Bw2Wt7K8W7UhEbV5JAiNLIV5m8ppB2Gz/H5XqKOzEm0dnH0/MM3N1ASICRv5QNXxGLRh2ZrilgJ1DP7DCtze9oAN2VeL/u5b7kUaHXMh/B87NvB7lpvjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223821; c=relaxed/simple;
	bh=0S8RkwvrqpLq41oS+y8uUOMM1uIT/UV2pYOW3mJafmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slNFei5jdUn3uAaUfquKITTzIM8BJWo0E7QJal/713e+gbrqP3pTgXc7AdD8LhHH7jhEhW6esTMsqAChdzmpwbm4rlBmMS0Z58Kncvrs+8OBUgCqL36o7jac9pkF/F29ORUgMnpcaSk/UjZ2js/TY5XLnYB3eGi5K9Lv5w818Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/5QXTXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/5QXTXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AFB1F000FF;
	Sat, 12 Sep 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223820;
	bh=/xgB6gRvBGUh4fIvjpzL8D6KzWu8l5xPivluZFpMyUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/5QXTXJkgBOUsWRzF/KOuEd0tWa+EzId1xxIqFpaBEM371unpw6xNmdTlGQ9dV/R
	 1TduZ54RJIEUdZgFGGqnnAo8niIpFPwg83JqqOwpCRwkiTBiSZAqq6vbcsOejfhxh9
	 5wD0pIFwokxgDjYxDYlj9+N9sr3zIaZY54wonMIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0868/1424] PM: hibernate: Fix memory leak in snapshot_write_next() error path
Date: Sat, 12 Sep 2026 08:55:00 +0200
Message-ID: <20260912065626.756761101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 21d5c4cee31c5ce78f6decc7fafc7e7759af391f ]

When memory_bm_create() succeeds for copy_bm but fails for zero_bm,
the function returns without freeing the resources allocated for
copy_bm. This results in a memory leak that includes radix tree nodes,
zone structures, and page lists.

Fix this by calling memory_bm_free() to release copy_bm's resources
before returning the error code when zero_bm allocation fails.

Fixes: 005e8dddd497 ("PM: hibernate: don't store zero pages in the image file")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Link: https://patch.msgid.link/20260711145246.8625-1-malayarout91@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c3ad93fc24e64..cd69e983870f8 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2808,9 +2808,10 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			return error;
 
 		error = memory_bm_create(&zero_bm, GFP_ATOMIC, PG_ANY);
-		if (error)
+		if (error) {
+			memory_bm_free(&copy_bm, PG_UNSAFE_CLEAR);
 			return error;
-
+		}
 		nr_zero_pages = 0;
 
 		hibernate_restore_protection_begin();
-- 
2.53.0



