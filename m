Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED6254B1F;
	Thu, 28 May 2026 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000013; cv=none; b=uAU2+PyhezS1bcR95dtRPTLPnMNb7+wdkpLMYvCB71x6DMHGgRJnV1WcwrFKLnTDDwZqIcxtAFofdCV9zdBVCN4pCYoaIz8xhKVP6jN/f4Kq3YeF4p+SiN+E/P+ViMwMkgzpz8XCoBJ21zcbRnZQaXcMv0VF331HjJEY8os8tNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000013; c=relaxed/simple;
	bh=s884TM3NuC4E0k5rSro9Gse4AMNRC7lq0+DMIIT6Lqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrWwXMgVinc7K7igxi5hhChZfNggIG/Ho+VFRSTOMGN2AUI7UtDzG0eRauPyfRCg0li5zCnpEt68zwg07/qzSfv8Zen5jREbOIy7iRPHzZMrn9uZ5+76nIIqMSc28k9kLEEs858J/qV7ABz/NI+GaBMqN2jNeHsAUUhXgUohYOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6X6o1UM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6X6o1UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBE21F000E9;
	Thu, 28 May 2026 20:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000012;
	bh=aQdeFLunB2ZZVojSpuIHgSNsL7kia4dOvzFfF53XOjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6X6o1UM+KMDodvt5JkdqmtSGae5crq4fA89MQsf4gPtY17EdmiIeOdfGB8EFAred
	 GNUeBMULnenufdGX5aTiSL4ND6VatJ7dQX1itw1e8oMcxUg7coCMeZ0Hh0Fj+DBTf5
	 TENBr9r0jzeAFv3MKDW5bCcTYswSUrRGGrughuYk=
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
Subject: [PATCH 6.18 234/377] netfs: Fix netfs_read_to_pagecache() to pause on subreq failure
Date: Thu, 28 May 2026 21:47:52 +0200
Message-ID: <20260528194645.168179138@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 10b13924ed543..e6157122da3a4 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -299,6 +299,11 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
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



