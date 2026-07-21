Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2804238910F;
	Tue, 21 Jul 2026 18:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658990; cv=none; b=iPzxnd82S8StIL1HyWle++CeIH+dEvebr1Y1ap9so7J8FaJItUFMtG5X7JVYG3k8u4KRSNaXudywn3UrORrlZlbf6cEo3+wyVzh6lXePCdPGiWn4cEltxX29Z64FZJk/DK11/oWNQOFbzmnrKKLNP8zT+6y7xAR8qlF0fznoIRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658990; c=relaxed/simple;
	bh=VSRN4WE11OikmHxgRykqAXnyxIAMSxf8kgvVCdFBJ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuy0DPOEIxS5M+Ep/9ICBVIWDf7MXgSoRdN4c6SoKwR0MOeaxIrz9t2P6O1T5yAxnTq02IHtbbPgdVuqTtiDv7csgYgua4rFOugrv/h1X1bEdthkYA7dgAwo8TOVIiZ/qU84YddIvpnsHVFU437L+G44eo4sSmFyiJ3xtkgj2FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fp3XmP7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fp3XmP7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEF01F000E9;
	Tue, 21 Jul 2026 18:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658989;
	bh=C9YK4Jb2tUQ3OLPrf+UUJ0YLPBXlYz+/zDlLFFxu0S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fp3XmP7jn7ZAi2vQ309Z5vwiS0qs6aQnZNtTJY5VvJz8iU+zj6UQKZfHbLXncM0Nh
	 3DQGGzZTviJ22wMTk0uQjKX2917n+wPt6ccsfEvNkWcF/udXufuPpsRLJ82HLZSN3n
	 KOmIj1BTrD5uSS+/R1KOWvkSJzxpK7Gcbw/7KTNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1353/1611] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:24:29 +0200
Message-ID: <20260721152545.888221180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -692,10 +692,8 @@ void dm_stats_account_io(struct dm_stats
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


