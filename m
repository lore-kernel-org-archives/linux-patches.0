Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F7443E08F;
	Tue, 21 Jul 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672130; cv=none; b=EKVtdjgbNIzCHMO1i9LVTw4xqN8Wu6Buw5qTok73NmPVAwKA5KL/hEJF8jm9U+twDdtZmtMnAARRseZQjapfERS3wjDGrcEM84cTjcexWQ5Box2c8lxw3eNY6xMQotwv3VixqerzmN3F6mYvaf/Rgue2oj6+sYBakh70RNVhRRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672130; c=relaxed/simple;
	bh=vGNfxQdAkTw1yw7AQIkZEeF/zmUkgMXaId4c0DePrR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAqpvBnN4BMX7PnOt3++Bnjx3nJtXI+aQcMEENmE6t34XXa+r2yhfkrsua/daohTqrTe9AXEb39TNS9MRLor6IneONicCRwAzHnMIwlgysdYAOXPpA/42GOXB89oWkpQwbIx3xGKY81OVmivRCXhTGQ9qksasPST+aVbc9U/1VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBbC20V7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBbC20V7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C2E1F000E9;
	Tue, 21 Jul 2026 22:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672129;
	bh=I4m/8gsGD89B8YIdNxd26OssP7kAcH9ffkL+ku9V31E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBbC20V77UumUBa1IfubAEzrxdS9/bl9szDE0LoAb3EB7mKravWIEAUJmsXWfDAQx
	 VWSiWkKHXw1MqvQM6nJJp68vqeHUqlFVssNgeLNkreMvnbsqsOe2Mtcmok6BrOu+J1
	 HSRYMg3sjq8hHiQ21nTiyFvPkIIHUp67QSBi2NLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/843] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152417.481065012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 573969a882e0c6..52dbc9ec434011 100644
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



