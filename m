Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B8438654F;
	Sat, 17 Oct 2026 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253231; cv=none; b=N4xznnKaK7+nosvZ0N5vGX62OOxO0ByizAaKEN9Z82foSQYe6QaEiRj45E7NBx5IqXeEM3VJCg9tOqFcVMpcRqAFfPKm0rjpx/uO0AjuD+wuNujmsaBk4jsM8fo1UQjzgAG6AO/z392nFvUVPgeuUmPBiXoCZpi3bYjMNI7LF94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253231; c=relaxed/simple;
	bh=Fcf2qmmWaggNTW4Y7djvEPaKb2UMhcxZJ46JwZ813do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXCs7KEzm+smGHYl109Vny/vJUsds1uUiaGZNfRmUd8eUvL4WvYIZT7hel/IyLPVGmKQfHERBkxvyOxfI/ae2u6+Tw0YdCEY+omiZyzuFbdWc1wq9n+vbI5LnLbYnk5S9tNOuqvvfYrWUfJ1jQlZ+H2acL2hSPiNvtuqfyjPw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlQC8XMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlQC8XMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAEE1F000C4;
	Sat, 17 Oct 2026 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253229;
	bh=MukK0ByqVc7k3vB1PVH1OzJa2eLgoY7trWVFbT7C//w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlQC8XMu64olTfm9CLJRiTcDV66dlkRgFQMpuY2OX3ahNtNwUIvCPJc5AkilduMla
	 uOucYfzhLTI7SD+ytL06U2rkiIOoL7vfanLA9wIhqyyHQWQiAIquX3ZJXtNeh4D7a+
	 SU5gqdxqVjW+xVl3qrNN4LTtzIqU/TItaZOzPibM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 050/869] smb: client: get rid of bounds check in SMB2_ioctl_init()
Date: Sat, 17 Oct 2026 17:48:11 +0200
Message-ID: <20261017160038.301967239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 9f544d26b15bfc52cf3a6e6a655f759e76c1a01a upstream.

smb2_set_next_command() no longer squashes request iovs into a single
iov, so the bounds check can be dropped.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3357,15 +3357,6 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		return rc;
 
 	if (indatalen) {
-		unsigned int len;
-
-		if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
-				 (check_add_overflow(total_len - 1,
-						     ALIGN(indatalen, 8), &len) ||
-				  len > MAX_CIFS_SMALL_BUFFER_SIZE))) {
-			cifs_small_buf_release(req);
-			return -EIO;
-		}
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool


