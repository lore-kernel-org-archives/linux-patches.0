Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064354;
	b=5TbsgLZMpD97l9cxjYrXGiVV28d0iDhneQVQ5aByiwu75GYfKcPRj4Nzrp/P4+p86bZR
	 jSo0Wq9BSq2u3I+IYWfj9U7RqyZoya4G6xpmcJBnoAD8SA8xqPzVg0+I4ennhnCxS7rLc
	 25B7mMt/PxwIOsII341hZwOS92HKSEYCpCr0HWiSUFgLKch9JvqD5rOiGRsCfnp+0SeUo
	 mj4ImDsTCFWP4cdM0NUMLukEg1cK3rFsqBE/eif85QvvyeeVvl50kOdyER0mXBSV20NMU
	 EkQ6XplM9pXSRFc8K7T371k7MBTPOnPcWcTqgbjRGxDg5SNPkABm15PDcKXVPv5zBHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1X82OzuT3FO+TT8HzffAAKgq4yglPuSLJVjHB6waE4=;
	b=HW3WvkuqFaflsaxXwwUzARV7eJA0UJsOpSImnRr3qh2jLwV3MFDlHZjA70sO/sICI8eb
	 8LLOF2jPoAz10U6L5xNJ8oQ1Ac8tOGpUxRUTutFDC7vX87ilWZLHL5Xut0sE/6Onj+aRV
	 KEVC2c8/CZ5yo08sRGl2VuoiyJ99pnXUDH3kGp0mwtNAPi7ChaQA1EVhgpPM9viafbIU3
	 L9Y5oFwn1hqyqTBT3XD85Zqxe/uv3EKJC7sylDiJ5SLWtVxi6pueIEFl51QmjwIpWilkT
	 iLp+/TEfqjSQ1DMaYiqnT+bCI7qUqGDOa5MuyMDVOxa25k8whCDoZxdqPhqBy2U4W3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5lLQZ3m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C01606B88D;
	Sat,  7 Nov 2026 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5lLQZ3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526991F008A1;
	Sat,  7 Nov 2026 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064354;
	bh=B1X82OzuT3FO+TT8HzffAAKgq4yglPuSLJVjHB6waE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5lLQZ3m4HuKp3zfXHPrnM2mG6jyKl+C2g6udfh1NgBfdjh9SfVUQsnyqIAjEW7GQ
	 gaqJQ6QXRG7mDaMrb53Q5KwpL0XNif509PQptTrZq8i+O4dmsWVwU5wEaaGgLDI7Pr
	 wufGoTMkxbDmDCbAYgqWPGpkleIuDUjmHYxItUxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0420/1257] dm-writecache: fix uncommitted_blocks underflow
Date: Sat,  7 Nov 2026 08:45:16 -0500
Message-ID: <20261107134951.101492279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 6ec3e20553174..302ebed4e6ceb 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -899,8 +899,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



