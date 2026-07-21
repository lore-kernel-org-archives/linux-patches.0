Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BBD322DB7;
	Tue, 21 Jul 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653632; cv=none; b=MwWZgZP5YIL48XHtAwXFVDKB9ghirFEgyZlDtA+k2lQqbmTojJ1d/SUz7UinBdVcHvUO7ZRhNyULIgpeiM199WI3Ygcn1sCMoBpDYNWCm8KJ2OrEeaaMoQ+fsuT8gIeH/t4+xp6Oc0ox4kH73i4PQr+ZfCEHBoM7FYv6hWBcwnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653632; c=relaxed/simple;
	bh=h+nMIFSJuxA//msXWrfZpm8VoaKYElq0ZDYKtjwTlww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXykMxBppqUYdaDZ0WjanNy87/K++zhLC/MUzCoBo++z61w9fozXfPcO3Z8fCaofdSmqkAOsC6SE60/WtaTL/PuvKNp7VM4MyOeFco+PjcV5iYZLM9SeanMLBLibSpb0BswKvylSCHYHy/2uyWaHDkb2v+TrjfszAtPTSd2i+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACFLzo1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACFLzo1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C781F000E9;
	Tue, 21 Jul 2026 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653631;
	bh=yBMmsFrLtIOXNSgyue+jD85whcuuB2bFTDzTWo/4Xdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACFLzo1fQSGfhxl+wz1MQe4Fuvu7kheOUgmFW3xl5zMZPFhc+3SHl3njhUXMWDyBX
	 eeIZlniPtfLxFSS2mOdnyoROIaBF4yHzhANCL9rWwO7B7NRYZvLQSovaR3XeVQ50TW
	 Qs6UX0tWvwLa46qlq175+Ym1gIs7DYMvLp94oKe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1383/2077] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:17:36 +0200
Message-ID: <20260721152625.435883945@linuxfoundation.org>
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

[ Upstream commit fc10c0ecf06f2981af5d04357612b00051e03e9e ]

Fix a leak of the new vllist in afs_update_cell() in the event that it is an
empty list (nr_servers == 0), in which case the old list isn't displaced
unless the old list is also empty.

Fixes: d5c32c89b208 ("afs: Fix cell DNS lookup")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-18-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index e0fab1609f2787..fbb8a43aa7cd9a 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -547,6 +547,8 @@ static int afs_update_cell(struct afs_cell *cell)
 		rcu_assign_pointer(cell->vl_servers, vllist);
 		cell->dns_source = vllist->source;
 		old = p;
+	} else {
+		old = vllist;
 	}
 	write_unlock(&cell->vl_servers_lock);
 	afs_put_vlserverlist(cell->net, old);
-- 
2.53.0



