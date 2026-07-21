Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FAE336888;
	Tue, 21 Jul 2026 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653616; cv=none; b=aXgsZ+eKup1LT39AqwHAw4eslnUGXPNI61UKJDxFXHM3kCpdj0yBQ3t7XMclCs0hBaP5DuN54Kewp+9dljK9GCa3PiDQHif2zaQlXO6Mk350r1KkxZxFdXW7C+JnJyI8m/x3zGFEYU1uC0OA7AsbIvc4OlTv6i+FkJ93gF98NB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653616; c=relaxed/simple;
	bh=1IG/vOCyOSx/d36ERT+F5WYU7jVMH1EKEP/ZoWAqSwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPUdAVBN9AeLcuMl+7xS8CUSuM6dFgTCFZZIHjLwGtJl0gQRggpdZy5OnM0EASKx4cjTeYOu5z4j1JQWrq7KZtJmFKEzTyhZFhGCFGzmU7cprsV8vgBuFtALNc8oxcpW8akJpE+h5lR8xTakPvpGYKhqFS1UzAAsLyX8AsQim/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUXkEkKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUXkEkKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4727A1F000E9;
	Tue, 21 Jul 2026 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653615;
	bh=ir/iR24qIy/XOdiinAoj6Rx70Uj2AIkjiWFme0eELzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUXkEkKP26Xz3WPFzKlAsD4R1heb6VoaO1eODwN4bxKC30T3gfLWnv8algCRXxQFE
	 umtGtoX6Z5FG5EFnpqUB4DbdE81sY5+262tMC4wF0gGLwQ9GlKpWz/rjOEWREAcPs+
	 5UEOTkLFbsEKR4C0p0KKgyADKPkhQqeKSa7ms7Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1395/2077] netfs: Fix writethrough to use collection offload
Date: Tue, 21 Jul 2026 17:17:48 +0200
Message-ID: <20260721152625.715768925@linuxfoundation.org>
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

[ Upstream commit ba6a9f6533c77c628eef0c0c5c19cd316e2be1b4 ]

Fix writethrough write to set NETFS_RREQ_OFFLOAD_COLLECTION on the request
so that collection is processed asynchronously rather than only right at
the end - and also so that asynchronous O_SYNC writes get collected at all.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-13-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 4f55228f0fd497..de7a5684b6091e 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -628,6 +628,7 @@ struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len
 	}
 
 	wreq->io_streams[0].avail = true;
+	__set_bit(NETFS_RREQ_OFFLOAD_COLLECTION, &wreq->flags);
 	trace_netfs_write(wreq, netfs_write_trace_writethrough);
 	return wreq;
 }
-- 
2.53.0



