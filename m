Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3351078F;
	Mon, 27 May 2024 19:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836773; cv=none; b=rlcfXoXsJXLB4sqtMFgMiS+PBISIC3R37tYkUUUyiOQSnY4w5Ng9zrkJGbZ3MZtL+c4Zr652sXCAy3+hKqmrDfQFvNTEas4J8crTBPmzVJ2gdTBcIvvsu9gcftGKUQYf/8oQfEzMaZiBYTDoQTj940s4v5dSsO0nILL9b/VPypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836773; c=relaxed/simple;
	bh=NHZes0rPmigSIBe5v7+Zo633IZaZGHNRTmQq/t3l8+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llr92r4/DrU/SsdmNxdBQs5rLGmSwdHZasWmpNgYIql31o+Pf33rspCLzz00cbDgUC0nG9cX+sXnG/UI1wuoJ9gdyiy0mLMh4LF0ie7DEYhVezdmu20/qbiRgp0UJV15jopkiS10imVcjEOsSo3RzKoIUyBRh3xvaZsbjGCW0yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKJRDqdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKJRDqdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02377C2BBFC;
	Mon, 27 May 2024 19:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836773;
	bh=NHZes0rPmigSIBe5v7+Zo633IZaZGHNRTmQq/t3l8+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKJRDqdYoQ1uqvdGLrp3DMM5vOb2OnWOu552IrWWS3tavYjY2W7Jhs68WzBRw2R78
	 VGgx94gm+jtBASMQOfCna+BnHp+WDOqnwgMRfT37GWDpKxTSA7zirNsFYQqXnt+z/c
	 M3Zr95212DheKpCQIul29rxKedJApr6p/fWZ0Stc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 140/427] gfs2: Dont forget to complete delayed withdraw
Date: Mon, 27 May 2024 20:53:07 +0200
Message-ID: <20240527185614.941757017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



