Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061426;
	b=GyA2EcJPgQyuH5sVKdSlt0o1b6d6e/4IdK5EtkMENHa6utbOgtZ9gPtB+YylQy8wxAPX
	 7J4QadO1jRZuN9JBkiaThxYE6lvD96lzkKORBwIQGTOeRAD7fZVNhJJE0c2MqKJcP4H+q
	 r9LLCd3NoPgPjspS3RaXb39SIp6KOclulq4nRy9R1NeKQPlhcWyLN3/hF7sFkjXSx6iMG
	 LwKOr90MmZkBQVSjL9FTQEkzRE5xWiKOftjJF9oQtU9KvY6Qyndd3HzJZdvPXLMfBJdhk
	 jjejB6GW7fTx9eEZkRqTe7TIbJaZFNW03ZubOD5bVlZ7tXXUGIznb09z27CVtxo0XfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XrHW86dujCwrM9ufIWFUZdei5wv+YxGb+kQ5SMjXoeA=;
	b=d7UUBGz75YpyIaE1oztBygpV2OW+uR8b0xrsjKkOy65jQ4djOdmOzA0tLQ/pqMLERhoK
	 ewop3HaCacQk0bTwq8VO/iXfT08osSN4nqx8RP6DaZWqqsNZezBGte5oPHlM8lIFxpxx5
	 +1wal+QeYn/HygsnYOJVnxYjx7ttQPhVv3CRFccM07GEPfhf4n+6jKsv+NuKef0X+3y5F
	 9TMQgN0Gl5QmAHMZ803MMZtMs6it4Qc/mTj99s838J+a8cnxE4/U5hVchaolbqXKMNUNC
	 bKmlKjRUcdDJ0DxqsH7EKokHb6l99U7et2lsOYvJreWhu/MDcQ5YD+Gs81AdFo5q4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TzQXOiV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF56606A326;
	Thu, 19 Nov 2026 04:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TzQXOiV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B351F000C4;
	Thu, 19 Nov 2026 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061426;
	bh=XrHW86dujCwrM9ufIWFUZdei5wv+YxGb+kQ5SMjXoeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TzQXOiVsOYglEnGe0McHVnkFRMM+H/GsYwfaSB6Iu3DlOLsA7uyejnjpPqiGBLQw
	 5UEJDuRylaOfZKVcFZETo0Yd+rP8VMvw9+50gHQBLVmBB7sd4B3sqe8OUxPTOttvGF
	 9ECsfZzCBPXak+Z5lcafYcvSOVsodU04HwHm7OX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1546/1848] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118150024.321851658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 9b4df0baa2aa03d22310e59846ca628f7afd4115 ]

xen_blk_drain_io() sets drain before checking inflight.
xen_blkbk_unmap_and_respond_callback() decrements inflight with
atomic_dec_and_test() before checking drain.

The pre-wait condition check was added to avoid missing a completion, but
atomic_set() is unordered. With one I/O in flight, the drain path can set
drain to 1 and read inflight as 1 before the completion decrement. The
completion path then decrements inflight to 0 but can still read drain as
0. It skips complete(), so the drain path waits until the timeout despite
no I/O remaining.

Add a full barrier between setting drain and reading inflight.
atomic_dec_and_test() already provides full ordering on the completion
side.

Fixes: 6927d92091df ("xen/blkback: Fix two races in the handling of barrier requests.")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260730084000.3305702-1-hanguidong02@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/blkback.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 3874233f7194d..42cc6489800f4 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1021,6 +1021,13 @@ static void xen_blk_drain_io(struct xen_blkif_ring *ring)
 	struct xen_blkif *blkif = ring->blkif;
 
 	atomic_set(&blkif->drain, 1);
+	/*
+	 * Publish drain before checking inflight. Otherwise,
+	 * xen_blkbk_unmap_and_respond_callback() can decrement inflight with
+	 * atomic_dec_and_test() and still see drain == 0 after this path saw
+	 * inflight > 0, missing the completion.
+	 */
+	smp_mb();
 	do {
 		if (atomic_read(&ring->inflight) == 0)
 			break;
-- 
2.53.0



