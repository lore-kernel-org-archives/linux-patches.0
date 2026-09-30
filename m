Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F1441D4F7;
	Wed, 30 Sep 2026 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797129; cv=none; b=aAqnFTTUzZorsFAskk5ynE/rnGi6HO/RqO0ifyNBhWmb4Xb4pJBdXEixZEtTyWpSnKmnqmb/e/YUTVku/IaYNVrUnyOctTJh07QGB7G0ss1d4SQ5t7o/Yi1C58ZNlQ6BmmmyzrjGeA2FjcuEW3LN/Dv5bNOf/3tU0Le514m7OeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797129; c=relaxed/simple;
	bh=JW+knWsDlE2vlMhbNzRFDXvCxKRSkzkahgbT7PSn5Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNHmA7IwDoAJgTZUi+waFO9nluCJEazWozFc0VT2CGEr5mxGTSzVxokffdIBaA7Fh2EdvpIisdLyid/ZT7cLlTfJ4sqrY3pSg5zqlBEHgvUewJgEkUFaw3Ngx0xotQewohTe3LsK2argOvL0MOca7cV/8xGK3NT9zV1P5w9Gj/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jdj+1RzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jdj+1RzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E21F00898;
	Wed, 30 Sep 2026 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797128;
	bh=E8xEGVdSp1b8fKhJY+Lqew31znGEQZtI7lHhn7SrzNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jdj+1RzQAzDuYIzTz7aRqQMuVDYiqrDgPdzFNNr8DkwAlT7VaJEmv4OC8NZvJ6c5/
	 T05O7hikx2Z5Pykm6R5ZXihydsaFBC+8BqA1CcvR+BNJrX4aTj0vauxnK8wzCosjMO
	 kaSdwEFVqcPvzTW9FfDCX4CxkVI/DeMFT+bK46/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1158/1193] net: tls: fix silent data drop under pipe back-pressure
Date: Wed, 30 Sep 2026 17:30:42 +0200
Message-ID: <20260930152459.970397919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e7be31bfdb066c1c780dcd6b1224078fc54063f ]

tls_sw_splice_read() uses len when advancing rxm->offset / rxm->full_len
after skb_splice_bits(), rather than copied (the actual number of bytes
successfully spliced into the pipe). When the destination pipe cannot
accept all the requested bytes, splice_to_pipe() returns fewer bytes
than len, and 'len - copied' of data is effectively skipped over.

Fixes: e062fe99cccd ("tls: splice_read: fix accessing pre-processed records")
Link: https://patch.msgid.link/20260429222944.2139041-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d380aaf5f124c..fbea00967c14c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2338,9 +2338,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_requeue;
 
-	if (chunk < rxm->full_len) {
-		rxm->offset += len;
-		rxm->full_len -= len;
+	if (copied < rxm->full_len) {
+		rxm->offset += copied;
+		rxm->full_len -= copied;
 		goto splice_requeue;
 	}
 
-- 
2.53.0



