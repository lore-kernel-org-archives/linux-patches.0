Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBBB403B1E;
	Tue, 21 Jul 2026 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666951; cv=none; b=FAAijY9ScUUPS+bzzEnSGjbFNGuA0c5kCwqcIqz+P7XL7XCLIaiNf2EzxZwNJPPa/4JgXtqndgvi4xoqGHRsjjF6ZqREG3Enq7PmWRrDH3ogw63MRqqMv09nQwOD+xpXstFZEkjPQe8F5Rq/EiaQdfiI1biz3SafCVxtTHbaFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666951; c=relaxed/simple;
	bh=rMde2JxwmqDnCx6yGGqTZJSnDzbhmZHhdz70nPxarsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdxVH96kHhy/e6WPd5HHLjMi6Mm2CA0A6JA/7vCkqRiAoyxiG2G6qYpJR5/AX8uxBzi2LDYQN95zKluTzgnYZaONRrn7UkXH2D1tc7x+tfKdUvlhXFHAYrK5mG9Vyd1dUq3oclY42oOdBqVwbLabu24SNdHVmh6PuLyD/5EqTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/G4fMp0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/G4fMp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D711F000E9;
	Tue, 21 Jul 2026 20:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666946;
	bh=qwouHWHE4KDZ+88Qsal52JgDFZz+DHRh4pgwILOlwrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/G4fMp0+fsHDU5mztREGSoY1tOu+b22WheEm4/1E+zo182TfWN1shppTdnKI+zjq
	 rLNtVqN16U+4yptiZenyMYIdVqEVGFzHidlhzzqdW4HcCfLWeZuh+YjdG09yChxYfV
	 NyJhDgTtSb6ZzZFUimjkbq7AY84TdvveJhsy8aRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0832/1266] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:21:09 +0200
Message-ID: <20260721152500.471991865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 7c0dce8eecadd1..93f695936fefca 100644
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



