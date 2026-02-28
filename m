Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A422737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302306; cv=none; b=rADFnnPLUSeztkYFGtUO26vXJFNisrG9sLI886CVayjhGmeWlfGgMQV9x9fhAEfP8tNxgJpF9kqIWDKzeW9Y/4RzHzSXBAcw/86nCxK05Fjj8opkKI9vrRAEd8QhNpOso74/lScpCAvdoawVu8QV+gp7FuvFnNUJeeQa7ourbjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302306; c=relaxed/simple;
	bh=PgPlUT3kmH/CP/Upfcoc+vQNakq4OTVImBb7qE1tsAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAMdvGdgLLEk5zY64dFmtW6wA/7AKTnNQmqVZON3j23ctUzc+/a2txhq1QW7roB3e13I3aIWMycQNQpHZXTEhvzflmHA9HpMBOFJ8n+/mbNrJX5T6zzWb0+3TqPM+PMsPycI5CHUNKxqTJ5BesCW8xxM6mukFuOQCGHlV0Mb3Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkGofw6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkGofw6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAC3C116D0;
	Sat, 28 Feb 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302306;
	bh=PgPlUT3kmH/CP/Upfcoc+vQNakq4OTVImBb7qE1tsAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkGofw6pIsui0embQ2ZPthO5RuaDe+K4BOOyubGv9bkphogOZBtCRBus8cLmdn8b6
	 Tg2TblpdT9rvvugIcRUSB8J2wrcglsv8xbuuQ6fk1ejlTyfplf+IJFW26pc1D3bLN7
	 NSsUZ/wn5KBndjDU0eH9nOLWvnISbxjme7wzLFYP2tFmab+sW/HZGIaCeR4YZ+I5St
	 v7uDRSPIhWHoMDAYeZT910k58IbCorV+eMf5232IpiZ1aZBz8vK4KG4FFyTpJb6Wpq
	 EUjdtIMBztubtKf6fF9aMF3R8dAgEvq2uglnIPhpYBnh2ZlxBx1AGDF4pGHJDk+JJC
	 rfjks/Hrxi7KA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/232] io_uring/sync: validate passed in offset
Date: Sat, 28 Feb 2026 13:07:54 -0500
Message-ID: <20260228181127.1592657-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 649dd18f559891bdafc5532d737c7dfb56060a6d ]

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sync.c b/io_uring/sync.c
index 64e87ea2b8fbb..59f951a4b5241 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -61,6 +61,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	return 0;
 }
-- 
2.51.0

