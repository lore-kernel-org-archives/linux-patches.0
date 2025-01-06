Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0738634A;
	Mon,  6 Jan 2025 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178034; cv=none; b=NzWmDSHG0ccw/AFLMlYFksdY3nojc+AVD1HYANX/MCiatuTi75BYqHek+L7reTDffHZOUutyZBzAQyJIijaT3t44iqbBj6wyhnz4X3iORwYmgKXeM8UnAhtXNEbg4qkssMn2xVxXfHRsxL4148nPmlnUGwKyTsP7W4VbwgkaaDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178034; c=relaxed/simple;
	bh=Tj2kzQUseOSg+oWCGQV1rCtpnb3xgLSYw3wXSkQNtr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K408+9RREtYxtYz/FaGeGc9f2lMGBY3BXgAlymVgrXi7I50QRhSRjJ9GMpD6cM7m0FDTXaY1m+a9FUOUjxZUzYHyDqSIwMOeN5jyyq0P7CUT9mR5H2A14SFpI6kLJ7SHggywSLnx+XkUqqZCOm/gOzqYZTROyDcdQ+sQjWfYCr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8YqavAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8YqavAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BBC4CED2;
	Mon,  6 Jan 2025 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178033;
	bh=Tj2kzQUseOSg+oWCGQV1rCtpnb3xgLSYw3wXSkQNtr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8YqavAaAwNuevKoOYXdD1SNfY6INx/G1TumQt+Mm3dPxNSRoMXKt1upvVv5iSmyo
	 E3Tak4PSxsaaY7qshe9r89D4e1Orwtir4W1Iv959buc7iR1RTGYmUmhdmnNFeAgH8j
	 Jr414UqhYUF/w9+0nqvZWNm44qKvNMQwBD/Qqzhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 139/156] mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
Date: Mon,  6 Jan 2025 16:17:05 +0100
Message-ID: <20250106151146.966148375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: SeongJae Park <sj@kernel.org>

commit 8debfc5b1aa569d3d2ac836af2553da037611c61 upstream.

Patch series "mm/damon/core: fix memory leaks and ignored inputs from
damon_commit_ctx()".

Due to two bugs in damon_commit_targets() and damon_commit_schemes(),
which are called from damon_commit_ctx(), some user inputs can be ignored,
and some mmeory objects can be leaked.  Fix those.

Note that only DAMON sysfs interface users are affected.  Other DAMON core
API user modules that more focused more on simple and dedicated production
usages, including DAMON_RECLAIM and DAMON_LRU_SORT are not using the buggy
function in the way, so not affected.


This patch (of 2):

When new DAMON targets are added via damon_commit_targets(), the newly
created targets are not deallocated when updating the internal data
(damon_commit_target()) is failed.  Worse yet, even if the setup is
successfully done, the new target is not linked to the context.  Hence,
the new targets are always leaked regardless of the internal data setup
failure.  Fix the leaks.

Link: https://lkml.kernel.org/r/20241222231222.85060-2-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -966,8 +966,11 @@ static int damon_commit_targets(
 			return -ENOMEM;
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src));
-		if (err)
+		if (err) {
+			damon_destroy_target(new_target);
 			return err;
+		}
+		damon_add_target(dst, new_target);
 	}
 	return 0;
 }


