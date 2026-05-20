Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB93546C8;
	Wed, 20 May 2026 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299131; cv=none; b=nqFBa+5uhLuCGP9TMrT1e52C1cv6ybODHYQsfocn9nbU5PO5KHGCOfLoJyJKgFzQ/X5bi51eRc6RvGqcEZssogiF2exQ0Yl1YjOcRXvxLdsy61AzuHcDbzoPr7Rl3Dz5L3AS4SSmUsW/0C5q/nPDEbXt9ZNwqNmMX/LDJielJbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299131; c=relaxed/simple;
	bh=rFdzNKf0EAfrJWcrRrkTPfduyNRI721JYCkDGuMQUsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI7RUM4/spXO0WRolx96QqSAL1o2K4StV0z0wXt9iiqI8O7i62WKqAxPRZezGH0HAfdFDQhSkQ0UToLZ2Lo/BFalAzz/O+YElcVszoCpZYOm1FSBRO/xPIa5yHFt82QPm5fRC2zDlkPeICnofPpJmbTDG4GaATgUjYFTyOnAtlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHXs3i3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHXs3i3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD461F000E9;
	Wed, 20 May 2026 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299130;
	bh=9A+E1BKuYYrTZlk7q9ztke51O8w3N7EjYuw/aS+dRMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHXs3i3Iwv5DJIbi6+St8A+hTn29nD+NoIeB38O98q6Ke7Hgj7rLab8iQH2Xchh46
	 ktO8avBT8LX5zgjMnF4JCUN0Q500m8YzPv+MBfrLL2ra+RjTGziX1LBU76eoTDpQA0
	 l8YhbiPRvTxVKiHMdEcGO6YBvB122d7BM88hSBps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 675/957] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Wed, 20 May 2026 18:19:18 +0200
Message-ID: <20260520162149.176411628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index b4ef62b9e660c..a03132adcc1e5 100644
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



