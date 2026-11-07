Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062589;
	b=AKYB3vi4LLVDQX2IP4qrueXF2h8pI04IbYnrvhV+vWqtQkMY5X/wwohnwoiuTsD3+ZCg
	 CvonyhjB+QsI96Zy/RbeXHPqg19hrK1KPCK+UbSI1s4mM2Gl0s310x/4aAwDt409II3Mz
	 dM4/BmlGeCPMa89+Aj+TSUHACOSNHOr3RNv99I349le5PJLYL2On5h/EZQI48dLokrnkX
	 NPNeHd8lvhAoTD0L1vlzDaCRpn/L792M5AERwsmxSZjn06MRaJnnp4oKL7Et/Ul54ACg8
	 aKa+sWon/FDZUaz5j9mh4TF1FPALy9S7VlpvoPxqoHoiurtLTQR18PmOyj1Ft7tByFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oSZch4UxmJU/bkA9i+8lrqSMQOkZ7s+GAuKdRUeJLdc=;
	b=bFJQC48BaygR3iYLaUVbO8phTtlaG6S8PPUs07AN49OjfX+OYl0EQGHm7FraQyawUiUZ
	 0YDT2vnvNObfcHzvU7nUiLVh+koncdhUZrzp/xqKKgEU4Z3vtRLXIYDPzr/3xLUwpFkdI
	 UarDy29z2iwujezvNq6PO31I8dRDXiSDelO8QOhGAsu+47I2UgLNMRo6pARhnV1ju2esR
	 n4/PGopliBONa8PXuqOMh7jP83I+eDsfGEbtuMNxZBfObKxTRpBXj1/serJNpsTZqIPVC
	 iKlmUZt+YONQplr0oDPitdlrX7yhT6APL7pbON4VnJlYd8586WlgKW4apVCfrlE5+sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAwZaIl7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88198606A326;
	Sat,  7 Nov 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAwZaIl7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351431F008A1;
	Sat,  7 Nov 2026 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062589;
	bh=oSZch4UxmJU/bkA9i+8lrqSMQOkZ7s+GAuKdRUeJLdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAwZaIl7A6yDg4RfmlNlE0662q11bXRpuxRD9AVqrdyeWohXXilGMHmlvNC2TCClf
	 7nlEajBoPz1sQpqF+twwZz08IMbUzq6Sj90GM8PKdHgeaxZIUcGVLwNOXE4mdr/yz+
	 xkX62ApfOzI/b7JCH6Q0wdq3mm+5mwePnni4tO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1468/1536] ceph: dont fail write_begin with -EAGAIN after flushing old snapc
Date: Sat,  7 Nov 2026 08:58:04 -0500
Message-ID: <20261107135039.075510898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9eda19ae3c5b..611019005f147 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1852,7 +1852,12 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
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



