Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8F23161BF;
	Tue, 21 Jul 2026 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653664; cv=none; b=k6g7h7P3YFx9Hlu5Lhz5sBGW6H0KMHsjs4p5OzKbN0tTOWWpREkeu052ZqG2ndynugMg0Jfx4qOhcvYIHk1Uwr4bP/f8wdrNefNQXUyQ0pFjDfFyzGdT6AOJWQVEnh8j+O9d0l6puF35FgQxvc/5F79cPwc99wAe7wD2zo7j+R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653664; c=relaxed/simple;
	bh=vs5yT8EjBn8tvYpqjylI/HCi6sb6doUx/+jHsuoh9IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtAL6FmO2+sL3WmuaVtn0JAGylxkWnXEnYqu5/KHlKGpKmvYDctuuSGbxuFFYVDMDR2w7jTE6R8rYktwMpx3F+lZ22qyxoWL41/l9odoS08nDFzKTtE3Y/h+XCq2OV9c6hDldRCkGFLg81j/aEuw8I4tD16oeARhGCplij4hLzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUkH1bGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUkH1bGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D301F000E9;
	Tue, 21 Jul 2026 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653663;
	bh=hUOQnHMxNQMYlUGAaqgMEU4Aw+m4qmzUCdxFyHztgXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUkH1bGFmww3QvO4ilhRsiXOmw5lEzAK1rj/vVyQl5OKl07lnTJWtN3XItyw8kP5F
	 e7WviV7d3HV9aWl8Vd/A0hnJU9dYOieyHUMqL8J3oxh8et7128/71M6jQN41EmudUr
	 0nxtrJ68+RAoRabOb2RE28LjSkiXH3a20y5F95iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1411/2077] netfs: Fix barriering when walking subrequest list
Date: Tue, 21 Jul 2026 17:18:04 +0200
Message-ID: <20260721152626.087808706@linuxfoundation.org>
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

[ Upstream commit 5c6ce05e406520290c1d89da97fb3cd70c09137d ]

Fix the barriering used when walking the subrequest list in retry as
there's a possibility of seeing a subreq that's just been added by the
application thread.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/138807.1782980582@warthog.procyon.org.uk
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_retry.c  | 7 ++++++-
 fs/netfs/write_retry.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index f59a70f3a086b4..2b42758e01ec94 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -98,7 +98,12 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 			goto abandon;
 		}
 
-		list_for_each_continue(next, &stream->subrequests) {
+		for (;;) {
+			/* Read pointer to subreq before reading subreq state. */
+			next = smp_load_acquire(&next->next);
+			if (next == &stream->subrequests)
+				break;
+
 			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
 			if (subreq->start + subreq->transferred != start + len ||
 			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index 32735abfa03f06..058bc7a166a59f 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -72,7 +72,12 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &from->flags))
 			return;
 
-		list_for_each_continue(next, &stream->subrequests) {
+		for (;;) {
+			/* Read pointer to subreq before reading subreq state. */
+			next = smp_load_acquire(&next->next);
+			if (next == &stream->subrequests)
+				break;
+
 			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
 			if (subreq->start + subreq->transferred != start + len ||
 			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
-- 
2.53.0



