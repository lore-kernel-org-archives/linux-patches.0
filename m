Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407E0343D63;
	Tue, 26 Aug 2025 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217630; cv=none; b=C7p2ysh+ezK7Yn7zma7cZzHxE3JekGSMj051K2x5eF/+2hM8KE15+tUSDt5q2knEZe7YnFrEDXzdanYRMTa93G6nqqCdZsDme4xaDBo+hvTn/vvdUe90MOkXVnETvu/MRpCp4POe39HsOCJgA5c0JX4STieZwWnGcP4OoWqhRLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217630; c=relaxed/simple;
	bh=XnaBzZC0pGIJ8zoOAjZssTabaJJ1TO7qveUcuhSzROM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFKVZvXiuyK1Sq2f5KOkWCMkKkLWqBg1wiHousiURlI/Thm1WwjsXwrW5AqIwzN6nh3d5/V+2YPQ1ZpCQrQpqVIY05ENO3/q+e1tp9bXEuPYtZWnRsPotekZAonY4w8uFtQ7GtYZ2EmyZA7h1NlgctrH4RwQqrYlxKEtdbMYw+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAMPsjQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAMPsjQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8285C4CEF1;
	Tue, 26 Aug 2025 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217630;
	bh=XnaBzZC0pGIJ8zoOAjZssTabaJJ1TO7qveUcuhSzROM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAMPsjQLEV21pCx6Qjj8/d1ZL0uOog9mOCrr8J1FduG6VVZ1uviEj4bkxHMnwihq8
	 A/L0+qSXTswgj8F2xRxJ7JfdM06DdK363AW+o5fStLot9TYBA3nKGgpGXJgn2qEOo4
	 Lh3nfesa4neDj0tbvv9qR01tIF5wQiTQWyNCiwz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarah Newman <srn@prgmr.com>,
	Lars Ellenberg <lars@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/523] drbd: add missing kref_get in handle_write_conflicts
Date: Tue, 26 Aug 2025 13:07:06 +0200
Message-ID: <20250826110929.791052651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Newman <srn@prgmr.com>

[ Upstream commit 00c9c9628b49e368d140cfa61d7df9b8922ec2a8 ]

With `two-primaries` enabled, DRBD tries to detect "concurrent" writes
and handle write conflicts, so that even if you write to the same sector
simultaneously on both nodes, they end up with the identical data once
the writes are completed.

In handling "superseeded" writes, we forgot a kref_get,
resulting in a premature drbd_destroy_device and use after free,
and further to kernel crashes with symptoms.

Relevance: No one should use DRBD as a random data generator, and apparently
all users of "two-primaries" handle concurrent writes correctly on layer up.
That is cluster file systems use some distributed lock manager,
and live migration in virtualization environments stops writes on one node
before starting writes on the other node.

Which means that other than for "test cases",
this code path is never taken in real life.

FYI, in DRBD 9, things are handled differently nowadays.  We still detect
"write conflicts", but no longer try to be smart about them.
We decided to disconnect hard instead: upper layers must not submit concurrent
writes. If they do, that's their fault.

Signed-off-by: Sarah Newman <srn@prgmr.com>
Signed-off-by: Lars Ellenberg <lars@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20250627095728.800688-1-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 405e09575f08..b4d4e4a41b08 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2532,7 +2532,11 @@ static int handle_write_conflicts(struct drbd_device *device,
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
-			queue_work(connection->ack_sender, &peer_req->peer_device->send_acks_work);
+			/* put is in drbd_send_acks_wf() */
+			kref_get(&device->kref);
+			if (!queue_work(connection->ack_sender,
+					&peer_req->peer_device->send_acks_work))
+				kref_put(&device->kref, drbd_destroy_device);
 
 			err = -ENOENT;
 			goto out;
-- 
2.39.5



