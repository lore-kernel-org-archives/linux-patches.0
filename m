Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFBE35C69D;
	Tue, 21 Jul 2026 21:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669746; cv=none; b=G3t2kPwEvmnDX+TlwVhhjpeJPZ2C4RFN8ruF14ndmXf1EbJc9oMLIvxUV3oYtEHXUBMyFbWhaSPlfqSzRxzobiwvLlaVxLFeJcQ2KnFjWhQyMSGhlCwkOt5c4lMY2Oba0DiWW4ErVLgKKcxVVwYeCiYjUQSWr4B1oNVnYg/qycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669746; c=relaxed/simple;
	bh=ob/2g/iNCLYfUFmRf8YJJFtvBBYSEBse9qdpnvVKeqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHeTlkeKKgeeKVNBPUAe1oTQDpi8kYkcPxBp6LK6kHQfGdFMLzdyPU2GW/DNSjZYOzHbihtXiHrisaKNEoWr9IwvPUcVMzQwMFgTBLVJm9cPpZyRDHUdJI3EN+V9qGG1YqF2EPrKmX8rP42mUbpUAub7llOCyUTE3UKQSvzUXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBbGeZML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBbGeZML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7E71F000E9;
	Tue, 21 Jul 2026 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669745;
	bh=OGJ1NYekPHAPBVePvAWso8P74ONgdLzDDVD7R8MNz4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBbGeZMLeZ3XCn+ZxQy0nfgBcZKiWfhN4waDSI7KBzqwSZwTAJPmN50Fd3pRwBj9T
	 Q7kg4fJUidGu/UtmO4q4o0MYBzEgKGWirT59M2fg3t+8UeIaZTFatB1Mq4cOrq+pmy
	 ZTefOcWJfxLESRm9J54eGGl8UDvxbqZKYA4Y17qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0672/1067] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:21:13 +0200
Message-ID: <20260721152439.628538087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 7dcd59693a0c2f..986defdf5bb1a3 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -388,7 +388,6 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
@@ -501,7 +500,6 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
-- 
2.53.0



