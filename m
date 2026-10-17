Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245843B14A9;
	Sat, 17 Oct 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255648; cv=none; b=NxMUeziFeMKOEL70ZrS1MILRG6vmoseiHORVnsiUTp8S7X7jxi/mWnR9AKLhtEXpuY0hM8PHXoKLJrzpeHHj6UDEFbzspF69x6ABAnhP5wdVI9neykstYWAYyNHpa5MOBifcuIfDkIsynERF1lNaHGfneLHoi4OyWv6Ds4zOxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255648; c=relaxed/simple;
	bh=CefsxHZ2BQNrpcST9avEVjMZ/6/SMIuom1pUwjizpOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxReZELK4osPwUQospewmdjlS0h/LaSQbO0IU5fsYkqMbvcOhoyVRuY2sOaySjF8bNLRtcsp0NlaUtpI3IbbNdzPdDye4QNmygkewhc4u9PAcnm+rOGXyB8RidCtg/M8msZvDKcIlsKlt70U7qgMj1ElKrtPIkfPh2cS28LnSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUKsjwQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUKsjwQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F431F000C4;
	Sat, 17 Oct 2026 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255647;
	bh=ziZBdqYTqLSOtbrXRqki45+WPReTavQWQ13S4cMk4zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUKsjwQJJwk0mLHPq0SBkz8iT/zclfg7RPJy+J1kHx9H33iVtDzuQSLWVP8TuSRec
	 FZzYE0Q2dJ7Luefp23BWMDTeChhVnzN7AP2owiKSMXAugUoHTtUmw6pmyGiKW5bBJY
	 JZ1IfPdW3AIpLS6Q+xUWuibSNSrkkf0frvF3aSH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hristo Venev <hristo@venev.name>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 838/869] ceph: do not skip the first folio of the next object in writeback
Date: Sat, 17 Oct 2026 18:01:19 +0200
Message-ID: <20261017160058.360128321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hristo Venev <hristo@venev.name>

[ Upstream commit 081a0b78ef30f5746cda3e92e28b4d4ae92901d1 ]

When `ceph_process_folio_batch` encounters a folio past the end of the
current object, it should leave it in the batch so that it is picked up
in the next iteration.

Removing the folio from the batch means that it does not get written
back and remains dirty instead. This makes `fsync()` silently skip some
of the data, delays capability release, and breaks coherence with
`O_DIRECT`.

The link below contains instructions for reproducing the bug.

Cc: stable@vger.kernel.org
Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Link: https://tracker.ceph.com/issues/75156
Signed-off-by: Hristo Venev <hristo@venev.name>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 13508fee6293b..c20ef77bb6f0c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1326,7 +1326,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		} else if (rc == -E2BIG) {
 			rc = 0;
 			folio_unlock(folio);
-			ceph_wbc->fbatch.folios[i] = NULL;
 			break;
 		}
 
-- 
2.53.0



