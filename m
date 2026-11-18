Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036957;
	b=ZpCW8pXCSslZ8NeNvUMdHpeknmDXK6e5B01D6+1Py1E5sARJwEQdYsgUNKj5kwQTC7k6
	 ZVrmswQq6R92+s6gvdpkOlgdGJa3SstDaGRAyhyf4zIpx0W8YgcsRb2lvH17mmRMtX2va
	 zwbfHLEK9tGbGdsfvgutfEUp6yavRD6S4svl9xG7uDC7boRbEte3UbQnWOc3L3n2zSO8N
	 v9vZfYyRYpS+KIaRPNM4z85PdA4GVT61ikzGOr+h8DNfgRncUlRmFLwLLBawaeXPety6o
	 KnwJsskFCLAAMxO/iJ7iY3n2OGD97DnRqX6GAQEr8D17o4SwtincMBmeKPK4/2ko7VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VyBWuUgRblUbP2guciS8/u0DkZQJLj20EmuMmbB+GOc=;
	b=azHgI8dpFG5xR/FguuX/CIS7HpAHZvB8jI5dePDxtVPFSas24ulNec2rh1+4fyqw2jU0
	 WPqK329CYi4M2lgmALW1b5Dr7NLmA5nqqLrw3FalvkRGRkAdvoZHjaYSncWY2AfqaMTMH
	 /stDkQ8fg0RBgy+NvyBe0Bpm3X0upM6N/CgkKaE+RpAemFgPTyLK9hFjGklaverfMwy/s
	 v+5N7Dc3CX7foioowtBOeLgNVrS0a1akkcvcIAYb2722xNFk8GWAcFtN56pqsCDrTynA8
	 iZtlDZJzEL2myjJqqrXyFMuMYH8qnGfdEtof9sKxvxVgLm0k0idmB3Y9GbEDROtjJFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0s8N07+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77189606A31C;
	Wed, 18 Nov 2026 21:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0s8N07+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C731F000C4;
	Wed, 18 Nov 2026 21:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036957;
	bh=VyBWuUgRblUbP2guciS8/u0DkZQJLj20EmuMmbB+GOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0s8N07+XV+Sh2lZieAeaDAT/F/kpVVnCn6KtRlKIKlnpmKhLULp8D8tWjnaZizvp
	 aXJiE29QkYJkwqz28VjJ53SgCGmyLgDelkjxlxb8rmqA+oH4WWot06/qZomXCJ/xcp
	 UpgB2WNPERrCpizwtJBqr03ALB3V16OhTfcmh2e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1241/3318] ceph: dont fail write_begin with -EAGAIN after flushing old snapc
Date: Wed, 18 Nov 2026 15:31:03 +0100
Message-ID: <20261118150357.419341745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5773ed323d7a..63eb50f94e6ec 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1498,7 +1498,12 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
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



