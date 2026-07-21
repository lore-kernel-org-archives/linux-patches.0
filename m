Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDD2403B1E;
	Tue, 21 Jul 2026 20:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666944; cv=none; b=e65+aOhGXFBQyNX5U6IgQp0Hj15osRVs9kD/6mj+LfKdzOAc394TZSsdGh1M0eEh4QhywZqPNXnNzIwImjJcq/A7BBZ8XqqSFSwJneYt5qswELMJCFtxrD/8HI2JcX74scN89jLcWHocGbSxZhTknq6ea/gtA/bh8xHxr2c9VPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666944; c=relaxed/simple;
	bh=j1wBiss5zpHoHWXqY/LUixE91tJSDxA0cp7vy/B1iuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akjoi1+mCYVJhT+AlK612kkIZUwv9dmS+8b4ZnyARB6e651PCury9leBY8QzUHjJ0VzyT9iINaASkla4/jCaGCzJ69+a5TkhbxArUmpp6MAWLOKIKIejckmLauonvCBhdB1GTObrsmGNGwHkt4YtPpCKji7pfHiUp6t77HygYdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOpmweNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOpmweNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD801F000E9;
	Tue, 21 Jul 2026 20:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666943;
	bh=CERAAqLGSfI8g0XruAjhIIxBYkZsjMPSloWfBnRc+TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOpmweNWdQM9LlyBFXTMASU+r/hrMjS/712iE1PeNTUAPeKGHmEu57hnmKJrEqs9s
	 QkTWL9MA+8A+DAdL4A18StVuSg6vl73oUDa+hkcrH3TRAv0As0gQSg41E5O/zJjk0T
	 b0UCXmFIYbCH2pI6Za55pbAP2E6nRPjNSCfvDMQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0831/1266] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152500.450512587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 fs/afs/cmservice.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index d4ddb20d673208..69877bf9a42ebc 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -390,7 +390,6 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
@@ -503,7 +502,6 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
-- 
2.53.0



