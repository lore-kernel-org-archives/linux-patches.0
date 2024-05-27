Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BC6168C4;
	Mon, 27 May 2024 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837955; cv=none; b=kjfwjzSMJ68CUnP9QkqagH8xfyu4ybtJHay/0ztOmhbjkLM4tJjtHCuCbgJAILhoi1qBziiMc6dz7Fqe8EuIGUpWeL4jLt5TPnB5Bzi2c0foWLKK78hWxNyKIRTV5dIh/nPO/j0dr5HtmP4v+0ZRX9C/VuEM/yZ6VSO/98WHuL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837955; c=relaxed/simple;
	bh=HDTNVRzN0WNh7zXeX6oyjD9PFX9xbe+OH9femdQtOE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVh37xvgJD7GTtx+C09oa++rbeM4lg2jtvu0ptkjCStEleKYsUDgM+oqyP/EnR6SUYTPS7xN8CRJU+/y4eaO7QpyDvDEmk2ycIa9WVbWx4DozwL+bFed3YWnaheDWm5rbdErfXyP+j71wZP+CM88fMTGoTGee07rfFYp4tSV4y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R40OdWnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R40OdWnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAB3C2BBFC;
	Mon, 27 May 2024 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837955;
	bh=HDTNVRzN0WNh7zXeX6oyjD9PFX9xbe+OH9femdQtOE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R40OdWnF9Kw4PcHiMQoBlSOd+TkkV6j1Y6OmRmgVccAQAZn6Tq1Kx5S0aYL7XgStp
	 GDs5va8ZgykBmgOz2q/MB0QkQTGm+MRxl6Q4GHw4TZYraUxlBqaWYUARyytxJvanEG
	 lPSbzOxu7/XbRvwa5cQjnijmKHmZj7h2GllkXLP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 209/493] gfs2: Dont forget to complete delayed withdraw
Date: Mon, 27 May 2024 20:53:31 +0200
Message-ID: <20240527185637.157914029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit b01189333ee91c1ae6cd96dfd1e3a3c2e69202f0 ]

Commit fffe9bee14b0 ("gfs2: Delay withdraw from atomic context")
switched from gfs2_withdraw() to gfs2_withdraw_delayed() in
gfs2_ail_error(), but failed to then check if a delayed withdraw had
occurred.  Fix that by adding the missing check in __gfs2_ail_flush(),
where the spin locks are already dropped and a withdraw is possible.

Fixes: fffe9bee14b0 ("gfs2: Delay withdraw from atomic context")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 45653cbc8a87d..e0e8dfeee777d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -82,6 +82,9 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync,
 	GLOCK_BUG_ON(gl, !fsync && atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
+
+	if (gfs2_withdrawing(sdp))
+		gfs2_withdraw(sdp);
 }
 
 
-- 
2.43.0



