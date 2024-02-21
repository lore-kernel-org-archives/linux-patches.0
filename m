Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33EA7E78B;
	Wed, 21 Feb 2024 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521980; cv=none; b=sPH2lS6K024EFA23lxUxp8jW9L6yrYu/jv2ZwVZYlUnx9vo0z3hudgQ/UIfMVKCDDcI+2P0aWvtH8N3UDrljsKb19W2x6Tau8jyHrKwfA8dPw+hc/I+RgoVcqngL8O3IPSotcVPQkgx5/ZysJumRSgh1ZNACAS9dDKhQOx6t/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521980; c=relaxed/simple;
	bh=qjIt9JrLb0S3uLhj322Sl2LsB1h+yZgECJ4BGlYx1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq5KYmx+XVBN2fr6Xwtbyor5pwLT5Es/GN5NNSQhgoLBdq3JGr/b9Imzx7upxS1Y1rRgHsoQUWgImLxIxZ8yn+1HBO+rQNJsRlyo5/Lfk4bm7chJGoRUiE9wQPo6KZnJ2/NTsTEUnfRBXMy1JOihKwO2fI8wO47ybZhXip99jKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXNxF52K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXNxF52K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E288CC43330;
	Wed, 21 Feb 2024 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521980;
	bh=qjIt9JrLb0S3uLhj322Sl2LsB1h+yZgECJ4BGlYx1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXNxF52KVhWSLoUUuOFTRU9Pf+xAZZ0xlxe/sshQHMbM16Ugn4NcmU1oe8kXjy0ig
	 VGbQdq2V08JXWcOooL2P9ElwiIR/e8Cd0pB0zQW5oZ5U02SdVVhuCmQ2d/On5tddFT
	 /flSTo41FjqPCV1vbsjv9Zsgp4GhS8ezdkr3vutg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 044/476] ksmbd: Add missing set_freezable() for freezable kthread
Date: Wed, 21 Feb 2024 14:01:35 +0100
Message-ID: <20240221130009.567718548@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/connection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -284,6 +284,7 @@ int ksmbd_conn_handler_loop(void *p)
 		goto out;
 
 	conn->last_active = jiffies;
+	set_freezable();
 	while (ksmbd_conn_alive(conn)) {
 		if (try_to_freeze())
 			continue;


