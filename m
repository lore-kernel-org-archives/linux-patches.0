Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE01FBEA6;
	Sat, 12 Sep 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230931; cv=none; b=OLnSabx97d/x/euKtf52ZkNedc+C1HDZreMokblpjOAkVdzfFKyQY3vCzmvqdsRj1nkH1kuuIleynvj/EXLrVvnpIsCzQCzxofgzQ8c+yRVxD+VReKP2ZjxrcMej42zkvLVNp9PInymEE3RI3S9iRI+uVCeu6NogrKWm9pF4n5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230931; c=relaxed/simple;
	bh=QzTeSFtFboduvYNwwLPmlyJDnrZF528TS9aVIas8vAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0e4V5XaG39rdXSCllKqYYEevtIuRHvFC0ldZ3ZY3MQFO4tC1L6QnUwHgyk2G0H1B1uky+6y+KKdm1iaVn+2thMu6F7+/R8q/zT53RKjf4kX6IsuMwhcNq0pBRTtE2TwmzdK/rQx/+FG0KIIPvtEmkEc4e0Zd4alRXH+a5LHRvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdOyqExK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdOyqExK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726301F000FF;
	Sat, 12 Sep 2026 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230930;
	bh=HSEzrrgZdeiTwRCfVVjVlsf0GMVaKy8AS9cnmeHYMVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdOyqExK+6arBqoRAtLgBkdaevdH3N3o69/7jLVj4zANFnXDJhuZ5itspGeeQT21y
	 5ipM9MtKtHYNMXZcowFx1C9qhgW6w0N8Wqr+1k7NJesDGtgu3e69deCRcnWdTQ5UlQ
	 otHePHlp0Tv5TDqus3CG/4QuJn93WKuypc4/fZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0895/1191] RDMA/siw: Introduce siw_free_cm_id
Date: Sat, 12 Sep 2026 09:00:23 +0200
Message-ID: <20260912065608.340793914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 08456d4db73bbb3fcaa0d63252ea2399c65297a4 ]

Factor out a helper to simplify code.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310091656.JlrmcNXB-lkp@intel.com/
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-12-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a93949718259 ("RDMA/siw: Fix use-after-free in siw_accept()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index dc679c34ceefa..c665e134c9b1b 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -361,6 +361,15 @@ static int siw_cm_upcall(struct siw_cep *cep, enum iw_cm_event_type reason,
 	return id->event_handler(id, &event);
 }
 
+static void siw_free_cm_id(struct siw_cep *cep)
+{
+	if (!cep->cm_id)
+		return;
+
+	cep->cm_id->rem_ref(cep->cm_id);
+	cep->cm_id = NULL;
+}
+
 /*
  * siw_qp_cm_drop()
  *
@@ -413,8 +422,7 @@ void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
 			default:
 				break;
 			}
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
@@ -1172,8 +1180,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 			cep->sock = NULL;
 		}
 		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 	}
@@ -1704,10 +1711,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	if (cep->cm_id) {
-		cep->cm_id->rem_ref(id);
-		cep->cm_id = NULL;
-	}
+	siw_free_cm_id(cep);
 	if (qp->cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
@@ -1885,10 +1889,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 	if (cep) {
 		siw_cep_set_inuse(cep);
 
-		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
-		}
+		siw_free_cm_id(cep);
 		cep->sock = NULL;
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
@@ -1918,10 +1919,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 
 		siw_cep_set_inuse(cep);
 
-		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
-		}
+		siw_free_cm_id(cep);
 		if (cep->sock) {
 			siw_socket_disassoc(cep->sock);
 			sock_release(cep->sock);
-- 
2.53.0



