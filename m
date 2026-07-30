Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7936829D;
	Thu, 30 Jul 2026 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427832; cv=none; b=aZB4UNxfDUj/t02Z1ELCL3ll1P5rNNgTkiw8BUy+vRRXaUWp1rCP55CzJwEBcJcNCOnCpXXwTTknjHuT+wXlfAbZM1ceu+rWhreXKNG6CJfWAZLQcfjhZLwKgKfjbotyFXD+05GR0gLjIsLpKK+SA5rslwoKKwv/4lor28WgM4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427832; c=relaxed/simple;
	bh=LMUZbuJMU18sfr41Sy7FBBwfruMuUSPQUmW9yo2BeX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW0teP1aLnEpqjdc5v03pf+3j7af1eyiwSvUpwPb/IOLzNRZKgXTGxLdih0+rdYOHt3dYag+Acorl4xngBh/rsEgg1+MvwnlGl2MWmPIw1WMGTecrNb88HvSc5h2AkNQf5dSxsl0RoeEIXsXnYlAuxSf47HG/wYZAsQ0M4wtOoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8XbYrxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8XbYrxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243151F000E9;
	Thu, 30 Jul 2026 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427831;
	bh=++PwNiin8v09tBZkKXVxuMJyqvyZneRS9MtD/N8uFA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8XbYrxouc33sp2tx18li5ypCZhqDZGaURMEHv+XeM6bhLYynUKyU5t00GfzDCMuP
	 twRoND/r7RS9KylI4MXhEZ/pzzj/s8UvyANcW9ZE1NojIdUwzyKrf4y9Ahdls5LH7y
	 ASiqI45riXF+2SR1F01cqm44au6NZ7h6GOQsDb5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 308/484] libceph: Reject monmaps advertising zero monitors
Date: Thu, 30 Jul 2026 16:13:25 +0200
Message-ID: <20260730141430.179338005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


