Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394921C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD166C433C1;
	Wed, 23 Nov 2022 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197240;
	bh=QzTG6WIwpKkNcDDUpnzaED3rciHT9jggQIAVbDasb3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ruz2Yl42v6NmeK7Gb5GKGj3IN+tK4PSpapeoH4/7jFHK49GnigSE3/1FbrBfqwjmZ
	 lSKlhCwbz8pfLJwu3qKHlgUby809mEq2IL4P06fK1EAq+G71PX5pd9lIhLs1SlumWZ
	 Dd60RLG5I4QUjmQ0iqsrzvN0cxYBjBqs7wJpIOFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 207/314] rethook: fix a potential memleak in rethook_alloc()
Date: Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084634.919907731@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yi Yang <yiyang13@huawei.com>

commit 0a1ebe35cb3b7aa1f4b26b37e2a0b9ae68dc4ffb upstream.

In rethook_alloc(), the variable rh is not freed or passed out
if handler is NULL, which could lead to a memleak, fix it.

Link: https://lore.kernel.org/all/20221110104438.88099-1-yiyang13@huawei.com/
[Masami: Add "rethook:" tag to the title.]

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Acke-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/rethook.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -83,8 +83,10 @@ struct rethook *rethook_alloc(void *data
 {
 	struct rethook *rh = kzalloc(sizeof(struct rethook), GFP_KERNEL);
 
-	if (!rh || !handler)
+	if (!rh || !handler) {
+		kfree(rh);
 		return NULL;
+	}
 
 	rh->data = data;
 	rh->handler = handler;


