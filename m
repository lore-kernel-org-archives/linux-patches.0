Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EC1279334;
	Mon, 13 Apr 2026 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096576; cv=none; b=VY0+25hI80aAx+Xc8MHiA43sXJZWfcdLCs47SYKWvF6FeKaepRMaENHFVT0XLHJVdEs9OmH89e0lnTO2sUVNOIlqtZYmU/KwA9Ox14SUfBKGBRDYfRMpest1TvpxcbKQAwDa207RD46Vs/+YzkjNLpAi6qo5FvbR4P/x31Q98H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096576; c=relaxed/simple;
	bh=8rVVvj2DSIBPMlUNnGmKKG+yntv4L7JUWNlwjMoVyuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tP9CjJ5WN/PCMOimTZnrWSKa4NqR+PNpaPVyDk/7PtLIfSSx+2EcVL5DrrxQOsSaJ4+SSVUty7lmmCaeizLfVhEKVD9Re2Qqn05D2H/vNixoVFGGvc1pTcOq6nMja4a5s34q1JIdUjnvLY3A2bL5QRN+63TliE9t++qsf64XITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uvp4MQB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uvp4MQB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FA1C2BCAF;
	Mon, 13 Apr 2026 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096575;
	bh=8rVVvj2DSIBPMlUNnGmKKG+yntv4L7JUWNlwjMoVyuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uvp4MQB3DooeobKCTB/poJCvXk967QxV+fOxWRaFC923vuPH0ZzGAyg1mzWrdBU/a
	 o10cGY30qnTeDBslrViEXyaQY0NUcIn2hwrcwprF2ompyQwqRl36sebzZsbnkykd2T
	 pQGKvaRA8v6ICLjFOf1oI7VVQVN6AsPLh1xNVLto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 64/83] rxrpc: Fix anonymous key handling
Date: Mon, 13 Apr 2026 18:00:32 +0200
Message-ID: <20260413155733.397630874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 6a59d84b4fc2f27f7b40e348506cc686712e260b upstream.

In rxrpc_new_client_call_for_sendmsg(), a key with no payload is meant to
be substituted for a NULL key pointer, but the variable this is done with
is subsequently not used.

Fix this by using "key" rather than "rx->key" when filling in the
connection parameters.

Note that this only affects direct use of AF_RXRPC; the kAFS filesystem
doesn't use sendmsg() directly and so bypasses the issue.  Further,
AF_RXRPC passes a NULL key in if no key is set, so using an anonymous key
in that manner works.  Since this hasn't been noticed to this point, it
might be better just to remove the "key" variable and the code that sets it
- and, arguably, rxrpc_init_client_call_security() would be a better place
to handle it.

Fixes: 19ffa01c9c45 ("rxrpc: Use structs to hold connection params and protocol info")
Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/sendmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -637,7 +637,7 @@ rxrpc_new_client_call_for_sendmsg(struct
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
 	cp.peer			= peer;
-	cp.key			= rx->key;
+	cp.key			= key;
 	cp.security_level	= rx->min_sec_level;
 	cp.exclusive		= rx->exclusive | p->exclusive;
 	cp.upgrade		= p->upgrade;


