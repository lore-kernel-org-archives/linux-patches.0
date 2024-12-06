Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2663A53A7;
	Fri,  6 Dec 2024 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497600; cv=none; b=DUo+xlmo5MdcGSXRIopMmQgZLJKO2nKx4vTdHsmZm7sD5xympCVOanjLPqfoW9mmHNSBtVavL08KeSxadKJN7iGtMd97HgKzfMtnZ5u2Fj4hWciuKQh0r9mkKsNb1Jy0JaO+oGbXUyl0pnVP77ju//7nOfyWoPoFveW2xnsYOnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497600; c=relaxed/simple;
	bh=4+zLLJXekgdtbGagksPk90AGRpTehw1w4Ku2/Tsmjw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN5+Bah3WGMapgt0dO8Jcowmsheiw3uyorLXRSh5uQDKN9Wa79flIBMdjDY5un/N/6yE9AV2a8mslH4vjj1IpSKR7DV4N/o8WXKXPdwEVPSHmTyVEVGK6VmQYrNpOiNeuBUAytslmgo+sBZ4TY+EdwIqDEand7A5doRGgj+r4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNOv5aJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNOv5aJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9199AC4CED1;
	Fri,  6 Dec 2024 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497600;
	bh=4+zLLJXekgdtbGagksPk90AGRpTehw1w4Ku2/Tsmjw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNOv5aJCoDFbNru9FP0WKoxsGGNu+nZg96rGCmri/yJwpMK4+m4WZHDRWv9G3sCOc
	 cNLRNsG9eKzZkvsvqBapaM52swJAfWTyagaJgJbGEAHFOfado9zX7c+pZONwNrzkal
	 FAXEM+UunKhtbNEGPo607RcUFV8YMs3LTMLrEfas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/676] gfs2: Get rid of gfs2_glock_queue_put in signal_our_withdraw
Date: Fri,  6 Dec 2024 15:32:35 +0100
Message-ID: <20241206143706.470751663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

[ Upstream commit f80d882edcf242d0256d9e51b09d5fb7a3a0d3b4 ]

In function signal_our_withdraw(), we are calling gfs2_glock_queue_put()
in a context in which we are actually allowed to sleep, so replace that
with a simple call to gfs2_glock_put().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 7c6f714d8847 ("gfs2: Fix unlinked inode cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index b65261e0cae3a..268ff47b03963 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -255,7 +255,7 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 		gfs2_glock_nq(&sdp->sd_live_gh);
 	}
 
-	gfs2_glock_queue_put(live_gl); /* drop extra reference we acquired */
+	gfs2_glock_put(live_gl); /* drop extra reference we acquired */
 	clear_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags);
 
 	/*
-- 
2.43.0



