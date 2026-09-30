Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A8A5158AE;
	Wed, 30 Sep 2026 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791134; cv=none; b=srPNqvqyAz/UVAvTNfGqMq1F56heINx/pq+BbB2peIt/WZR3A4H4h4ph6kVfWmDLtUCj1o7XIbpwxlPJq77dy2lsA7KP3PRKixnAhe5WE10I0QlBWJ+LVcanxQr7lfUOsh1FSy4m2C7i/GXtCfOd+yWUywlz6St4AnbQV9OjMPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791134; c=relaxed/simple;
	bh=7NCzYi9uFuzBbb0JH6xbjqn/D0ulNCLWiB9t1r8NxR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo1gtT2/o3fe5nR+l2znqfXyy973XTAVsfCssgfQ/+kpOiQPlsp2GZQZS7Tn3xkt84Qztldu9cBmDs4BoOCxl53wtwu5dpRU3O8sA3K9xPG9fpg+SNfmXEUdMxHhrCtj3kehUmpR+4cH6RgQb2T5+CXHmR9TC8cxKJDTHSJQOWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylYQCykG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylYQCykG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9E21F000FF;
	Wed, 30 Sep 2026 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791133;
	bh=CiRPEQ516T6HyR5g5YbH6jliDN7ZJhAdfW+wNOo3X18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylYQCykGcmwKR+JnQc/6OFB1dYCxUUhRptwFjpdNaOJ1/9WyTIzQ+056pVBTF68Uw
	 /G3NdCC26IAVCsNARFR12IuobA7TmFGeky9dlc7ZkkLMs1g5mTeq7WH9AGu6JLlVS0
	 wfqRa30Qod7e3ObNBRZFjswTzsi2Ro3ufENGDrNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/752] ksmbd: mark invalid session responses as signed
Date: Wed, 30 Sep 2026 17:21:06 +0200
Message-ID: <20260930152402.460284968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9e8ad620ddfde5a5f4ef58372e3805e9388cb0f4 ]

When a signed request uses a session that is not registered on the
connection, ksmbd returns STATUS_USER_SESSION_DELETED before reaching the
normal response signing path. The response therefore lacks
SMB2_FLAGS_SIGNED.

Clients that require signing check this flag before handling
STATUS_USER_SESSION_DELETED and replace the server status with
STATUS_ACCESS_DENIED when it is absent. The protocol permits this error
response to skip signature verification because the connection has no
matching session key.

Preserve SMB2_FLAGS_SIGNED on the early error response when the request was
signed. This lets the client propagate STATUS_USER_SESSION_DELETED.
It fixes smb2.session.bind2.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/server.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index fe797e8fe9419..c1b9a85f2c67e 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -195,6 +195,12 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 				else
 					conn->ops->set_rsp_status(work,
 						STATUS_USER_SESSION_DELETED);
+				if (conn->ops->is_sign_req(work, conn->ops->get_cmd_val(work))) {
+					struct smb2_hdr *rsp_hdr;
+
+					rsp_hdr = ksmbd_resp_buf_curr(work);
+					rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
+				}
 				goto send;
 			} else if (rc > 0) {
 				rc = conn->ops->get_ksmbd_tcon(work);
-- 
2.53.0



