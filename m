Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C253CAE7F;
	Tue, 21 Jul 2026 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674026; cv=none; b=Z+8UTI85mveldwiiwFh8ov+VValK8qaF3AD96Vi+hTWZaV0Oy6Jr3YuYHraeOt1CmLqfTGGvH4cu6iHMiUCGY/cdKM7zTjhCDFvGQs+mOzsu8/SpAQ47MJcGRCKtzKLApXu4f0YmifrexibCWaVnqh1tEwZEPUn1Gr3VlKiFk2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674026; c=relaxed/simple;
	bh=+cHgL61ty39rcCytcu2NiSDbAnPvY9pTEUoiRzC/di0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbZlTZNNHH8rGFCF+Bqra9nu2y0YMBGyd3lpiJIVYjIiHxrZzPs4+Yi+MBn1Hl0nMZn7V0kUaAFK0a5HpZgwfh/ncQ9YWORQLrU7tv2llB/k6YwacsLnD8CGV+sjdb+aBrl09w+A/rIPi/lWrUlR7+eoC2tn2BvlBnzLCVs/W8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDFbJDHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDFbJDHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783D71F000E9;
	Tue, 21 Jul 2026 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674025;
	bh=7uno7u0U1vdNVmPgKl7G2CqKpgYrLF3yjnqPf1rzWBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDFbJDHfkOcOtU46qCdUDuvO2XojRdAE8ZAyP1N7TMQC5YXUAsfLl4J2OMcj8DDDk
	 Ig2iniiKekjtBYLK3+b4jVHaF+BZgQJ49vUisksCuV5J7JNv+mOOMM0tOYVI1O2csd
	 QiKSWohOw9OoHER3WeTTVhIjqz7OvMMWjWDkCa08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/699] afs: Fix callback service message parsers to pass through -EAGAIN
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152404.378337946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6761a0b5f3986f..c7de60bade8d22 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -386,7 +386,6 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
@@ -498,7 +497,6 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		ret = afs_extract_data(call, false);
 		switch (ret) {
 		case 0:		break;
-		case -EAGAIN:	return 0;
 		default:	return ret;
 		}
 
-- 
2.53.0



