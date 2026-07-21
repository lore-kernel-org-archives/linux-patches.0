Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D50A3D1CCA;
	Tue, 21 Jul 2026 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653582; cv=none; b=JpG2a3uLtQPywfeQZIi5FyxTPeW3q6hyHJCiAZaQfZKjAj54KsK88QedLHpMGp2HKbXYBCV/DrNeXGc2/mIHWWQ1zZ0gYsZtzSWhNUc3iC/AHjp36PIKVhqh3wQ8T6a4quqCx56pu7RhD6vrJJncUeuUmbJ5Ma7Q0EYdkuKbrMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653582; c=relaxed/simple;
	bh=NNJIIJx6g9s8H7+L+IUFB8MuoG/yQeq4dvyxtuoQT5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mktsUr8xIBKOfBLp240WP3me20AB5iBv9ioVsYSXXuebqGBwuF34srAv/i7glCrNiOvTmAfnmlCP30+hV7a5f9QpVIU8J2ETR5YTdNfgvmkluUYXnA8vL6nPHZRMNlUQFmhLlEm3HyvNezEtTn4oPuXfIi40euiGGpvwIuYfgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/5J2ffF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/5J2ffF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35051F000E9;
	Tue, 21 Jul 2026 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653581;
	bh=AMqaU+tx2QwwPVzF2lqqrqa8I63YYuIozCSpiRlPrPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/5J2ffFNIC00Yq5xYf1ju6tP4EvwgxE649qy0LFLY+w1xmCNXCIUtwlf2jy8fMT0
	 k+rWZWz8TWEE+oyk1vQ7mih115TI//uZ81GSQCY3sTdeThpEErzDFw7R/q0S4TJNeV
	 1C7PpzPhKicXySwA/mw/vY+7WsEyEjFoYjA4wz4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1379/2077] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:17:32 +0200
Message-ID: <20260721152625.342232210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -334,7 +334,6 @@ static int afs_deliver_cb_init_call_back
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
@@ -456,7 +455,6 @@ static int afs_deliver_cb_probe_uuid(str
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 


