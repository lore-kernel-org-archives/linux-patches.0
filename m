Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A434314F9DA;
	Tue, 20 Feb 2024 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462860; cv=none; b=PY4NEPQ/AFn8b0tLg9QdqyB8/+/k0G4kHiaDYzZVgQD0Vx58M0ea3/JYnWdJiUAkhgnQbRoheyWlqe4WlzOGANxx2vjJkwI2JsKs9RTaIvyP3bW7rO7VYBQPRengAO1zSjOLpBep6Wi4xY88mMtJ6wTxQRNwFmeI2WriNAfYKcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462860; c=relaxed/simple;
	bh=M5OByf476lqOwcwPzPNWvQOyltvlh55ycQSXrVJOB0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCYiBgcSuqpVDV/vdHvWnUkovN6KwIPwdXrjY6QP9hAYLQs+xd5Eq5NRdVCZYoOMV+K73/kT7MEL9uQ/guhF6/4ilxEDFV3qEBauv1ubvaAV226XX6fTt/gAK7V4JzPnLO+wIUbiRZulQGYVpwgL6nduYpTiLUpWdvlcst/b8Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiamx9qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiamx9qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B750C433C7;
	Tue, 20 Feb 2024 21:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462860;
	bh=M5OByf476lqOwcwPzPNWvQOyltvlh55ycQSXrVJOB0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiamx9qxqe4K56mcI6qgkFYUStxko8j2CkYf4El9XvHUEZcxydzHCIsQIj7ROxuE3
	 IFXjWqLziokmvEdPHGN+vL0CGXaqeOTo995/DjY/t9ZUD4a2YiNei7kUXzvVEEQp8g
	 S/zSZ3LJstpEOBV00qquT1wLllrzFpFCOcIqU658=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/197] cifs: fix underflow in parse_server_interfaces()
Date: Tue, 20 Feb 2024 21:50:18 +0100
Message-ID: <20240220204842.844057273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cffe487026be13eaf37ea28b783d9638ab147204 ]

In this loop, we step through the buffer and after each item we check
if the size_left is greater than the minimum size we need.  However,
the problem is that "bytes_left" is type ssize_t while sizeof() is type
size_t.  That means that because of type promotion, the comparison is
done as an unsigned and if we have negative bytes left the loop
continues instead of ending.

Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5a157000bdfe..34d1262004df 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -613,7 +613,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		goto out;
 	}
 
-	while (bytes_left >= sizeof(*p)) {
+	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
 		tmp_iface.speed = le64_to_cpu(p->LinkSpeed);
 		tmp_iface.rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
-- 
2.43.0



