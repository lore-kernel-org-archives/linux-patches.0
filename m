Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA62957DA;
	Wed, 23 Apr 2025 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422008; cv=none; b=TM9++tB5RFbuytlopkQrZ1qxXQ/Lp3wzrwEZflKuWbstlfAwpXoJukbieyQTkGMcZfiTPdNc/etN2XY9OYB5G4I3R+7Md/xCb2UOj5KBdGAaD9gCkTMCCoiHLaqYf4NEkzYG/HXJmvfy7pemorXiw649Vjf4rSh/GMabGpzEF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422008; c=relaxed/simple;
	bh=GddF6ptcG98HOuCwqocGgxFcSd7d7aklD1NAqUyB75o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwwZj7AgNtkpHf01nsGeKJtlufpcryyEv2Lkw4UPZAPjy76gMVf+k1ucXIGtyE3awWwV5pZF1bF6prqUS0Vpukumuu4OKExuTE8loGJ+d2gLBjiO1i8pcLP1q15VQkPWIRl0ro09MLicWtBNT5iB3SD+MJ973UM+VHQW5Cu64h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3TzTVG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3TzTVG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728E5C4CEE8;
	Wed, 23 Apr 2025 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422007;
	bh=GddF6ptcG98HOuCwqocGgxFcSd7d7aklD1NAqUyB75o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3TzTVG48+oApilwugFwN9xoPZhJIbkDXcMZiWMgWp7EI8K0Vk/JLcMJUdTZ1xieZ
	 R1wLSEi3IdDaDvm2u2FESiFrjWO9ZKJihivdu9AA2gbIh8kqZ48/lGXtbAjVdJ2d9L
	 JQr0sgtdiMdtem/xH/Mh1rGCepR3C6Sx99X+QJCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 217/291] ksmbd: Prevent integer overflow in calculation of deadtime
Date: Wed, 23 Apr 2025 16:43:26 +0200
Message-ID: <20250423142633.270981302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit a93ff742820f75bf8bb3fcf21d9f25ca6eb3d4c6 upstream.

The user can set any value for 'deadtime'. This affects the arithmetic
expression 'req->deadtime * SMB_ECHO_INTERVAL', which is subject to
overflow. The added check makes the server behavior more predictable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -296,7 +296,11 @@ static int ipc_server_config_on_startup(
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
 
@@ -319,6 +323,7 @@ static int ipc_server_config_on_startup(
 	ret |= ksmbd_set_work_group(req->work_group);
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
+out:
 	if (ret) {
 		pr_err("Server configuration error: %s %s %s\n",
 		       req->netbios_name, req->server_string,


