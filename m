Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0853368A2;
	Tue, 21 Jul 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658078; cv=none; b=tUbDYvV/osb5oQpAD84ewRLF9IkIQJWDZhxpcyCltn45xIq1hOayHocuO5A6v/HWT9DEmrqJ9GBjx4WSGTNbe62+gRi8mMzeNwVbirHGLcMLWBrxGViDHCIGzmiePhET6xj7AmQTXbqJhoRs2aTmHEpzr4jWaBw7V0E3C/DRB+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658078; c=relaxed/simple;
	bh=NNCgRhHSITfyl7eprYOVxWNHqjazf/CRcvNqqHJ90Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciSp4lju1SIyL7yEP877Ez1skgpb/BUcmSt6iC/gBHFsJpxzrqPrhQLCXkJv9Ri2IjnXn+mp+ZSJZOAE9sbe441nE/eQqX1F9jOi5usWJVrZwmzilRRKxluHxpQkx6TpNo1+LjBpy6nj8f2QAJSZICRR/xgPNlwVf3o/xaUV044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI6cTcc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI6cTcc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846761F00A3A;
	Tue, 21 Jul 2026 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658077;
	bh=VcQsTQhT8wlmqflsdqPc/g33gcKluSOHjTT4SnMW7kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iI6cTcc/CzYpGPAeKfM5xFl6vx+q/BgwMRGTK7QodOgm7jZzWvGgI0JsUCAN3eiGM
	 gver7TPLmmj8dW6KYBlOD7aSOu0nf4EWWNAohfsBMVp5cX751vfVy1fiyLZMLfc8vt
	 iorMhkYwVLpE87ZT9U0z6EsUGP78HZRx3zM4oSZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1006/1611] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152538.023171456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 0f36469d7ce98b362934113c550d08bb0c784231 ]

The AFS filesystem client uses an rxrpc server to listen for callback
notifications.  Each callback call type handler has a delivery function
that parses the incoming request stream, and this should return -EAGAIN the
last packet hasn't yet been seen, but all currently queued received data is
consumed.  afs_extract_data() does this, but the -EAGAIN return is switched
to 0 inadvertantly

Fix callback service message parsers to pass through -EAGAIN

Fixes: d001648ec7cf ("rxrpc: Don't expose skbs to in-kernel users [ver #2]")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-14-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cmservice.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -335,7 +335,6 @@ static int afs_deliver_cb_init_call_back
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
@@ -457,7 +456,6 @@ static int afs_deliver_cb_probe_uuid(str
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 


