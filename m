Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71E0195;
	Thu, 13 Jun 2024 12:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281827; cv=none; b=SYrck9tJu4oSe+TpgegGcQAanP+W+iRONTelYARP39pF2a2eR4H/S812dVTlZt4Y084jwF4+tIbN3mwjy73QuF8gnnnePogdPjzylKlqibzWHRB3UecLNzJDhBK0f5+1UV5GOglfutHomzllPnI3Ef9KgXUMLI6r+kDmfvvMHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281827; c=relaxed/simple;
	bh=4DqX1kTAaCnaikL0DMXJB5PjeBcR/SiSUdcmydNPxmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVivorqtwXrY6hUKj9JSBFb0kAJStLz+biBS4bw859f9CKAb2jNM96R9+/UYOGkFHD3YCvx6zcnZkZDyPpmCHQHc51zAKwgY0LT8HszJ6oKKIpcxh7e7Bbj63sfPWIXe8MwQCgx9Hfr0OMuEIzU+5C2MRK7q+qPvAPTmS/CCheE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/FEPvk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/FEPvk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D76C2BBFC;
	Thu, 13 Jun 2024 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281827;
	bh=4DqX1kTAaCnaikL0DMXJB5PjeBcR/SiSUdcmydNPxmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/FEPvk2L7cTyvnh6RsY9KM6ejWTKeGQ7plHOx1S74fjI1bGV5qQRYYsD3sQv1arC
	 LUPggN0Chf+TNukJCW3t+1s3sohE7YjcJ2UT/BsNGAZs8IturIYwuMh2k8Dy3CC68p
	 Sd3eV4uvRmBbKViGYF/Rx7lFSvUKKwEoakuflobw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/402] gfs2: Dont forget to complete delayed withdraw
Date: Thu, 13 Jun 2024 13:30:26 +0200
Message-ID: <20240613113304.829221530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 558932ad89d5d..5a4b3550d833f 100644
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



