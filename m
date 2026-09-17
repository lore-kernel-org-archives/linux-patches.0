Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4846953D9EE;
	Thu, 17 Sep 2026 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664818; cv=none; b=Rh+g3Ys+Jg4jphtYmTnphsH2cirA1MBQWKCKe+rgpYyOajS5v3BHWl+rqaIkuew8ycS0Aa7rPIJzNqO5+vgacE8TxP3ie0n1zScO7EXimQrGj5+2oLVgVvb5qKriNd1/pJnNjyMYHT8w2nuyzlbQ2lXlvnbDc+/HMrQq34/4xRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664818; c=relaxed/simple;
	bh=BccRHN1UL/ZXC9/pi3SOufWsGI8UPVU6r4xUiKdcA+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR51G30x2gZjWoO2e/UrqOds1SBbq1OT3RqaxIbYI86Nj1X2V3F/OAr4sAsyDbM2eA3E9n2Fyc0DuVqh0Y8ehnnwW3ISqxY0594tT+/QWsnOxq/IlempRMDbb+m6sujWO88a4v0Pn4iiHxKQSKxdEwFj6wAFSzqaBCL8fvnBUIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOxTyFRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOxTyFRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8405A1F000FF;
	Thu, 17 Sep 2026 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664817;
	bh=eXk3Qw0+sBPaZDfrZ3o1NWXfERekFn2UiKD1zREDWZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOxTyFRp/uRq+LV05JmwYEqBhD4ESwrPTpTzj6TxlCAwchI4s0hMdj61qF+sFsw/K
	 Iuh1y+02RTBW7Yl7/+S1q9mnYZhMqPfXo2EHKG8GiUV1u77wdbw0UxpsUR3syZKljf
	 0TsKlaOqFwZUEaaBYXIYVcsTZIwP2bFARkQRhxKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0498/1250] ksmbd: mark invalid session responses as signed
Date: Thu, 17 Sep 2026 16:04:53 +0100
Message-ID: <20260917151605.457789584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
 fs/smb/server/server.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 76515d9777e30..f2bc73a7ee821 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -197,6 +197,12 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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



