Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258F273728;
	Mon, 29 Jan 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548533; cv=none; b=o+r8RqL1g6h9BHPO/hKdksuVyt6DcsnuF7Hzhp3IRFY0gcQFWyGskS9e9Eh8HqIuz4TSp3JcxYMTKbZB4WKA6whZodjAU6Mroc84OvuT9TqwCC7ncpOk9k2muGDCpJ9iGuOzs1fNQgS/5i6tzv2JO+cK+KUtH3sSaIX95CaM+mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548533; c=relaxed/simple;
	bh=DaNMEqj9AUA8ctFGRN9SBR6VLf3GGjb885RnBbSAMy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNNNzihcRQ87/DwI5mXhCe2Y4RsGlkicTnHc6czuWRSYt5nHmXc9iyhsOEClzLsM2F++GfbRTQZY6myvaAqFGOWqsSvsWEnPRBk1oiJwNiHDYj58qt4CIsE+BeYkz8Q8reC2rBNcmaLMZLRRHq65JCFIeDqHD4e6Ba/wcNxqfuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVbBLkMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVbBLkMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39E0C43390;
	Mon, 29 Jan 2024 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548533;
	bh=DaNMEqj9AUA8ctFGRN9SBR6VLf3GGjb885RnBbSAMy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVbBLkMtr9o8sxUOpYJbEXfJ0H4HN8xrUG7syzMt73EWD9M0L4uxeBihj34xxSMQo
	 Qiyw9engz+lY5u2bSXgPddNk8DAaMQtRcmag8IWUcp2ffjvIfuBCUNEFjqyB50bu9U
	 foOMMylVOUrXR/Vh0ZdqfnKmi9sPRjsmRp0VB+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 144/331] ksmbd: Add missing set_freezable() for freezable kthread
Date: Mon, 29 Jan 2024 09:03:28 -0800
Message-ID: <20240129170019.150125920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 8fb7b723924cc9306bc161f45496497aec733904 ]

The kernel thread function ksmbd_conn_handler_loop() invokes
the try_to_freeze() in its loop. But all the kernel threads are
non-freezable by default. So if we want to make a kernel thread to be
freezable, we have to invoke set_freezable() explicitly.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -284,6 +284,7 @@ int ksmbd_conn_handler_loop(void *p)
 		goto out;
 
 	conn->last_active = jiffies;
+	set_freezable();
 	while (ksmbd_conn_alive(conn)) {
 		if (try_to_freeze())
 			continue;


