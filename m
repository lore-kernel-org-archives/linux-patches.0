Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6EE3EC827;
	Wed, 30 Sep 2026 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783503; cv=none; b=ULOd1UYINMGU6soQL8vguloMdQj8gmCNYa0KX8qqPt9+NlWoF1Nhbcs7+9uGjamw+OaiLxm3dZI0qMN4mF1eTfGzUqG7/VCK8DifcO2aaCAmdxeSqHh3pa9zjqQn/jw/6voSe++AT3Z+zx/pGeMpbBHPrIN3zf5L4WmI+3kqrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783503; c=relaxed/simple;
	bh=IBMW4Cm1pNIrjfppPePJlsZ1sRGZvBzUfKfkGTrUuOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBnhXviDVVVd4onz3OxoB2g4JDmZr8MesjoaD8guCABct5S+kvyq2likljep/iY0gGhUN8ZGS/TKwI07iLlCSSPX0OQ/UU6OqJHilg8fXmVEJEO8yaTo9hrA6zXnv9d7wvxsWERCFAitpMrE+PQSutxdbQ/vjSGMGkO+wsqbjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIYqlxbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIYqlxbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801F61F00898;
	Wed, 30 Sep 2026 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783498;
	bh=hZnHDM/IfHZ+VTtoCzQen3ebHu3x4aN9V6Kcxz1WwRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIYqlxbANZjzuf8KSHTNAPeM9WAz1dQQYS3uxRtTb4q3vKQBSXYUHhSjAPbV05zFG
	 BXcoWYHyEZQnbY9K5qDx4ZqXOxR8f1AYgfIOpoYeKyuVIpe2NyCbM0mHuxVjgNG9OH
	 vh3EM2N4lv73rZ5h/CPAFL7nsyYQHAZHqtK2NZaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Allison Henderson <achender@kernel.org>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 420/595] rds: ib: use rds_conn_drop() on protocol version mismatch
Date: Wed, 30 Sep 2026 17:25:13 +0200
Message-ID: <20260930152356.711371525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit f97d8c7bab7843631206a114986c9059da03efeb upstream.

rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
conn->c_cm_lock held.  When the peer negotiates a protocol version
older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
rds_conn_destroy(), which is only safe in the rmmod path: it
synchronously tears the connection down and flush_work()es the
shutdown work cp_down_w.

That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
the very lock the event handler still holds, so the flush never
completes: the two workers wait on each other and the RDS connection
workqueues stall for good.

All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
DISCONNECTED) use rds_conn_drop(), which marks the connection
RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
it here as well.

Fixes: f147dd9ecabf ("RDS/IB: Disallow connections less than RDS 3.1")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Link: https://patch.msgid.link/20260911073436.3542080-1-ljp1205831794@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -141,7 +141,7 @@ void rds_ib_cm_connect_complete(struct r
 				  &conn->c_laddr, &conn->c_faddr,
 				  RDS_PROTOCOL_MAJOR(conn->c_version),
 				  RDS_PROTOCOL_MINOR(conn->c_version));
-			rds_conn_destroy(conn);
+			rds_conn_drop(conn);
 			return;
 		}
 	}


