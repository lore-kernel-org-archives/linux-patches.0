Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948433BC4FE;
	Thu, 15 Jan 2026 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496947; cv=none; b=jEiGDus1vKeJP7/hAI872mtYbWtYthn6v3Veitmu5dm2h1rvJSpHQmNtmdhLvmioKl2zwFxk6VwMkXi904ljAE5CAT5DhM5UHt3gZvp29ull2j5fSdDmlc1ex324RK9/m25JPzTGLdyzNqKc/F9Rc30e6HxZTSweObwMJb2hLFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496947; c=relaxed/simple;
	bh=XhtcY81H5CMUo1Yx5BRZGz9zGdgSOnl9Zqjo0N7hfdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCgNKWMQPUZRLh6XrFqyI9Aw8OnDYmVe87K0NfJeCvifPE7F3nVFsNhvwo57/cvS1Qt7t4GM3ENxEHTL5jEyFa+XkY7x7gwdww9Mp0SHNDiVfO80aZaL4aVg6U5QX+8eBFmDFw+zjiz8DSKZc6oDsiFbwXqlhoLotPGx80fKC/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k34IcU2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k34IcU2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C39C19422;
	Thu, 15 Jan 2026 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496946;
	bh=XhtcY81H5CMUo1Yx5BRZGz9zGdgSOnl9Zqjo0N7hfdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k34IcU2oVKWwOjuvVLRIkVclBAdUT1mNSZCgd+qcGMotj9nbrWOxUxms4cqbjUuuq
	 zJQdbDYCwxRK0UqjFg5rw3SOTzr2ox5HmNxKXBvptHrKixIvVJr13osYxy2xDAJA41
	 mlewsbRJsTd/FG/T3hA8op39bEOPtGw3STOAF8Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 70/88] NFSD: Remove NFSERR_EAGAIN
Date: Thu, 15 Jan 2026 17:48:53 +0100
Message-ID: <20260115164148.848284271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c6c209ceb87f64a6ceebe61761951dcbbf4a0baa ]

I haven't found an NFSERR_EAGAIN in RFCs 1094, 1813, 7530, or 8881.
None of these RFCs have an NFS status code that match the numeric
value "11".

Based on the meaning of the EAGAIN errno, I presume the use of this
status in NFSD means NFS4ERR_DELAY. So replace the one usage of
nfserr_eagain, and remove it from NFSD's NFS status conversion
tables.

As far as I can tell, NFSERR_EAGAIN has existed since the pre-git
era, but was not actually used by any code until commit f4e44b393389
("NFSD: delay unmount source's export after inter-server copy
completed."), at which time it become possible for NFSD to return
a status code of 11 (which is not valid NFS protocol).

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Cc: stable@vger.kernel.org
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs_common/common.c   |    1 -
 fs/nfsd/nfs4proc.c       |    2 +-
 fs/nfsd/nfsd.h           |    1 -
 include/trace/misc/nfs.h |    2 --
 include/uapi/linux/nfs.h |    1 -
 5 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/nfs_common/common.c
+++ b/fs/nfs_common/common.c
@@ -16,7 +16,6 @@ static const struct {
 	{ NFSERR_NOENT,		-ENOENT		},
 	{ NFSERR_IO,		-errno_NFSERR_IO},
 	{ NFSERR_NXIO,		-ENXIO		},
-/*	{ NFSERR_EAGAIN,	-EAGAIN		}, */
 	{ NFSERR_ACCES,		-EACCES		},
 	{ NFSERR_EXIST,		-EEXIST		},
 	{ NFSERR_XDEV,		-EXDEV		},
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1354,7 +1354,7 @@ try_again:
 					(schedule_timeout(20*HZ) == 0)) {
 				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
-				return nfserr_eagain;
+				return nfserr_jukebox;
 			}
 			finish_wait(&nn->nfsd_ssc_waitq, &wait);
 			goto try_again;
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -201,7 +201,6 @@ void		nfsd_lockd_shutdown(void);
 #define	nfserr_noent		cpu_to_be32(NFSERR_NOENT)
 #define	nfserr_io		cpu_to_be32(NFSERR_IO)
 #define	nfserr_nxio		cpu_to_be32(NFSERR_NXIO)
-#define	nfserr_eagain		cpu_to_be32(NFSERR_EAGAIN)
 #define	nfserr_acces		cpu_to_be32(NFSERR_ACCES)
 #define	nfserr_exist		cpu_to_be32(NFSERR_EXIST)
 #define	nfserr_xdev		cpu_to_be32(NFSERR_XDEV)
--- a/include/trace/misc/nfs.h
+++ b/include/trace/misc/nfs.h
@@ -16,7 +16,6 @@ TRACE_DEFINE_ENUM(NFSERR_PERM);
 TRACE_DEFINE_ENUM(NFSERR_NOENT);
 TRACE_DEFINE_ENUM(NFSERR_IO);
 TRACE_DEFINE_ENUM(NFSERR_NXIO);
-TRACE_DEFINE_ENUM(NFSERR_EAGAIN);
 TRACE_DEFINE_ENUM(NFSERR_ACCES);
 TRACE_DEFINE_ENUM(NFSERR_EXIST);
 TRACE_DEFINE_ENUM(NFSERR_XDEV);
@@ -53,7 +52,6 @@ TRACE_DEFINE_ENUM(NFSERR_JUKEBOX);
 		{ NFSERR_NXIO,			"NXIO" }, \
 		{ ECHILD,			"CHILD" }, \
 		{ ETIMEDOUT,			"TIMEDOUT" }, \
-		{ NFSERR_EAGAIN,		"AGAIN" }, \
 		{ NFSERR_ACCES,			"ACCES" }, \
 		{ NFSERR_EXIST,			"EXIST" }, \
 		{ NFSERR_XDEV,			"XDEV" }, \
--- a/include/uapi/linux/nfs.h
+++ b/include/uapi/linux/nfs.h
@@ -49,7 +49,6 @@
 	NFSERR_NOENT = 2,		/* v2 v3 v4 */
 	NFSERR_IO = 5,			/* v2 v3 v4 */
 	NFSERR_NXIO = 6,		/* v2 v3 v4 */
-	NFSERR_EAGAIN = 11,		/* v2 v3 */
 	NFSERR_ACCES = 13,		/* v2 v3 v4 */
 	NFSERR_EXIST = 17,		/* v2 v3 v4 */
 	NFSERR_XDEV = 18,		/*    v3 v4 */


