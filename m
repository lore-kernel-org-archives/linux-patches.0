Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF17383983;
	Thu, 30 Jul 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427335; cv=none; b=RDj4BMYvaoS1fWdu0dUdzFkIbC3F1CAcxMCESew6BBD5xofEdP6VELWLK9UvLRSwJwmklgPW8V8ysEiw539oXUq7mR3FzAFUP6PBS4w1fkpqDeP65XHpphKxBsMx9/Pxlw7f3OiQJa/X0MPfZIJBKuAjWejFe4uqvjx7FZAZqD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427335; c=relaxed/simple;
	bh=xGgrFoFhKP+xGicJJUfk7CqwgmIzH5cCeqZhE/pljUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krjbWU7W6gQuaGIObvNnfy8HPOi7SkpSbjYUJbRq6SRpykBXNkPVJQHlE6vJGMYFpy/kzJJacBpceq44ZFvDLgvG3v9/f0TM+dI6dsyc1ZZtbGb5BVAuowbsNsVrAs57hQOCx6fL5ZSN/7FAxMS6wuKSG/1TlZt7CRDfS/CyZ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwW3xFvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwW3xFvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F4C1F000E9;
	Thu, 30 Jul 2026 16:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427334;
	bh=6tPq8ZbOZDW411AB9eZGuaenuQMfvr54Oe8RLzIADtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwW3xFvuTuP5MlEFxE9FRvwyCEqaSiAJz6rBMU8AQHsWv+pxy9q26y8szKf/mYQT4
	 4UKu4E0h6QGX3yo6qFnWsSlqlTGLt105X0ouX3fKcZVfP3dXw8J0kH2MIfoe7HSZv2
	 E/WUP56XIk2KcPxG0BqSABxDww76ZdIIZ07vcfQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/484] ksmbd: pin conn during async oplock break notification
Date: Thu, 30 Jul 2026 16:09:47 +0200
Message-ID: <20260730141425.402861673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 82a7709b3e9ac8..109bb71d06adff 100644
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



