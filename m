Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335E837C92C;
	Thu, 30 Jul 2026 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424790; cv=none; b=kCB5Of7x2GZPaG0mlpDzCejpfIkWANVKYd+je2Yr4A3FJNE6qWCjzm6a9S24p5/5FXnCnTWEWvVj1DDc6nsTd8FLtnDJQ8Yr1HLL5foSE3zR3XiiOF/zPOBvMKdwgeoV9RCOR3q18wecOgkpkaS9YjCYY4EXqfRwsfIElCeVjEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424790; c=relaxed/simple;
	bh=VdO2U6518oH+fHSp6kSe09JaSkTYw1o7Hy6SibAyy9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS5hsd5a+g0k5oUTmE0Fr8w4XE5ogRr1gPCelRjPsdW+UeYWHT2xVGZ4sGiC84L5Q0VYVpjB+DWtlcIe/5I/f4WDyEVTzr6bTnjgsJnpimo6Mrreon22k/0AA7ghePva+90bK8sr8vZ6BPDjckP90/OXl8iwRkIqFkibLwhecUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7Lw9nOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7Lw9nOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4261F000E9;
	Thu, 30 Jul 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424789;
	bh=sSDaB8+H2oZikQ8oOmoJc8y3yb0yDIXRIts0F5yqQ9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7Lw9nOwwPTxbuedzV/akvGgRq7rAWJltIhOPAi120wc1EFdzQaDCuG5Aq04fi9pj
	 kqac3H2LC2suTHLSVBvoRmqgbvJQdeWHBh5JkxqORBbO09PN82Odh9N6bqEpUS52b+
	 pvjHPFFVI50f0cWq1sODNqblHpyDU2m7Q0+xYZjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 518/675] libceph: Reject monmaps advertising zero monitors
Date: Thu, 30 Jul 2026 16:14:08 +0200
Message-ID: <20260730141456.146084993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


