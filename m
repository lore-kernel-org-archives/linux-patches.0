Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10FC4E0B8B;
	Thu, 17 Sep 2026 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668348; cv=none; b=E1zzzDWAeSOOF6Ojz3/G7bAHjbEZM7m9o892rB/5oYbht3Re+EB03q/pNg07z3xCbUv061IqYBh8RLFftkfUhesspHGbllNwm6wVxv9MiWe8H0PZgZaue7XC5/HkgkTe5wOtfhMcaNMIElxwGZ27dS263XQxNi+I5LAj+0CQPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668348; c=relaxed/simple;
	bh=8/biP+OsEBoLX6drdUDiPNgaqgHpTE7JTjIQtT6m2X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnSWN4HlVDCCzQf9WWeOoLcR5sdoQW/+n5xURhk4uKY1F93qLPd+RQvYRWhd40UZf6b9kRDF7gkmYzdHZ1blLrxwrcwv5dXps6GO1JX1clEexR4aT5X07CeWCfebBg2X76UJccXI2mvZV2sCqgLMiLQKJ7gvnQo+pNd0HVcsMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIDXmiz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIDXmiz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA491F000FF;
	Thu, 17 Sep 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668347;
	bh=af5Ya3WpzoMEvWdLyBT9uUZKiKQqsB4B04TCNJiYu/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIDXmiz8ZbpJxEUTrZQiS8BK9c3akdVjuboouSf+ogdcV2Jrac8OVutcGc+6XYfZJ
	 KKfMn33v7OfbxVHe4iAZh4Wq90MZO9DGRx4xTXowGzHaItWld5S5/F3drgh+pwNyIr
	 5okbvuAsgEvY8GnqC81/pPycUbWNoZNMf1Yff+ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0394/1102] ksmbd: mark invalid session responses as signed
Date: Thu, 17 Sep 2026 16:05:37 +0100
Message-ID: <20260917151549.549492947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index a618638875012..bd6891354d4a1 100644
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



