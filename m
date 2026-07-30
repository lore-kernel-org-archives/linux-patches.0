Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4EB3C1D70;
	Thu, 30 Jul 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425544; cv=none; b=N5OMi5n0B6TIOqzhlpnLkWACZ7wGwM3nVmqPnhRqlUk8tx2p3KH9cpwf84wce/epznMU8dGKNB5jYCz/okE1w+gQbo/S8W4aMCFemr0shovTmzesde61i7CAryv7LAv0fZdP5zjxoZkch+XOi4sgYfLTkIVeoa6U63gzf98PD/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425544; c=relaxed/simple;
	bh=mMCMhej5X51LfFuEvgkjyTsoiIgo3sY+auSU7AtyGTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alq0uT0xngDoeqKmbceziycKDqIAaaCkcIHwHCyLUfPowmwaLQIooiEpccY3uhp6hDPA4loxvQ5P1CPDaY+OH86syjOMqK2tSQSKmdeqs2xtc8lRWIa/2NB4ZC2jFvxhV7kPxYePWEimjCqDbBBK86TEyMfHPsNFVVqcjdJVQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9iC4yuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9iC4yuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15361F000E9;
	Thu, 30 Jul 2026 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425543;
	bh=/JP81geVVGRDv9leQ4G37QMe94Kw/irktUYmZHRTHWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9iC4yuWW5yjcb07dOZ7210F03tXLAF3Afhq/eP+MthxKAQcJZ+ogQndbp+TsuBeH
	 dnhyyOsnpX3SjOvwQ8cAtsBkz/tChWC/7rgxObD18lSI+1zBRSVGTuNOBu3fGHw3/Y
	 z0tDLwOE6LNS26G/pdkRcsev/OtCPCxBxP+nDS+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/602] ksmbd: pin conn during async oplock break notification
Date: Thu, 30 Jul 2026 16:08:19 +0200
Message-ID: <20260730141438.240650128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit aa5d8f3f96aa11a4a54ce993c11ce8af11c546f9 ]

smb2_oplock_break_noti() and smb2_lease_break_noti() store a ksmbd_conn
pointer in an async ksmbd_work and then queue that work on ksmbd-io.  The
work only increments conn->r_count, which prevents teardown from passing
the pending-request wait after the increment, but it does not pin the
struct ksmbd_conn object.

If connection teardown races with an oplock break notification, the last
conn reference can be dropped before the queued worker finishes.  The
worker then uses the freed conn in ksmbd_conn_write() and
ksmbd_conn_r_count_dec().

Take a real conn reference when publishing the conn pointer to the async
work item, and drop it after the notification work has decremented
r_count.  Apply the same lifetime rule to lease break notification, which
uses the same work->conn pattern.

Fixes: 3aa660c05924 ("ksmbd: prevent connection release during oplock break notification")
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a019c4496ae433..ff0dbf3f8cbf49 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -705,6 +705,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -740,7 +741,7 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
@@ -814,6 +815,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -853,7 +855,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	memcpy(br_info->lease_key, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
-- 
2.53.0



