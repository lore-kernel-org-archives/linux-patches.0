Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D5D418368;
	Wed, 23 Sep 2026 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173455; cv=none; b=og31w6rg1fHuzuTvIRQ3KU+5MDSdfseNyE+9+1P3vXENpIKcHXibLfJ7B+5b5Be7X+uUdTjKttJWX2xsGOrlZsPv+ar5XIQLNh/fesGO/gj9zYLKXmIZ6Zp1aeRN+w9u5yRq10BMC/iofak7EZz4nrZmY1XyplUFYeQWn2upmqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173455; c=relaxed/simple;
	bh=Lopddxt9eJfFMWqZcba/0rFYwi/PWjABdAwJqHDp1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOQWdhmLwjwvb8UEkPV4Lx/ZvI8ohFmPZ+LWq9ik1wNCRpbj+fXrO4YJAO87aNwnXG0fol5Zq4SKK+e8qBPugmfNEkYYDUKgqlQbPr+tahofaY5bCOa/g5MlOHlrJdln/OGNtUCjD00WEng6PPrBzXkUtjCo6nXdMMBdSwVVRWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oT4RcPTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oT4RcPTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C3B1F000FF;
	Wed, 23 Sep 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173454;
	bh=6jSgkxacLuAh1GV3lStZbGrJgbHT2+BKxmI2/Ubudj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oT4RcPTBsT0tzUQZXlXOkNa3MuA/1om59M4UxiFHHwJNHG84IiTmrbjqgXYYrVoaF
	 3oAFLLXUp4wpVWYmrgKEmB4vk3IQi8Tm5UsEr2HeaiGHvLC9XqjYIZu62FG5B6yiOt
	 gVnPa2Y9h2PDkTlINNghm1Aqb4YkvpDSY8cO6VFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Allison Henderson <achender@kernel.org>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 250/438] rds: ib: use rds_conn_drop() on protocol version mismatch
Date: Wed, 23 Sep 2026 16:04:31 +0200
Message-ID: <20260923140651.249421878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


