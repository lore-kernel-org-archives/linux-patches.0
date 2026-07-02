Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950633C19E;
	Thu,  2 Jul 2026 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009347; cv=none; b=EUFgh+DFZ9vmhafWeYCMH1mDiR3sPCHqKm9Pa1PqEXb77/ZrjLo75p9sENXenmxKulTXCR2/Y3Izr/Apns2TM1Xvrx0eWUNcOUvXArg9R++PtXY14Y87lxk+3piJIb9ZmQ2Q02WffPLaFi2ADqJwQmI8OW2wAxLrnJUkKtU5PMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009347; c=relaxed/simple;
	bh=5RQUyqaHkor8XWvXxEBRhLzFB9x/pasP5ESCMZUBEvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0FxGiBNF2/U4T9//l+QHw3iRMO4Wo3xv5M88L/94pCfwVsoo22COmfYynyX/7XEbdyRShGnI/NSbe+vdKldpoymc1C7At+hgVFmEU5pkcFWlnIEQqqMZtNMbRQv/bzjeV5AE+e41bMvbCr1WzwzaXgaChdO00qGlhVbJluD/4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfD0QW09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfD0QW09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866A31F000E9;
	Thu,  2 Jul 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009345;
	bh=2myOTq2cWpX7cHBj9TjTO8uAnC2xdxVNa9i4E3NdQY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfD0QW09iF63igPQAFcTFDkOhUKU4+0geY9z8e6GDXe9D4MbeDTAfsBct2HDXjIuZ
	 AjkEgLwcVnXegUpKhozsphNeJ60ZftOrrqBzPRCdiXtGhI8hqTKqh+YgvVo2s6/riy
	 2A8/dDjeMI89Qy+rS6/dSx0DhQ9idZWL4247iRfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/96] net: 9p: fix refcount leak in p9_read_work() error handling
Date: Thu,  2 Jul 2026 18:19:09 +0200
Message-ID: <20260702155109.348948232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

commit 4ac7573e1f9333073fa8d303acc941c9b7ab7f61 upstream.

p9_req_put need to be called when m->rreq->rc.sdata is NULL to avoid
temporary refcount leak.

Link: https://lkml.kernel.org/r/20220712104438.30800-1-hbh25y@gmail.com
Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
[Dominique: commit wording adjustments, p9_req_put argument fixes for rebase]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
[Alexander: this branch doesn't contain 8b11ff098af4 ("9p: Add client parameter
 to p9_req_put()"), therefore the parameter is removed from the added line]
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 40d458c438df1e..a75668534c81c3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -346,6 +346,7 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->rreq);
+			p9_req_put(m->rreq);
 			m->rreq = NULL;
 			err = -EIO;
 			goto error;
-- 
2.53.0



