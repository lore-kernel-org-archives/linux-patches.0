Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A3B31E85C;
	Thu, 16 Jul 2026 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210304; cv=none; b=q7PFFREfTXVzLp36wSznTHcmxMJlFK30Cxp7MgQ9wfVkO3RG9JLjrusJxjIGVC+XuUWAs84a0N1t9lBBqW3HtHLf2G4wMo9cHxH8N18kJG//rbirKFfzusk3dqPUiTfs48sRzbGof1jAlCnUE6Z+M84NjrLlX5hCTIonUZ5JIqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210304; c=relaxed/simple;
	bh=yttkqI7caO0haSGqiLwnkwkcdQEA3eAV33HOfJHlQNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQlsz1a8GBIlz7jQCEjJM3qJ00gx5Rgut822EGyBTlRGeudAm9wfHGvUf3/bYW0g6tF6pI9QaLEhJS6aVDMBrIaNS0o7JRSBLH/Ajb1xe20slvVFwCWgVmiDYUbeeExKOPn9+zTaHUNjCz5/L7JbMhsyb6GWqCEsTSp/PS4oi5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktL25HWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktL25HWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6141F000E9;
	Thu, 16 Jul 2026 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210303;
	bh=dJTqhDck7k32oeTFO2BMWA4QRORVpBliubNw7pEuAmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktL25HWi2CkD1+U2PcISf2EDOOaEs6qykoSU9mf+v93v3TNsDOXmHUnHgZLE/Quzn
	 3fKvZt46pCFagtO9t/LZNtvrQTWALPBUAo/DxOEDqv8Y2Bb2/k7o4NtLbjccxkdhUX
	 kjJulsjP4kTU33fR6zMwNVTZWa63S9FFnsIg8BHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 515/518] fuse-uring: remove request-less entries from ent_w_req_queue to fix NULL deref
Date: Thu, 16 Jul 2026 15:33:03 +0200
Message-ID: <20260716133059.108740299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit 1c57a69be962d459c5e705f5cb4355b841b3461c upstream.

If a copy into the userspace ring buffer fails, a request will be
terminated and fuse_uring_req_end() will set ent->fuse_req to NULL but
it will leave the entry on ent_w_req_queue in FRRS_FUSE_REQ state. This
can lead to a NULL deref if the request expiration logic scans
ent_w_req_queue in the window before the entry is moved off it.

Fix this by taking the entry off ent_w_req_queue and changing its state
from FRRS_FUSE_REQ to FRRS_INVALID before terminating the request.

Fixes: 4fea593e625c ("fuse: optimize over-io-uring request expiration check")
Cc: stable@kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -706,10 +706,20 @@ static int fuse_uring_prepare_send(struc
 	int err;
 
 	err = fuse_uring_copy_to_ring(ent, req);
-	if (!err)
+	if (!err) {
 		set_bit(FR_SENT, &req->flags);
-	else
+	} else {
+		/*
+		 * Copying the request failed. Remove the entry from the
+		 * ent_w_req_queue list and terminate the request
+		 */
+		spin_lock(&ent->queue->lock);
+		list_del_init(&ent->list);
+		ent->state = FRRS_INVALID;
+		spin_unlock(&ent->queue->lock);
+
 		fuse_uring_req_end(ent, req, err);
+	}
 
 	return err;
 }


