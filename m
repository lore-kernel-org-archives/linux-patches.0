Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63E43F4C0;
	Tue, 21 Jul 2026 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672133; cv=none; b=FyiR1HKTQOzkl29qrSnqYv04byNf8SIrvW33KPeOVlzcR4u5duDcHp/Facgby8FpUGkVAEvPmvw26V0e/LYOEl3P7tXllMNfqSZEwAN+BqqkcdhIRv+IOKrL++Kcmw89clGjLxiFgVlkhn3bMHFHza4W39QDEpqyRH1LTWJCGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672133; c=relaxed/simple;
	bh=dP/dmyXPQviDCuXgeSuoGu8mv6wiW3i8ecW5JMLpzmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwZ9bAql5pbFzQ/8TJONlCJ8lJOav9KNWQ0q5JU/uq0Csr+8LQ2xVskPvfiSQYMsmIo4RIsiigSfFhobR/FBFPY642EEoSLccd82krx1tYKLWU2An80JXltGpZXUI25HF3AM0e5WIouKo/Axa2hFxdvdVZcT81n/USjg4kslC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/HoyCIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/HoyCIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B681F000E9;
	Tue, 21 Jul 2026 22:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672131;
	bh=K+QvMdK6RExN9HLPU2ANf8H4/1d3aIJTRU24upvneAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/HoyCIC5euCnV8+83zGuEDtb21oB+pGIDMWqN8AfCwPRDYGhu33qc9sX+TrP7iFI
	 qqgAXH+Gt0C+SLRC6bNVuAL8NIoJNyBaBb/cbwFsrkk9sO4/RCcExa6K7DR52HSXQ8
	 wKMtR3Bxez4XxfxtvWgqxXrZ30VTKuCbNwmNj3xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 510/843] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:22:25 +0200
Message-ID: <20260721152417.503670239@linuxfoundation.org>
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
index c04c7b5ec780d0..7415207b5136e6 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -474,6 +474,8 @@ static int afs_update_cell(struct afs_cell *cell)
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



