Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC62F691F;
	Thu, 28 May 2026 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998663; cv=none; b=qV9Wf80kmwrBRdWJBb0E8+4c5ypAUP/75X8XIQp2DZVTm9qTCytYFORQKcZtPNQnfTxgNMruGpF0EaEG8aA8MX997gRPZzDgWLUe8ljaXRwjSB3+BcOXCe7MqGXZSRZ/f3feGA53Db3s8Er808nq7qXA2wTrcJUaUx73WV2uQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998663; c=relaxed/simple;
	bh=115g4O8klZXCeFwlSybz05fGSfKCBkyjTMXSjWzCbwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKiOqIcf8jIVsx+t7UW9hlEwwNE2yvW5GHx9b2JWXjWxjgkcSiaVNBtzv/B07tnLlq73HuYPsTC9OUVH20YxA5RmOqg6SKmo1n6C0QmFJzkflxdwkUaPBz8C0quY1k2rshXzmbAD4irPALXvBkr8PX9N6NwC88pGjwzSrd0ZQXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHqCzPSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHqCzPSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B8A1F000E9;
	Thu, 28 May 2026 20:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998662;
	bh=6mccBHRUsC0aEDaQ+0AKbxndjcnBWbXbqXw+kuExSAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHqCzPSg0al5qQWfsmqgmri2QEZRzMakLcK3wE1TQXbT38SuXxbepooxs+52iS5aA
	 hXUNOgPgpfEbwMqWjhikq/MIMVe3Bjuwlw19Ut1149zX00i8lZqSqBKJan+T2DXE2W
	 7umEs/3WsqPLRHd8Fm+epWSrU1/aIplXAT8uvlZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 253/461] netfs: Fix netfs_read_to_pagecache() to pause on subreq failure
Date: Thu, 28 May 2026 21:46:22 +0200
Message-ID: <20260528194654.473633694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 8a8c0cfdf4658fc5b295b7fc87be56e0d76741f4 ]

Fix netfs_read_to_pagecache() so that it pauses the generation of new
subrequests if an already-issued subrequest fails.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-5-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 15d73026ff643..fee0aebf5a3d6 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -300,6 +300,11 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		}
 
 		netfs_issue_read(rreq, subreq);
+
+		if (test_bit(NETFS_RREQ_PAUSE, &rreq->flags))
+			netfs_wait_for_paused_read(rreq);
+		if (test_bit(NETFS_RREQ_FAILED, &rreq->flags))
+			break;
 		cond_resched();
 	} while (size > 0);
 
-- 
2.53.0



