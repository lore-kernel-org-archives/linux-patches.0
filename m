Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233DC168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C31EC433EF;
	Mon,  8 May 2023 11:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545457;
	bh=QLhEU+bG9y1YJg/006OtBhIUpOz6md9Y2sUqxsGYKkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbL9UWY8bwhFpqR7g9yFF3GzdgXBbIsLywyXVcsL0Bf/B1WE4j+UntIQTCGh0NV6U
	 OoyKNMcuiyCmAkEuUX304FcfDDR0P/ahZqNhyCa+Yydap5krwR2ml61Gv1Ie8pbndv
	 nOOgnknh3jZxiquLhYJwZ4HBp6sdM5stqCkBNugY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 046/371] ksmbd: call rcu_barrier() in ksmbd_server_exit()
Date: Mon,  8 May 2023 11:44:07 +0200
Message-Id: <20230508094813.880529105@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit eb307d09fe15844fdaebeb8cc8c9b9e925430aa5 upstream.

racy issue is triggered the bug by racing between closing a connection
and rmmod. In ksmbd, rcu_barrier() is not called at module unload time,
so nothing prevents ksmbd from getting unloaded while it still has RCU
callbacks pending. It leads to trigger unintended execution of kernel
code locally and use to defeat protections such as Kernel Lockdown

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20477
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -611,6 +611,7 @@ err_unregister:
 static void __exit ksmbd_server_exit(void)
 {
 	ksmbd_server_shutdown();
+	rcu_barrier();
 	ksmbd_release_inode_hash();
 }
 


