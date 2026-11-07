Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063669;
	b=D4q5gVf1ZeBg97LQTY7haASQtzLuwGd17toFEDiI8Ys3Zeq4KsBeQE2cIq+u6FcIJAmz
	 twPJHmHvR1GoCOHStoCI4cwFbzP/u6RP3ZMpWilRB/Lhcl0tkrelXaFrEz7v0vRgx9Zkf
	 bmVORQFD4LL9tCaX6C6gxHmDrCqxga8CX8GWkdTfIm9M40/wBy/mHD9WOYZvL4Hg64kvj
	 UQDo4o2Yodf/O7xm/I3esgj4Quj3Uzd7Juq7kzna+P70t1AIdRWiHI6PXcry1vDZW4yC4
	 ++1PViZ/HAU/ekgR8fM9c1Z6DfGTGUed8wQzAEffw38ZqKh2sPWEexSGQorywQJG9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BRaKevM9JyoZs9eKsuMNyV/TBSzQ0YbJzVli9hJLhTM=;
	b=RQ6jXwwrVnfaJHS9TFgKgG4hiTPkmRfNEFI0TKS99EnokKlAfrdye5TGuSgVyYfsLk4M
	 GE8xFSVFiVNL3xOGX1MKJo4O0eIfYuF33o9FA+YULR/msSnIuEq+R/ICas7uZtdiPcxlR
	 tATqzRxnMWc5oWua3jIgdsyOlqjKBh+XrVUM46Axe2CyZ8T+lF+tldAL2f67tIqGlhUMD
	 Yho4I08olJgg/kN5SMvpnOdszf34FwYSxzvtY/sRcHn8qNfhK43q4Qj2cZ1QFwd5xw6qn
	 d7fNIyPTcHCFYDAZei2wesclYiH1gtrVg9K5uqnyQ5r0cKR63amoNhHHm/rADkhfR9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAX0O00k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A62606A9CA;
	Sat,  7 Nov 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAX0O00k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9831F008A1;
	Sat,  7 Nov 2026 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063668;
	bh=BRaKevM9JyoZs9eKsuMNyV/TBSzQ0YbJzVli9hJLhTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAX0O00kBjBtEoByf6pPq77ENe0V6ak2Q8dk0Iwfo2AD3XMwp+L1Q47mulKLsyKGD
	 Os6FpXEapdrvxgiWOjNNFumh0XSg9iIyAcUA/rV+8EQQ1mcJkU7rHAz3EmkqssacOl
	 CwTawwz2ZIqYiJwn2wgcrg4KIVyyuPfW2A21UaH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 781/869] ceph: dont fail write_begin with -EAGAIN after flushing old snapc
Date: Sat,  7 Nov 2026 08:57:43 -0500
Message-ID: <20261107134919.156569908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venky Shankar <vshankar@redhat.com>

[ Upstream commit 6ff7920ca78f6edcabc26c63d20f681d938027c7 ]

When ceph_netfs_check_write_begin() finds the folio dirty in an older
snap context, it drops the folio, waits for that snap context to be
flushed and then returns -EAGAIN so that the write is retried.

However, since commit fac47b43c760 ("netfs: do not unlock and put the
folio twice"), netfs_write_begin() retries only when ->check_write_begin()
returns 0 with *foliop cleared -- every error, -EAGAIN included, is
returned as is. The -EAGAIN thus propagates up to write(2), which fails
with "Resource temporarily unavailable" once the dirty data has been
flushed, rather than being retried.

This is easily hit by buffered writers rewriting dirty pages while
snapshots are being taken, e.g. a kernel build linking vmlinux into a
directory under a snapshot schedule:

  ld: final link failed: Resource temporarily unavailable

Return the wait_event_killable() result as is so that netfs re-gets the
folio and retries on success.

Cc: stable@vger.kernel.org
Fixes: fac47b43c760 ("netfs: do not unlock and put the folio twice")
Link: https://tracker.ceph.com/issues/57656
Signed-off-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f58eba5456e36..fe8b7b4f6e8bf 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1889,7 +1889,12 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 		r = wait_event_killable(ci->i_cap_wq,
 					context_is_writeable_or_written(inode, snapc));
 		ceph_put_snap_context(snapc);
-		return r == 0 ? -EAGAIN : r;
+		/*
+		 * *foliop is cleared, so a return of 0 makes
+		 * netfs_write_begin() grab the folio again and call us again
+		 * to recheck it. Any error (fatal signal) fails the write.
+		 */
+		return r;
 	}
 	return 0;
 }
-- 
2.53.0



