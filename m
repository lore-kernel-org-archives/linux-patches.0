Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108D43F0B5;
	Thu, 30 Jul 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423809; cv=none; b=FkeesXBjWd087NO3RSCpgazYbrL1LrXPAJaIDPaLxETKoDQTyf5dubY3LPDq4f61JvGwJH/MBh+C+UzoiYSHMHCC+S0U5lVTStbBPrpE4Ng6HrHDaGteq+TKnDLZHWhGQk6chA5EL+1sGCNC6Q2CUmz6/LVNorrNQ8/dkUwYtuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423809; c=relaxed/simple;
	bh=uMjhr1ScrKHk1DffmrSHvZfNPyGvyWZRVr5NI9iKE4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKUwwsAyYWw9P8VymUTy1Ntm01iAN345Eo2U5SMnxSJy0vZovj8c12KMPcNU408cAYIFve9rI7U1PLt3X15XEpCu6U4tsL/A5iwRl2i61V2x4Adv+Ze5Q4ixti67/nO3ba03lL0yRFAwfebJWTEfMhxpe5Ju5B0cxTTqFF0v52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkZj6vaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkZj6vaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222DA1F00A3F;
	Thu, 30 Jul 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423807;
	bh=L3heQyeFv812KJqdTMMfIli7QczhlQ1SrZJDX7WxKyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkZj6vaE+m25tIry5flk6B0fgHcp98M2ng59FW0IWk0GKrTtGDtcyBvqgIr/RQj2n
	 szdjTVdZFnhchLFbnO9DqqwuZWzfUgROmnmDKrS+PbZ9NpFGLGwh8VJdivZ+JsVR9S
	 ddtNjwiNo5xhPyOrVcpm1+VBbBC1kGONhi9uYFUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/675] ksmbd: pin conn during async oplock break notification
Date: Thu, 30 Jul 2026 16:07:39 +0200
Message-ID: <20260730141447.886702470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



