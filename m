Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90813D5C07;
	Mon, 17 Aug 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979520; cv=none; b=QqZ47me4I2vYDuIO+kXMJi55ZjPS+khCaASF4MoAQOa2y1DXWyov1tax7gfVqo0z4gabzY+zRSYLPNZz3mFIj6TBGBQhwAXTiucs9F0769IpnvSYKobIcO11gli5bdZWyK+Spt1zojg1aQHrlvHFCg9ryIzl5infcgenv1gH3dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979520; c=relaxed/simple;
	bh=bfSTI5+PAOLU2F2mLfGqcCTVewivPBm5ViO4SvntS0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmODZijge2S8uXE3fJV0f4t3SBw5sAtcNWtCJX2Hb3fyk7buiGlwVntwGyGtdHNJTJUrIiKn3GNbwdTWArGon6stNziF1nec0YcutlqCkkKwaDYF/wXB7sdnojGNUqWdTpuga5zkEvRBHvnmLe9hpTipDDrJl6YxKEZlLYU2rBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1BQQxB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1BQQxB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7881F000E9;
	Mon, 17 Aug 2026 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979519;
	bh=PVEzSY5sHwk1WwOsBoe6/K3CdTODqyhQq3XuhniMvVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1BQQxB5/Ohzp0zk+YSaplDimlYiVvzR4Foyi8CO5fXjadAwQGUvMDKCMV96f47X+
	 k4GJ3mpWTVLXvZ+IHTqfITDVkUnO7BoAsW5m7FoJkUqOQDYs0+64+PaTGBpX17SmRA
	 w/fTu5SMHsEoSMXJET2qpo0UD8wBECe8mvFSCn7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 254/609] libceph: Reject monmaps advertising zero monitors
Date: Mon, 17 Aug 2026 15:29:10 +0200
Message-ID: <20260817132552.600445620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 40480eee361ed9676b3f844d532ac28b47251634 upstream.

A message of type CEPH_MSG_MON_MAP contains a monmap that is sent from a
monitor to the client. This monmap contains information about the
existing monitors in the cluster. Currently, a monmap indicating that
there are zero monitors in the cluster is treated as valid. However, it
is impossible to have zero monitors in the cluster and still receive a
valid monmap from a monitor. Therefore, such a monmap must be corrupted
and should be treated as invalid. Furthermore, a monmap with a monitor
count of zero can subsequently crash the client when attempting to open
a session with a monitor in __open_session(). This happens because the
"BUG_ON(monc->monmap->num_mon < 1)" assertion in pick_new_mon() is
triggered.

This patch extends a check in ceph_monmap_decode() to also reject
arriving mon_maps with num_mon == 0 rather than only with
num_mon > CEPH_MAX_MON.

[ idryomov: drop "log output for unusual values of num_mon" part ]

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -114,7 +114,7 @@ static struct ceph_monmap *ceph_monmap_d
 
 	dout("%s fsid %pU epoch %u num_mon %u\n", __func__, &fsid, epoch,
 	     num_mon);
-	if (num_mon > CEPH_MAX_MON)
+	if (num_mon == 0 || num_mon > CEPH_MAX_MON)
 		goto e_inval;
 
 	monmap = kmalloc(struct_size(monmap, mon_inst, num_mon), GFP_NOIO);


