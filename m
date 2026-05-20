Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9AB3E277C;
	Wed, 20 May 2026 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302642; cv=none; b=EkdLAW1gC6P3ixnIxEmHTnUb3DKyqM1MUAfdDY9HGQGmtSY2rZjKlD+PX1WUHHqeCetosFW2xRMUy2i2b46Qombi48mb4MZHA27P/MO/e3J6fEYxDqayglMlZZpWNiRER/kSyUUMEIzc323QhInW8U+aD0uTTMua7npHaKX3S4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302642; c=relaxed/simple;
	bh=vw9FTM+4TRYS302n5sLM9NQjKsaejC/FyXsweXoWrfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHMx7c19mu5Wxierlpm/2vd5QMTGbxEB+L58D3fpcVX42V+qjV9NG0My0zDY3D3mb/gvY3Mr7kcwjUiaNx1/xaC6899WQe3rhy6vaHFZMAslc1P5j5dGOhW57t0ClnNkSGbnesbtka2JqXKAj4FjrMv8iiZGOJo+yy7blTtdLkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjoAaK36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjoAaK36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FBF1F000E9;
	Wed, 20 May 2026 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302640;
	bh=0awndeEYSxFqf3q0IPn6tGpkEWKemesNF45NhnePZug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjoAaK360kspR946haLjRlOQzPo4JvKE6VM2raJzq8Xea6rVosm3QokTGQFI0z7iJ
	 CBAoQPxIM2zkYux+ytw1FVmE/ihneJ3o65OeEvhZtpQBF+UC3LAoj7JD5hyOUSuLda
	 bigt6YD5T2siUAqK1JyLmdGAsQGhd3RoanzKuCYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 342/508] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Wed, 20 May 2026 18:22:45 +0200
Message-ID: <20260520162106.044249284@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit b32c8db48212a34998c36d0bbc05b29d5c407ef5 ]

When per-connection async_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from the connection teardown path but no matching
ida_destroy() was added.  The connection is therefore freed with the
IDA's backing xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
connection is freed.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index a5209abb004a4..bbb0be5524dbe 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -41,6 +41,15 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
 	if (atomic_dec_and_test(&conn->refcnt)) {
+		/*
+		 * async_ida is embedded in struct ksmbd_conn, so pair
+		 * ida_destroy() with the final kfree() rather than with
+		 * the unconditional field teardown above.  This keeps
+		 * the IDA valid for the entire lifetime of the struct,
+		 * even while other refcount holders (oplock / vfs
+		 * durable handles) still reference the connection.
+		 */
+		ida_destroy(&conn->async_ida);
 		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
-- 
2.53.0



