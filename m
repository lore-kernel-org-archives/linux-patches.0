Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6758C35C6A3;
	Tue, 21 Jul 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670212; cv=none; b=Niiqj6ezOP+AgJPQkHh211eqXgCqrEzM9jtjSjurxzPfohYuF6XVP0TqL0CZU2xL3Q3rXHrIWjdoAwBjjlP9GooERThSLEuVTDtkpcyxW6HTkGb9zL6xiqmKxB+3Zo5cixeJ35OBvcb0zNzE+jnELhkjsNHeGKr0alzWsQzVDII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670212; c=relaxed/simple;
	bh=ga1JjHWZqAN9UsyA+9Ww0mzWoyAfy0etJkX/+4rvkI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7pxM6R6INh3FlUWl6q7ACBjN8lPyMU6DSHK4drvkGrQyb3CS4kLYxoB9Ozs1AmkCtCV8b0pC+1V6cXfhL2lcR/WDLsmfVnAKnZWR62Wf5EIa9KJ4ZahXMyxtJyHNocbuZw2AyvrgmRx2jBwTM0Rfq1XRrFqjTSiY5jUDWVNdos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmoLIyNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmoLIyNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6071F000E9;
	Tue, 21 Jul 2026 21:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670211;
	bh=C/E9iJx1QBX2d433L+9xIExH3k1ixIbcrLf4dn/eHfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmoLIyNW2WMDY7H0yRSAa9+cehE/cCq+ldkp9oLp/DeZVjgdzNFNJ3jBZPP+eW56d
	 2F3+l309kzzJ+XxsQs1vzExgOsS1GzdgJXyBn2Vwu44a1LiSH5o38j1aKmZy0+E0fG
	 +a9xFZ0Ep5XqmIZPF9iqZ9eWAptlRFJQG71m2Pac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0848/1067] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:24:09 +0200
Message-ID: <20260721152443.516046420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1917eb2db750ecbdf710f79a8042eaa545a063c7 upstream.

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -678,10 +678,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	} else


