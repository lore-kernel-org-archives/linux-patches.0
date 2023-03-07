Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC95BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F929C433EF;
	Tue,  7 Mar 2023 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211240;
	bh=tvhcXCYADyb88in/1/EKCtCt2MTc0RUrAB+8FLj3HoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekf8c2tv3XEeMF9zjNCHnpFBdY1E9Jd1yh3ebO0BJM0iwoqheEpHqyQa4TcLlnvmY
	 CAgIzGoA4VBQNhILAiVHvn5BNGEMSrFrZUn+aoBy9uMkuYALwHThhGhVtkwnYUtT+q
	 mOd3WV5+dPPhsifUkw+bYxN2X94+Zh/rBBOUMO50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.2 0799/1001] fs: dlm: be sure to call dlm_send_queue_flush()
Date: Tue,  7 Mar 2023 17:59:31 +0100
Message-Id: <20230307170056.411709304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit 7354fa4ef697191effedc2ae9a8293427708bbf5 upstream.

If we release a midcomms node structure, there should be nothing left
inside the dlm midcomms send queue. However, sometimes this is not true
because I believe some DLM_FIN message was not acked... if we run
into a shutdown timeout, then we should be sure there is no pending send
dlm message inside this queue when releasing midcomms node structure.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1402,6 +1402,7 @@ static void midcomms_node_release(struct
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
 	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
+	dlm_send_queue_flush(node);
 	kfree(node);
 }
 


