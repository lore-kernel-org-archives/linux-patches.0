Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560E5DF59;
	Wed, 20 May 2026 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302202; cv=none; b=J8dPL9Q+tnQBipLCja0OPKeDoflDWjPK3SzdT6SCNYnJmrgzKyHNaGDIq47HI8cfdtBVAyTBWizGFoUHYl9KJ7nmIontptvlGz3C1AvFzUte5yQedo+XMIrH+VURW+hWSs+mgDCJ2VMDMDMBbmnxPajTu9GzLvMQ0SZvDo6OXps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302202; c=relaxed/simple;
	bh=MjMsE5R8M/3G6KRMe9soM2FWPWnxeizl7Igym5u1uO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnpwD2BaxIjDixI9ILnnoiuTIKPQGRp3Am7hj5glkEWukA9TtEwSadf+IdPdB2PFMXQSGYkCjVbBhTe0X2sMDIAR5zkG/QMMl1ViZHwZb4PHUlx+haLqEymP2PC/YIQrxfrEGeUx5nP+XbPYh93+mz10a44QxbBtuerNjssoq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHW5i2re; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHW5i2re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3961F000E9;
	Wed, 20 May 2026 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302201;
	bh=wsctpJjTR6DVKtXGXq2CzqNBhGGdq9fjZZyaGwIrJa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHW5i2reVipkf4CkXo21VcY+gqqV5GUIwLgidZz6E+pco7sL9017rz6jd44W6Ja77
	 vvzhqRkh4dIUye07NG4tm1NwRkKtiL9rMQVsmRYD5zS6w5Y3jFD841oQRXDvT8uDfN
	 vmY3sdhdJEaTAyXapLRI75OYGMrGu63R+tpr96Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/508] gfs2: prevent NULL pointer dereference during unmount
Date: Wed, 20 May 2026 18:20:01 +0200
Message-ID: <20260520162102.495745561@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 74b4dbb946060a3233604d91859a9abd3708141d ]

When flushing out outstanding glock work during an unmount, gfs2_log_flush()
can be called when sdp->sd_jdesc has already been deallocated and sdp->sd_jdesc
is NULL.  Commit 35264909e9d1 ("gfs2: Fix NULL pointer dereference in
gfs2_log_flush") added a check for that to gfs2_log_flush() itself, but it
missed the sdp->sd_jdesc dereference in gfs2_log_release().  Fix that.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202604071139.HNJiCaAi-lkp@intel.com/
Fixes: 35264909e9d1 ("gfs2: Fix NULL pointer dereference in gfs2_log_flush")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 01fa92ac9ab20..b8be6c1c942d4 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -478,8 +478,9 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 {
 	atomic_add(blks, &sdp->sd_log_blks_free);
 	trace_gfs2_log_blocks(sdp, blks);
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
-				  sdp->sd_jdesc->jd_blocks);
+	gfs2_assert_withdraw(sdp, !sdp->sd_jdesc ||
+			atomic_read(&sdp->sd_log_blks_free) <=
+			sdp->sd_jdesc->jd_blocks);
 	if (atomic_read(&sdp->sd_log_blks_needed))
 		wake_up(&sdp->sd_log_waitq);
 }
-- 
2.53.0



