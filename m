Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32841A01C7;
	Thu,  6 Jun 2024 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683146; cv=none; b=dlJJJSbfo6tR+UtqCouUdUSBexDsLjq0vZIC87uZ6avkKebRv3F2eVHRghkS6iKczb2NC2VP/CNiZ8GxwqIbhaERTAsbTq0Cyqz9b2Lgke+mCJfy/BAc6mK7UvXYkxpHqQjgsPKfO3BW3sN+Iq+JnW/379j1HcMC+0u6IYNaQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683146; c=relaxed/simple;
	bh=Q9xvA97SENlAhfm3sv9dhhifCWzlW/yP0T7W2iyR3go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeJr1ThYQJfFs575O5ioC0Dr9XJvUWDLVO9Cu6Q5o2e56IKbg8HL8lZQZW0oZEYsIPOM81r06gLWuMnF2yVllpk/U48ltyN8INlFRvUunpwHYOXZZlMa+iHjNk9ove3/kCGfgaJdXjJ24V2RWJW04oLt9U7j1Yuvp9715jdHzZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7ugljYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7ugljYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B03C2BD10;
	Thu,  6 Jun 2024 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683145;
	bh=Q9xvA97SENlAhfm3sv9dhhifCWzlW/yP0T7W2iyR3go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7ugljYNbsljVQFdAPQ8snmloo6i021s6+32OIet40uKKqiDv6m9bNVpiU9tRh4R7
	 nZD6Jw8RigchzUuIYUDLsoLkPVSpK2uEhyHkXIO6jNvVPgSp66/UsRmmTTanprNxBf
	 lK8Uyg55+ezAPchoccL3EaxCrjiiTZ/FlNXGl4ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/744] ksmbd: fix uninitialized symbol share in smb2_tree_connect()
Date: Thu,  6 Jun 2024 15:56:03 +0200
Message-ID: <20240606131735.315661915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bc642d7bfdac3bfd838a1cd6651955ae2eb8535a ]

Fix uninitialized symbol 'share' in smb2_tree_connect().

Fixes: e9d8c2f95ab8 ("ksmbd: add continuous availability share parameter")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1e536ae277618..6a15c5d64f415 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1926,7 +1926,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
-	struct ksmbd_share_config *share;
+	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
 	WORK_BUFFERS(work, req, rsp);
@@ -1988,7 +1988,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	write_unlock(&sess->tree_conns_lock);
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE && share &&
 	    test_share_config_flag(share,
 				   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
 		rsp->Capabilities = SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY;
-- 
2.43.0



