Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED9C168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E87C4339B;
	Mon,  8 May 2023 10:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541365;
	bh=wLtQqlvpw56+8x2JhP757xkkBKJEtgWxzFXJVVzaEIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMiMl1ZZ4NNqcY9G3v7g5chIjMp4yeJhZbUg8agBTPDG97i6Sq8pMnH6Bzarw/8TG
	 uTl/yJecL+asbaWVteCTEfdnSZXeMM6W1JaogO3E+kcaOxk8/HOqoBJ4oNGBdAfJpf
	 boaxIItbV6e0DueoIB/L9cOQei15mKJuE7I1emIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.2 091/663] ksmbd: call rcu_barrier() in ksmbd_server_exit()
Date: Mon,  8 May 2023 11:38:37 +0200
Message-Id: <20230508094431.413183059@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
@@ -606,6 +606,7 @@ err_unregister:
 static void __exit ksmbd_server_exit(void)
 {
 	ksmbd_server_shutdown();
+	rcu_barrier();
 	ksmbd_release_inode_hash();
 }
 


