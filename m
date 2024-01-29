Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A63157E6A;
	Mon, 29 Jan 2024 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548290; cv=none; b=nag5sA9h6cRuqsBCeV8YDOTsYy10gf9qlMeQ9BCS7cx80SMpk2NvI70DvyP0VPjbk2GhqMQi9Qmxctwfl/EMn05CDI1KODWO6g4GkhKt52kcjjFkZ1cad44Xuvv3zv4LyR++OJ9QYPPElxHvKWWTocg+VM9gRFF1pL/B+22+hHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548290; c=relaxed/simple;
	bh=I7IkWwIcoy6xGwtkVi4Wnq8jSgZ+k1/qXfwJbD81WOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnJxbSxzljaU67iGvwKucF9u1N9uQQsiHSjV8RqibmT30rvXEonjeRreHeA72OSFLVTrkhxop9Ad/lcQgKn9gZu1HBqt81N2cr5OHINopKi0/toC/qqRwcZ7YdUBcrsR1bgFzrV7+3g6uOJvS+Msd1lv8n7vyRIcR711Li6X3Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnglTbw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnglTbw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988D6C43390;
	Mon, 29 Jan 2024 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548290;
	bh=I7IkWwIcoy6xGwtkVi4Wnq8jSgZ+k1/qXfwJbD81WOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnglTbw0dBQ7ylkqnS1Bp94S4RAAyJXxOASOOiTbEDupgTJsbwUQth+bC5S6k6jki
	 15/rBLcfeC4K3YsYKFwEVYBXJ/3u8e6nqXaHl4Ov2EgFLBVZGnhGh5R2Xs7JkoyWXI
	 7uInZtyDz531238D1+fuu9Go6hppn6Inr+Sd35g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 073/185] ksmbd: Add missing set_freezable() for freezable kthread
Date: Mon, 29 Jan 2024 09:04:33 -0800
Message-ID: <20240129170000.953663782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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


