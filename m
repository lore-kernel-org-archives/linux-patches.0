Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38A928DC4;
	Wed, 20 May 2026 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296626; cv=none; b=i4SVAy3ZjnGovygr5QhjsOLsRn32/jmfv6HVOCApqreN0xuRIoobE1GfsrXO+f43EIcevk6HSXCvxqKZjA4YHQKj7MMf2ainNkwIF9VNVuc5BEDJq9lVpwaUYCm0DZO35P8IoE/R2/vPhAyDVGUsgFIRI+BfcT8OFf4VS4fZAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296626; c=relaxed/simple;
	bh=E6f5MswcTXREYpCgHzwwYHGVjZEwx2i6d7mQo1Kmy7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quMSfYR/eHUPkOx3Qnkh8/HRi6rrv7AmXS3t6suxchXBfjNX5vFT/RTgKbJ69n1nx76drnQsNRgkgcw9FJCpxYda4+Q+3ZbD+PC3LJsr6Sb6rElZsRkaQM4aW/c8jV5od4qnBhcVlAjUINQvBVm3sTHBoPY8a/mFQyotjeJ2HfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYa8dMOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYa8dMOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666D01F000E9;
	Wed, 20 May 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296624;
	bh=HsM099AuIpuRIwXAnU17xAjs70eYw+KHiC4BjGmPQc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYa8dMOJ1yCtpcQ+D91mOcqOdhGnjYI8qO6JPz1GL1/ctK3py//cKFrFF4g2UW17p
	 8acvpP9mGCQjR4Sbi7NSX8x3yKsfcOYAJeBYV/bg7124QmG2q14Q7rnlXi68+B+iKV
	 vNJc5sJ3yL04XggqQp6/ogvbwsX7wStiDDr1esLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0828/1146] ksmbd: fix durable fd leak on ClientGUID mismatch in durable v2 open
Date: Wed, 20 May 2026 18:17:58 +0200
Message-ID: <20260520162206.969563113@linuxfoundation.org>
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

[ Upstream commit 804054d19886ac6628883d82410f6ee42a818664 ]

ksmbd_lookup_fd_cguid() returns a ksmbd_file with its refcount
incremented via ksmbd_fp_get(). parse_durable_handle_context() in
the DURABLE_REQ_V2 case properly releases this reference on every
path inside the ClientGUID-match branch, either by calling
ksmbd_put_durable_fd() or by transferring ownership to dh_info->fp
for a successful reconnect. However, when an entry exists in the
global file table with the same CreateGuid but a different
ClientGUID, the code simply falls through to the new-open path
without dropping the reference obtained from ksmbd_lookup_fd_cguid().

Per MS-SMB2 section 3.3.5.9.10 ("Handling the
SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2 Create Context"), the server
MUST locate an Open whose Open.CreateGuid matches the request's
CreateGuid AND whose Open.ClientGuid matches the ClientGuid of the
connection that received the request. If no such Open is found, the
server MUST continue with the normal open execution phase. A
CreateGuid hit with a ClientGUID mismatch is therefore the
"Open not found" case: proceeding with a new open is correct, but
the reference obtained purely as a side effect of the lookup must
not be leaked.

Repeated requests that hit this mismatch pin global_ft entries,
prevent __ksmbd_close_fd() from ever running for the corresponding
files, and defeat the durable scavenger, leading to long-lived
resource leaks.

Release the reference in the mismatch path and clear dh_info->fp so
subsequent logic does not mistake a non-matching lookup result for
a reconnect target.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e3a120a2d0596..c3c7688f0fa80 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2845,6 +2845,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 					dh_info->reconnected = true;
 					goto out;
 				}
+				ksmbd_put_durable_fd(dh_info->fp);
+				dh_info->fp = NULL;
 			}
 
 			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-- 
2.53.0



