Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4153A16B6;
	Wed, 20 May 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296623; cv=none; b=CaEk/jtoc+L5m6+T2zsT2+0Hd0nJFSuoNE/YIrMQsle6H3N6tu7Tw1LptaZ6i2JyVQ9Mu292lZbI4H+68f1cBkskPmVOxpdf2pgwRLDEOl7TDj+23oiDVwxaZMjXGUCMpz/F6OEieuLVlAdGjxZB9byV/EOGUyj+ZQ0W9mz2Jfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296623; c=relaxed/simple;
	bh=h/lqeavsH0csq6gAfPKNDLaX46SX0Kj0H7PbFMw2wa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmUMhQsX6kDq/RFEotOWj9mRQp2gUHnH6lvYs6PuNBjdQticWtDhzftX4rRbEHqZTlO/bKrjlh3yt+Yi6Q6CigDUCV9GYb50CU3XsFHCNyIiMLjwWWJJIZUjAwDinpvU96i9FpoRx19nCpOJ8HXhdzfnUShOgzu5MmlLdsl/PHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boCWO7t7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boCWO7t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4E1F000E9;
	Wed, 20 May 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296622;
	bh=+BY00HR6VAW69g8m2narP1PyzWo0zPzluyMh1QrLopE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boCWO7t7pRuUIwXIj+HNOCAN43zHI6U9e3/1zkvxQpOik5iNE7WA3pccj4wDNNAOB
	 3N1nM/HPc0g1nECDSmGjhr6O4fx2TK1pgbdiHOX7Dx1h3LHGPazXZbkiLdZFmVrAYa
	 JeNYc2w0NJpVJBeD4/kRZch9FyyweaYh+ptM9E80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0827/1146] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Wed, 20 May 2026 18:17:57 +0200
Message-ID: <20260520162206.947560579@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 9d7e8a0812721..fb9918e5d9871 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -98,6 +98,15 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
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



