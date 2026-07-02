Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6477325B09B;
	Thu,  2 Jul 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011096; cv=none; b=TiMYQJY/0hMvJYnMSpWewYVRJ7dGHCmP6zBJIO/lDg8C7aYby+VfQzqYA2nUlBeBFkccZnZGd6cXQgzZxtMeKjjJE3EpXqBBB9L8O8apGt+PCFKTFr0RfLUIPGjh6bgZoYfr3CPKSIGhKFCPif+coNdsMNmLOVMlSItzePDLH4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011096; c=relaxed/simple;
	bh=ZB3dpDpnaZo01cASRzBCmriPiGWV2VFDhhLwI7i9lhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYOSR6bWSc8FyaH1WP2uwe1tp3jdMuAWqaW/yPizoZrdDtyq04nmPi7jkn8tn1fQMl12B41EfahcLGgo/9lRSIJGXkUm+a2fpk4bch3q0glCBLqsmWUexEfPAMnlUg+ODUBBH3YFuu/il5sSIbI3IGOjFUPJNsiIJEm1V8iXjXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmA3j9tm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmA3j9tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25E01F000E9;
	Thu,  2 Jul 2026 16:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011094;
	bh=ouTD5ErAL4x7RKPPK/pKsioWJDlaaXjbJeDPMOYg87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmA3j9tm5fYtZ+4Fm5dyPCdCAIKPQdwHp62pCwGOEokvqZPvyC7euZytB9B5qKNsB
	 MjafXIbeh7OYi6gf9OwmTz18Ouk9PXT2K0mAMjmWsb/UiVqyPfhiUjiYA6SVKvdfsx
	 DTBDyW1CXLIe1/6KDB/rmlHpBDNIEu2tUWPXFRVw=
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
Subject: [PATCH 6.6 155/175] 9p: avoid putting oldfid in p9_client_walk() error path
Date: Thu,  2 Jul 2026 18:20:56 +0200
Message-ID: <20260702155119.062988236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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
@@ -1214,7 +1214,8 @@ struct p9_fid *p9_client_walk(struct p9_
 
 clunk_fid:
 	kfree(wqids);
-	p9_fid_put(fid);
+	if (fid != oldfid)
+		p9_fid_put(fid);
 	fid = NULL;
 
 error:


