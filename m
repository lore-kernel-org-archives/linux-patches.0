Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319D37DE8D;
	Tue, 21 Jul 2026 20:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665150; cv=none; b=kCJAIh3n0W3ytvWP9JP0Ny+DkcQh60IcycKFr2NrkdDyfOHvftcP54xDpyrQD0dBPOPsSXYqXkV5l9jwu9tEnHvfDoI/MA6eRqBgT9FOdlIfTVUjoViUa1KWB/zLV+DdirGKbU4CyKMPcJe37NLWOXXQI6y+9p/bnCvsPxfkfWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665150; c=relaxed/simple;
	bh=WFAf6K0lU6YE/6hW75h4rQoLQPvyOPFQnnP5LsD0IiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qyew2zU7SPK5Q14y5sc5Nr1lGpRlMtt9MjjYhi4pmzkDQkVfBEjJjgp87S/TKTfwJ3m6eny4zIDz3lEDSTp5vOJPPqS5Ljf85hhqLGYRHzLl0JHlqKM3UdZzeJCWHnwaZFA13Ql3kD9kkd/TNPvXReQ/kZdKLeJhjKcBj0RFa58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHPLgwtv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHPLgwtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0031F00A3A;
	Tue, 21 Jul 2026 20:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665148;
	bh=EUqXAayV7IW9q0RtImyJ+7CQrFSTOGtFHRQLxcG1MpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHPLgwtvMV93iWWLT5a06fej+5Xi0QbX1bQTGgexuTtrs/OoxUg9yFlNUeosIKPAw
	 LHNDK1Iu86ALe+oRLvIjU6PN7SLx8/vqS8PZSqI2vTRJRdOz8BiGouKCZnvkXQ0sxK
	 TAQ5Lo3hY8rbd1EgIucys0bcQBPbCNWZJuyGR5PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0196/1266] smb: client: fix double-free in SMB2_open() replay
Date: Tue, 21 Jul 2026 17:10:33 +0200
Message-ID: <20260721152446.193095365@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit b55e182f2324bc6a604c21a47aa6c448f719a532 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_open_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3208,6 +3208,8 @@ SMB2_open(const unsigned int xid, struct
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	oparms->replay = !!(retries);


