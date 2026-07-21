Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6175544AB62;
	Tue, 21 Jul 2026 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670625; cv=none; b=k+BAzur5lQWTeyeetqQ2TjVHYdE8d6hm/pX/HnpgTfqoL4y6MrtrJ+INqkt2mXmnthokORKO+LzhA8WKOvszgRbVWnOKRb4cmk3nmNzNNPiesWmKowxQ3Y3T/04ycUpFi7UbmFaEBgM03WRcll52qQrEGYeOYYOUdU2pbJroyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670625; c=relaxed/simple;
	bh=i+8NtfSJDdkcxmKDmX9hv12m30DxIoTJ4VuwVxyhhHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKWVKVKM2NwZqghPnyjr5QWNx79Jp7P8IjlSAuUw6OmZNg+XHYXnWwgJ3McG7Ez5nugT2A7BAh6cxmf4xRWkfgGLlQnRU5xDsWWIDB/jDh82vADXHRPmY/mEMoTEvkm1rYKR55v9f1fe3ex4rOkd9xOAJnJoMKtieCPobuGWSxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u63eInAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u63eInAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C78D1F000E9;
	Tue, 21 Jul 2026 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670624;
	bh=fXxFWh3wvjUSbyKu/UV/IN5cK4+GocRclWktOAue9H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u63eInAmvCsVs8+85us84WKBUa4NPvVRPDsUM4eh0OYFWNn1SdPhNPLO3rJFN4tMc
	 fcZF2+DRTxS7Fes43v87Ejs5lSqWGQuumGPxlPyrpRvBs/6I9Pm0UQYcHPu5nqzory
	 XtT+WU/4CM/0u2oheOJLTmVqeI7cODgBEw1C7Bng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1003/1067] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Tue, 21 Jul 2026 17:26:44 +0200
Message-ID: <20260721152447.004182795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
Stable-dep-of: c1016dd1d8b2 ("ksmbd: track the connection owning a byte-range lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -40,6 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
+	ida_destroy(&conn->async_ida);
 	kfree(conn);
 }
 


