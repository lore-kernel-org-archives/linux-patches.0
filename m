Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE38E2DC783;
	Mon, 17 Aug 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977083; cv=none; b=aZd8Gh6n/Ho0iLVEo4T1VlGpTJ5rKwKi4Kcm8152a/gxa/L8q6JmG40xNK7H6u3BWIquTSz/N8LRdUlpx5oIBypFCpx7eGwivdW8lzH5S8UEecPpEEbWI2xtyE3vmr+WAIZOStszDUGeLBtUDE7TS2g5DSWWe4s796RUHpr9BKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977083; c=relaxed/simple;
	bh=Oas7lZ48lqeWctzgOUqE79qUnlS8Cm22nHjk8M9CIAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3xsVh3IlNmGi3kw7+sexzJwZwFrgQ2LVqujcPx0kPYYyVX8jvVxt6BBN6K6ljeQUihrPzIRnGPI8qx3T+TdV6tDg8JOxYxEvAJnRWzmAp306+g8wkz028KzK9nlDPJL2OXc6ES5V2e6zSFA3AZzBgQHjyrtkFyQ5ytwB8ajL7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI1NcY/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI1NcY/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F741F000E9;
	Mon, 17 Aug 2026 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977082;
	bh=w/zzhq0eparkovqD8CA0JJaRgFAkChNaSDGVsQrHd0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EI1NcY/QrRlON5QXuwm/gwsdiEwLbLjb24HmGDU0sTWaPTBcC8ZnZGOM2J4fyUyvl
	 8KUg/wt3F0dC1cyh2RQkPY3I8ueNS14oyCGzuYDqh4UtZsS0GPYkd2Zu6UE0o5bI+k
	 lgETibcoDRMC+R4i82kEwkpJi9+ph8qRpeQ+zx50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 206/456] libceph: Reject monmaps advertising zero monitors
Date: Mon, 17 Aug 2026 15:29:56 +0200
Message-ID: <20260817132548.191073730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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


