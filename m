Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4D41760;
	Wed, 20 May 2026 16:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295556; cv=none; b=VzpauwgQHWKLUblX3wENcgw+t/UAAnDdKq//2EXhuqaHwDEQSnveB6Ja6ciED9Uw0qh853l69DWxu1evTGclSqDvnih6Uo/ysnZLFoFm6P0J8XgVA634bA7Zu6lJTtXbADQHA73e+HVAYy/f252KNkh2muD8a+5W55smemR1bFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295556; c=relaxed/simple;
	bh=fCUYtFL009urvY6Tx+ykSZ/N1FWG05dmQizjvd2V87o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXbwPGtOMmkUekFBv1tLcxZt20rT5FvbcyG4CRJl6FYSV0UkGj2clMyvcFgcxabYUQwXGWXaYVEaOJ0w9ogeqgZKy/1iydwq/mgwn6Aq9Ih6+4o9xts10vC3jzR2LgiNzYsa59k2xlsGl2WFLWK7y39lnY8i4ForExkFswhHA/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGgp5K+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGgp5K+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2371F000E9;
	Wed, 20 May 2026 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295555;
	bh=UOtmQ5SiVNOsFnI3f/vWDB+ZY5pXRnohA1jqlfvyTXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGgp5K+g/UOnmHot0wF4J8X99qaDNkuJKjsVDuNYMnNCPQYuoVmchEah8aF+lgfC2
	 45CnBL9XoXB5SOGlu4gNztDiAJehfHYolrgi4gZPcEzckFaucIXOTiIihRkEqFPfBd
	 +wcCjqjjJVmh9RNiU6Fj+8dGY3Up6SLfDz67hRHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0463/1146] gfs2: prevent NULL pointer dereference during unmount
Date: Wed, 20 May 2026 18:11:53 +0200
Message-ID: <20260520162158.674652669@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 41a70fbee82f4..c483d3c7be698 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -467,8 +467,9 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
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



