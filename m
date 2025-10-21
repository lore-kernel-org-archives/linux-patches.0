Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C01274FDF;
	Tue, 21 Oct 2025 20:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076808; cv=none; b=ruL87u8aaz9yJMqSUMBzh3idkM5iPJRnSRY5wdiJfXNhHNngqyw44qSFsNPBSysPRd93CrqenYdupO+0QKZsD8/mHBpRDiCzDu644IONMCNYocflavIDW85Zd3NnaqFUACSrE5RsgVFyshMVixMbLIGW1+P1V+Sohva1jaqE0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076808; c=relaxed/simple;
	bh=VBqGgWzHcwvvi+gl99MtaLLE0EHb+p0wPER/PwAd3kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ9dYW0YTYqwycDjQOA1HkV9AaSy+tE7f79Gh+IVGVYXZAc7AXDc678v51bfvBR7/4LJxtu9szzJYa1EIGKAqMBM670naM+1QF2jOM2+IPkSGSkqCwkXZRmdSxCaKXT4ugttM9RbzQp2BONcu9QvQQPcbjBtqQ+/h5hq628dYLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDNNQEtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDNNQEtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25192C4CEF1;
	Tue, 21 Oct 2025 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076808;
	bh=VBqGgWzHcwvvi+gl99MtaLLE0EHb+p0wPER/PwAd3kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDNNQEtMZ7no3EBcOLJ0V+8MPew1usOswm186ujBRhhDsWWylzSl0VaNKv/XSoL1O
	 Rok+iOBgveY3N0pBd+1nOojmbrQDSqRMAde16sHacm9mpTR1wzVi+nQQ4lbaL4vIKS
	 T+AYnnbl/aQmXG8YwZQmP+UMKlyiXFhJiXF7s/xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Kevin Lumik <kevin@xf.ee>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 042/136] Revert "io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()"
Date: Tue, 21 Oct 2025 21:50:30 +0200
Message-ID: <20251021195036.995832476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 927069c4ac2cd1a37efa468596fb5b8f86db9df0 upstream.

This reverts commit 90bfb28d5fa8127a113a140c9791ea0b40ab156a.

Kevin reports that this commit causes an issue for him with LVM
snapshots, most likely because of turning off NOWAIT support while a
snapshot is being created. This makes -EOPNOTSUPP bubble back through
the completion handler, where io_uring read/write handling should just
retry it.

Reinstate the previous check removed by the referenced commit.

Cc: stable@vger.kernel.org
Fixes: 90bfb28d5fa8 ("io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()")
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Kevin Lumik <kevin@xf.ee>
Link: https://lore.kernel.org/io-uring/cceb723c-051b-4de2-9a4c-4aa82e1619ee@kernel.dk/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -477,7 +477,7 @@ static void io_req_io_end(struct io_kioc
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		if ((res == -EOPNOTSUPP || res == -EAGAIN) && io_rw_should_reissue(req)) {
 			/*
 			 * Reissue will start accounting again, finish the
 			 * current cycle.


