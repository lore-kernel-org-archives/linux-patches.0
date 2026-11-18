Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032530;
	b=DeszEqz9ZoM1nqpTsEw0Z8zZ1rz2M6VP/v/X4ny4dhirx1SZT2ol9kSwmlh/LKFhgLqd
	 emIPP8/gY17amzFPqP+qVrA+FbMoy5wEnCqk4hXiBejLgNKoovnrYRFve+ci9EcilC71V
	 F30DzYi+7jd5NRZ83TQ082E+9dHybyR5RGtstVdSyrS8G7ptHZbruwQeH1J4LjgJ90kXA
	 CPsOLDxUuXD0KQTx4Bmv5O/5OmxmdnZzWLVJ5H1oOaS1X1EbBCB+DN2PkzTxPTG79UaeU
	 XrsVWh5Al8cn07whaIQqjT3C4rqR5jHWC4Tztu+3Z33ra8IUniWGTKdav8i+LuGcjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AgUsoW8DVd4KYlTMNkKwXD5nWMc2TYcLPHHhHsMgSU0=;
	b=rv//eQSoBtwd2FRxrM6h9zauW0ZI6Y/4Ohr4bVQRHdFc2YGNSf6p5gqnAlAlcTw1JjHh
	 oeQim/L9+Im1fjCmTGgT/3Pun900v+hADYlfwkKYTmXwTGFP7Il5BhUhWKPqguwMTfFcq
	 9FQVyfYuizjvM8HFO+k5hMpq60HAIxiadwjkIO2NFFveHqy0JkQJq78HYeFr4KJhLbP5q
	 oEs1QNbdBjvOQMijVNotNsA8JqyM8p9EXEAARig3Mus0b9PX7OTtNftmxkfk9DtJ145mK
	 4vPUKUm9eONlX7EFFK9Cu+d5RJO2NGXMQJMG8HL1ntor+byTnYqvwCz4I3ZN2MwK/dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgKsWXr5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F437606A31C;
	Wed, 18 Nov 2026 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgKsWXr5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53551F000C4;
	Wed, 18 Nov 2026 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032530;
	bh=AgUsoW8DVd4KYlTMNkKwXD5nWMc2TYcLPHHhHsMgSU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgKsWXr5HkM8Emq40wkmW0zgMpU7dpo3+ss9BACDOMHuhNfiMbCCr+YXd26luQsfi
	 wk8d7ri8eOI9cQUmvQS2v9x+fd9KtArWgNzxkEtoOk69MgzpNUZUA/qZlTrfK9Q2Me
	 tpBMX6+GD9Ik4meQMnZTChU8dwHz6kjMI8FkE6BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1417/1756] pNFS/flexfiles: make pg_init retry loops killable
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150105.592297347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>

[ Upstream commit fde27289503beabe7e0856dac164a5ced4be0342 ]

When a task is killed while the pNFS client connects to a data server,
nfs4_pnfs_ds_connect() fails with -ERESTARTSYS. If the layout has
FF_FLAGS_NO_IO_THRU_MDS set, ff_layout_pg_init_read() cannot fall back
to the MDS and retries after an uninterruptible ssleep. As the fatal
signal stays pending, every new connect attempt is aborted the same
way and the task loops forever without returning to user space:

  # grep -E 'SigPnd|ShdPnd' /proc/156021/status
  SigPnd: 0000000000000100
  ShdPnd: 0000000000000100

  # cat /proc/156021/stack
  msleep+0x2e/0x50
  ff_layout_pg_init_read+0x267/0x310 [nfs_layout_flexfiles]
  __nfs_pageio_add_request+0x1c1/0x480 [nfs]
  nfs_pageio_add_request+0x21d/0x2c0 [nfs]
  nfs_read_add_folio+0x143/0x200 [nfs]
  nfs_readahead+0x204/0x290 [nfs]
  read_pages+0x62/0x230
  page_cache_ra_unbounded+0x136/0x180
  filemap_get_pages+0xf2/0x350
  filemap_read+0xd5/0x320
  nfs_file_read+0x6d/0xc0 [nfs]
  vfs_read+0x24f/0x3a0
  __x64_sys_pread64+0x90/0xc0
  do_syscall_64+0x5f/0xe0

Previous attempt propagates the error from nfs4_ff_layout_prepare_ds(), but
only ff_layout_{read,write}_pagelist() look at it. The pg_init functions
test IS_ERR() and retry on any error.

Check for a fatal signal or an exiting task before sleeping in
ff_layout_pg_init_read() and ff_layout_pg_init_write() and fail the I/O
instead of retrying.

Fixes: f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS errors")
Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 06861f9536502..83e78513e2ef1 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -854,6 +854,20 @@ ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 	return ff_layout_choose_best_ds_for_read(lseg, 0, best_idx);
 }
 
+/*
+ * Wait before retrying pg_init. Returns false, with pgio->pg_error set,
+ * if the task was killed or is exiting and must not retry.
+ */
+static bool ff_layout_pg_retry_wait(struct nfs_pageio_descriptor *pgio)
+{
+	if (fatal_signal_pending(current) || nfs_current_task_exiting()) {
+		pgio->pg_error = -ERESTARTSYS;
+		return false;
+	}
+	ssleep(1);
+	return true;
+}
+
 static void
 ff_layout_pg_get_read(struct nfs_pageio_descriptor *pgio,
 		      struct nfs_page *req,
@@ -904,7 +918,8 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 			goto out_mds;
 		pnfs_generic_pg_cleanup(pgio);
 		/* Sleep for 1 second before retrying */
-		ssleep(1);
+		if (!ff_layout_pg_retry_wait(pgio))
+			return;
 		goto retry;
 	}
 
@@ -943,7 +958,8 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	}
 	pgio->pg_error = 0;
 	/* Sleep for 1 second before retrying */
-	ssleep(1);
+	if (!ff_layout_pg_retry_wait(pgio))
+		return;
 	goto retry;
 out_mds:
 	trace_pnfs_mds_fallback_pg_init_read(pgio->pg_inode,
@@ -992,7 +1008,8 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 				goto out_mds;
 			pnfs_generic_pg_cleanup(pgio);
 			/* Sleep for 1 second before retrying */
-			ssleep(1);
+			if (!ff_layout_pg_retry_wait(pgio))
+				return;
 			goto retry;
 		}
 		pgm = &pgio->pg_mirrors[i];
-- 
2.53.0



