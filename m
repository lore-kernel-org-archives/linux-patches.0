Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7C1A2FC7;
	Thu,  6 Jun 2024 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683221; cv=none; b=E+gaCA1fN9c0PbfQrFUa5olrdbNqNKdRMQq5ZhVYQNnq7EPahuATN/zB5URY+yyiYJ9rA2uKzPt0M2V3LRei6pVF88hbeIeyi53Pnai3WUwF4KiUzH7l0Cli31sHTfGyTMbEIWvqhimztr10ErERkOtcHXYHjCDIrnhtUQsYCek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683221; c=relaxed/simple;
	bh=rb3EhEwDoY2hLNwaQCV3tRxWPFbtfOL8x+ICuiX9QzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeLUy/Ll1/UQDkIKyCgvS7EwZj9w+rQFVhQMWzkqfx5b9S4abwwjD7M8MmkfddvVPoFkBAdYPt6sfa+ZXhxKbvIXUTI3NjMid8v25C7FoC4UPllSGNev2ymyUp44UMaZ0154CSZ8WW6xXhegNPz9mz1yLuiq/8WSln2t0FbkOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNs1Z2KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNs1Z2KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1E2C32782;
	Thu,  6 Jun 2024 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683221;
	bh=rb3EhEwDoY2hLNwaQCV3tRxWPFbtfOL8x+ICuiX9QzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNs1Z2KEEVORoR7fKBp3R6VOD25r2ukdkUOBrIz4IATX8EdeYZgsB7WCs1xu64FyD
	 boXFW+9AKdUFO/VwfGO2sDUdzC5b4N8nPnpmlcQp836tS3X2Ugl1f95T5YxMFNBjIl
	 zlJztd/EQwsB2yjWYy+eqgj10Ij89cUfdGyZnOTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/744] gfs2: Dont forget to complete delayed withdraw
Date: Thu,  6 Jun 2024 15:57:15 +0200
Message-ID: <20240606131737.653316216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f41ca89d216bc..3c6f508383fe2 100644
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



