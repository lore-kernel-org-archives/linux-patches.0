Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99485341ADD;
	Wed, 30 Sep 2026 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796234; cv=none; b=Jlv8ZQvuaPCxtu9fcWebmQFvZ+cc+aupHwEHFsmWRburxpaNyf5c1UzEAWtdsuM5pcdqWmyCOVGyxbklMsFjyAzx0G8fKuopOziErmm3HS+/q+9r0F+fs77zqyT0bwGwQUzcdwDxYv0OoQqMCoMEXwvWsIPHJwHOtgujcNPt0yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796234; c=relaxed/simple;
	bh=ubtgot5u8613bxFJj3aK0JgR0UHYO6Y6fzQrpF5bsn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhZT98xLNfOyttAbjYOX9SH5GMf/2QaX6HWVYcsTMeGxCStBVsp/rCmaFcKUpGwpbdtKNwqI9dxPq9ym8HXCHYqFQRJ6cU4gjnlIPZHsobjNg4o+x9os5VnQr/gSYmxsRonbZUMnXtftS8rlOD6y1vXJLrO1Q5tFrr+M/q76X8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ2wkVjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ2wkVjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EDB1F00898;
	Wed, 30 Sep 2026 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796233;
	bh=pB+7lV92/EfUs9akXpMuMu4h2GSGM9aBfBea3WiE9rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ2wkVjUXYh3uZxKiDmWHwRAO3NyytVI8wnslihtjWUIUvQoFiZXUPkrYNep792JN
	 O6jJCNAFPQPKpu/uXS27pF0NkWL1DHaJvtUgkQe5Pv0lQgpvTN/Tk3mtkcGBo8Gutm
	 4tH++UnR1wT4mHwlL6DYYljbQiFKcIiIIIe5otMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Allison Henderson <achender@kernel.org>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0840/1193] rds: ib: use rds_conn_drop() on protocol version mismatch
Date: Wed, 30 Sep 2026 17:25:24 +0200
Message-ID: <20260930152452.905725830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -115,7 +115,7 @@ void rds_ib_cm_connect_complete(struct r
 				  &conn->c_laddr, &conn->c_faddr,
 				  RDS_PROTOCOL_MAJOR(conn->c_version),
 				  RDS_PROTOCOL_MINOR(conn->c_version));
-			rds_conn_destroy(conn);
+			rds_conn_drop(conn);
 			return;
 		}
 	}


