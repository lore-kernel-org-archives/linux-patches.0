Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8408922D7B9;
	Thu,  2 Jul 2026 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010612; cv=none; b=mKbvfX+zb+ZtMFtGXsW5PMd+jCB2IQT5hMIWFmIAwjsSi895BT1nJidMAQg61Qa/KkZoUAtPRBkG7AYOjqBTjC7QIfVMAI6LHMTXWGlngROGCA832xyGmOo/x+KnOA5BhMzfdBNSyyiRRsboG1/JXds1j5DCk/KEgxYyLoecd50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010612; c=relaxed/simple;
	bh=pV3ejcsup1iSe6VlPV+lWBSZRWooe1aiQJZtMgZHc6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCm7nQsi6CmnkcfXS5ZHtE4fTdAkwI4ITsFX9JxKpcVtMkNZjidPQMy+RBETMfixzyJ0+znZ1Q9SkIJQMkNQ/rOLiLNFy5mKzsFe4UZZtPK65gkfB6TuctpaCoWdnbnQx/fUjAqFTD4KxLppFTEHdqSDqCAd3TZDjfLxY0Nc+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKQ1j3/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKQ1j3/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19611F000E9;
	Thu,  2 Jul 2026 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010611;
	bh=tDV8QcoccFjddg/O0k1ytg6wsORhtXIDMVC+0grLbSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKQ1j3/LRSy318xLW7SmEaU3yVtGgey+1DxwTJmGXC55aSIN6CR72LYiUCzcJ3kva
	 QaoPQqmSqPRn7BG4FZ9NRBytS2jEbvDTtFmQOFNwH1pBnTzFQhUo3F6D7/ZiKLYo5g
	 2OCseEpRw6TQRSjzvYhyCOWclTrV8uZ2iuwltWds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.12 175/204] 9p: avoid putting oldfid in p9_client_walk() error path
Date: Thu,  2 Jul 2026 18:20:32 +0200
Message-ID: <20260702155122.322574411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit 1a3860d46e3eb47dbd60339783cdad7904486b9f upstream.

When p9_client_walk() is called with clone set to false, fid aliases
oldfid. If the walk subsequently fails after the request has been sent,
the error path jumps to clunk_fid, which currently calls p9_fid_put(fid)
unconditionally.

This drops a reference to oldfid even though ownership of oldfid remains
with the caller. If this is the last reference, oldfid can be clunked and
destroyed while the caller still expects it to be valid. A later use or
put of oldfid can then trigger a use-after-free or refcount underflow.

Fix this by only putting fid in the clunk_fid error path when it does not
alias oldfid, matching the existing guard in the error path below.

This can be triggered when a multi-component walk is split into multiple
p9_client_walk() calls and a later non-cloning walk fails. A reproducer
and refcount warning logs are available on request.

Fixes: b48dbb998d70 ("9p fid refcount: add p9_fid_get/put wrappers")
Cc: stable@vger.kernel.org
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM 5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260528053918.53550-1-zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1215,7 +1215,8 @@ struct p9_fid *p9_client_walk(struct p9_
 
 clunk_fid:
 	kfree(wqids);
-	p9_fid_put(fid);
+	if (fid != oldfid)
+		p9_fid_put(fid);
 	fid = NULL;
 
 error:


