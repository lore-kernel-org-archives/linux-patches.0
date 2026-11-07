Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065414;
	b=MfGcMC5tQrg7gDwDuqDhShy13V3kJ35hOVAzb9UpgL59l/Fp9izwRAQgAfEYmXFSb39o
	 XJlv9fTqOOrrgCOCK8W6L/Dle1zrlx1DMwnoQIr+b65BWqGUzCtDR6fdp74mik4gu+XEK
	 b2YsO/i5QJkOCjrJ5onn5OcyfmFCpPCdC2dsegE6vTs0szFyytullnm+8mtN4Yb4czCGO
	 ScydXZgB/bY4i7lzs/oSYmMDvpWFAGQxIga8iBsh1ObuF7qiGDTcMcoeHn0bnLUEg/ECa
	 Xhf3unuLXnDqfrOc1+TG5L8aJ5vtVnPOdJ0IPBBHGkKZJ/edheF3wA4xK2DUDQuEq6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=heJ+AUgHmsRJtroxDv7a4Fpkw4prM/hKKHtj3dUq0O8=;
	b=MXRJEeH10WHz9uggUv2LjgH8dY8kYN/wP2E9reP8oG/+n3YPlKSyjIvvNZZqLZ76V26H
	 4fOE+YqxzfB6SK0KegJxPh39cFxOOkuDKgKXIP//0+1AeeV+7zI3AvBEMa2BbY6grkNWl
	 jNc5RcvocS/fpmve2dnye8Tsj4X+U/pEcc55hdpbP/40/Acfssc3CWrH4dpD7Wg+ylrzl
	 PYXJoAE89U3G9hLKivALckX9DnAcdTMs3FjSvGu1tV2KnDVX7LBfr8a9hWtSyBtgIzjTa
	 BgIG4E3/gos1UkMz+o4YCQgU4Wb5Nqi5wSu5KsUkGlK1OO939UIqvNIKzty/OJbdI/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQAd0h33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39324606D80F;
	Sat,  7 Nov 2026 15:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQAd0h33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D961F008A2;
	Sat,  7 Nov 2026 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065414;
	bh=heJ+AUgHmsRJtroxDv7a4Fpkw4prM/hKKHtj3dUq0O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQAd0h33riL/NqYgOGOQNEl5uKfvvuwGNZSOtNvidAepmZbVWyajo6JhUKq4IQesl
	 8uIzDNpifLAmGyPr7ZYsFJOGnnMvGWmmF09ua26NDdmeoxSMqvuU1ZV5rXmVWMQLK2
	 XDIDNwQXO9gbhiunzcOqPsqYK1+xF+bGfHK9nZQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1131/1257] ceph: dont fail write_begin with -EAGAIN after flushing old snapc
Date: Sat,  7 Nov 2026 08:57:07 -0500
Message-ID: <20261107135010.468150985@linuxfoundation.org>
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
index 286eff8849dfd..ec14a5606886f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1895,7 +1895,12 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
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



