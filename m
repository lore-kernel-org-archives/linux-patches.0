Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED445158B9;
	Wed, 30 Sep 2026 16:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786782; cv=none; b=KujEAJSYlEZ1rfOk8OpVqMAuD7vETabWlXmYimlevRcq3zgojiQ7NZgUB2NpwiHFT8Ec7MfNci3hAkoXHbsFAvhsD41iRUso1pq/kUUDKQ5uCrpq33A+0RW2nMzCODv4wjXdxyKGnorwIP9ikyD3goyob4BZgzwRDu5+psr925Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786782; c=relaxed/simple;
	bh=LMr9zLmi7SCJF5KGzFhOU/tn3U4Lh9uY3wWTW2iK3qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1MoRmdFhn2fPPeyoBBMuIC6s2uPXyKSzBAw6J1XFaXN8piFJvhUdY+AIYhjzUQ5IigC5P/PKtKs+C8bTrA3NnMJqLKDFRjhBiiyXYK1GCYHxwv+1KS1CcxEmsYtjiKJDi8f6RcjNqe8k55zFR/njOyU6zwJbRgMgq5ixWvXD8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilg/sTDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilg/sTDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD461F000FF;
	Wed, 30 Sep 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786781;
	bh=3grE2tfTE0SM350c9wI0EcFyWBBssKrr0UvLVbETu18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilg/sTDuzZThkzu3csxRF0VPwpt17yvobyqLUEta2qZV0DJl/kOKEDjP2szsUWb3y
	 HoGJ8Mqcy9HLnDAz/yU+qK2YZtZ6gaNxqfjXX8fEpzvc5B/wf/H9dVuhezm+Smn8ix
	 /gnbM0u+M0wAiRtN4YNf8rf6NB5m1DNAadHPMwmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 976/982] net: tls: fix silent data drop under pipe back-pressure
Date: Wed, 30 Sep 2026 17:28:32 +0200
Message-ID: <20260930152437.707620790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 242f96f799084..68b8a59684e30 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2392,9 +2392,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
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



