Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B71F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2094CC433C8;
	Tue,  1 Aug 2023 09:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882768;
	bh=hzeMK1A/AdPapE9grLO5RqiRntJA6bMvobKpKziMV6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0HMMSaEVpF9LzG0nPahWZe3nmEfcQR6hKUm299rUCqNzvcGd75BZ1uHdZi0fXKhW
	 iw67UJbehA8rFiznuMWEe8RzOYOXpa8rCfGI9xQg6q/1R7HwSrHN+OU2svg8k8Am4V
	 co0ycRjaHwPDHrTQvr9ooXY5OLTqXskrHovTtNQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 224/228] mptcp: ensure subflow is unhashed before cleaning the backlog
Date: Tue,  1 Aug 2023 11:21:22 +0200
Message-ID: <20230801091930.946662934@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 3fffa15bfef48b0ad6424779c03e68ae8ace5acb upstream.

While tacking care of the mptcp-level listener I unintentionally
moved the subflow level unhash after the subflow listener backlog
cleanup.

That could cause some nasty race and makes the code harder to read.

Address the issue restoring the proper order of operations.

Fixes: 57fc0f1ceaa4 ("mptcp: ensure listener is unhashed before updating the sk status")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2945,9 +2945,9 @@ static void mptcp_check_listen_stop(stru
 		return;
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+	tcp_set_state(ssk, TCP_CLOSE);
 	mptcp_subflow_queue_clean(sk, ssk);
 	inet_csk_listen_stop(ssk);
-	tcp_set_state(ssk, TCP_CLOSE);
 	release_sock(ssk);
 }
 


