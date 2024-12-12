Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E6A215F5A;
	Thu, 12 Dec 2024 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016166; cv=none; b=aRoLrH7YqDv0w3EJSL2Cibmyi2tvJkoHDVlMnDllCdShHP9nGoldrf3u/TqVZfl9iSM3veYQAIv/GweKzQKWmZ8E7Fl1vA+qfUExpvwO2AU5CQnfd+Od8PEPvNOWP5n6tUHrCd2dZtw9Hu8KyVQ2Npc9/cFXWXdCG8geP2VJPgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016166; c=relaxed/simple;
	bh=7CTzYORPT/jt9qUceaWlujAS/81gWEd99vrGHq2if6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp6wIiW0iBTdbw/2kXBijqtFKbQdjpVbfBBG5MxdylVd7zKi+mqipdyOn9wCzWvbnk9aG0p4RcpJ8Ax2OywL5Xua6JN67CdN2J6NNtB6/e23akPyhHIZsYSuQfXVyZc9DA1S2B8sF35OLVxNiP/6w8gzMGaT+leG56SqZ/dPLqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duRl2bnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duRl2bnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101B5C4CECE;
	Thu, 12 Dec 2024 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016166;
	bh=7CTzYORPT/jt9qUceaWlujAS/81gWEd99vrGHq2if6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duRl2bnKAs8yrsGFSY+26NQmHhh1DK7VZWv5F8vq/Lrq8a0D8fRPE/cR8VIiwZaLH
	 N2njBDcWXu2wVbOE/PazbYT/uWQqZfIiWkpCKjBqtyzd+JVKjy9brFgiKQY2697yR7
	 ejNLV06JolMxoWL3lfl+3YFVgWldpa3qJuOpp8aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 131/466] tracing: Fix cmp_entries_dup() to respect sort() comparison rules
Date: Thu, 12 Dec 2024 15:55:00 +0100
Message-ID: <20241212144311.978300514@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit e63fbd5f6810ed756bbb8a1549c7d4132968baa9 upstream.

The cmp_entries_dup() function used as the comparator for sort()
violated the symmetry and transitivity properties required by the
sorting algorithm. Specifically, it returned 1 whenever memcmp() was
non-zero, which broke the following expectations:

* Symmetry: If x < y, then y > x.
* Transitivity: If x < y and y < z, then x < z.

These violations could lead to incorrect sorting and failure to
correctly identify duplicate elements.

Fix the issue by directly returning the result of memcmp(), which
adheres to the required comparison properties.

Cc: stable@vger.kernel.org
Fixes: 08d43a5fa063 ("tracing: Add lock-free tracing_map")
Link: https://lore.kernel.org/20241203202228.1274403-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/tracing_map.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -845,15 +845,11 @@ int tracing_map_init(struct tracing_map
 static int cmp_entries_dup(const void *A, const void *B)
 {
 	const struct tracing_map_sort_entry *a, *b;
-	int ret = 0;
 
 	a = *(const struct tracing_map_sort_entry **)A;
 	b = *(const struct tracing_map_sort_entry **)B;
 
-	if (memcmp(a->key, b->key, a->elt->map->key_size))
-		ret = 1;
-
-	return ret;
+	return memcmp(a->key, b->key, a->elt->map->key_size);
 }
 
 static int cmp_entries_sum(const void *A, const void *B)


