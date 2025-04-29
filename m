Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03972528F1;
	Tue, 29 Apr 2025 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949314; cv=none; b=RI1QKA/6B2Rcpc44BEN8e0MNO7c65un+H1J1YGW7uo66gkx8cQFuDz4Dd0JhxtpWhLEkeWQVPqxEQSZ+KrBfGsVq665ZHaKr4pF8DMLLH8isVRwYjQRGHtdZQAA8IlLWMUTOvNzEtW5Z2w5+VPy44MuHf2sXOKQQTcK4BiV5Mhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949314; c=relaxed/simple;
	bh=7EWvVB7VTPVTFJGEQmh8+pv0LJSYkKvie9DzYIh+O6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKW7YiCmlr/0o+OjCf0oSeemVXExo/IqKw21tjFk7X7GGhyNZU1/gSWSUF8hGDIVuDStYJsNrzTyXlKzLDk2uha0UUzy280dq3J4BSC1DVNZtYQEMf5pzlD/t1iUjo1jZ/BxLpDnWxDoPYv/uhm4Rkhzk2HACkU+/LgRuZqQlRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhwZIxPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhwZIxPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56188C4CEE3;
	Tue, 29 Apr 2025 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949314;
	bh=7EWvVB7VTPVTFJGEQmh8+pv0LJSYkKvie9DzYIh+O6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhwZIxPrs/R26UAeRItlW3Ucjl7e6F8jXqYagmwmmFjoGFuTy8pvWbyQsJmDLBkUC
	 2UADPNGJU+taF0+gFPDH9HkpE4prevMzKsxPY5LykEIPtU8aZerRgEq4fTRsh61n+/
	 Ckbwkv47ZcZP0mv1KK3SllyNKizVPhVIlUI94Vds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/373] ksmbd: Prevent integer overflow in calculation of deadtime
Date: Tue, 29 Apr 2025 18:42:35 +0200
Message-ID: <20250429161134.554934614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit a93ff742820f75bf8bb3fcf21d9f25ca6eb3d4c6 ]

The user can set any value for 'deadtime'. This affects the arithmetic
expression 'req->deadtime * SMB_ECHO_INTERVAL', which is subject to
overflow. The added check makes the server behavior more predictable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_ipc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 0d096a11ba30e..7e6003c6cd9bf 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -294,7 +294,11 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	server_conf.signing = req->signing;
 	server_conf.tcp_port = req->tcp_port;
 	server_conf.ipc_timeout = req->ipc_timeout * HZ;
-	server_conf.deadtime = req->deadtime * SMB_ECHO_INTERVAL;
+	if (check_mul_overflow(req->deadtime, SMB_ECHO_INTERVAL,
+					&server_conf.deadtime)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	server_conf.share_fake_fscaps = req->share_fake_fscaps;
 	ksmbd_init_domain(req->sub_auth);
 
@@ -317,6 +321,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	ret |= ksmbd_set_work_group(req->work_group);
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
+out:
 	if (ret) {
 		pr_err("Server configuration error: %s %s %s\n",
 		       req->netbios_name, req->server_string,
-- 
2.39.5



