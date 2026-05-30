Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732313A5438;
	Sat, 30 May 2026 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159886; cv=none; b=q5mXo0nM92yOBzmP6WdsBstgYjpJvV+gGXo6yIBGZnykDVvq9e23linnYtJAMggZl6jFuEFG6amHQjCmgVFfKcoUUA+5jFZMZ72yyvmjXPWG3l9e+852HvyQPMBDyT1iqKonWCT4bnx1d5vvax33oPDTeVNjo5HlLEjjovtCPAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159886; c=relaxed/simple;
	bh=ys3BRW8TTrG+tvqVjNYTZC0SytMnTTatdKJUCjgPo4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rty9ZMRC4W01UODoZErCl5oBdOH1YsrDs5eUoJwb6Rap0M1ax4wf1/SMOyQb85wludz6UehvFprQACuYSsgVTNsn6ZxDyMCXgcx/f1FmR0YhDWC3Hhh57mMUHUtsgq3NMLlw3OVjV/QmRbBf/NdKDYPZ07PD5x9jzqS50D6HTf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRTtwrw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRTtwrw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBCD1F00893;
	Sat, 30 May 2026 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159885;
	bh=UVHjj0x5AhhWxisM0YPpuRYrzxxfN8DQ7stAekaKKQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRTtwrw55gnpM029mGgJqVVAWr5csDVDXsEAKyp70lZHzs+QIN0iIhIL+SXCIza6a
	 VXQIZ5MuH8m6R1SZTpCeI/Pi43k3eIOzAWCQ7CaFHrpnoqnc7khyzHTQanbxXChNTz
	 Wutpcl4L5Vfyp+FhsQ8DYg4OjxjQ5O+9MVl5cpuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 187/969] net: strparser: fix skb_head leak in strp_abort_strp()
Date: Sat, 30 May 2026 17:55:11 +0200
Message-ID: <20260530160305.647504428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Luxiao Xu <rakukuip@gmail.com>

commit fe72340daaf1af588be88056faf98965f39e6032 upstream.

When the stream parser is aborted, for example after a message assembly timeout,
it can still hold a reference to a partially assembled message in
strp->skb_head.

That skb is not released in strp_abort_strp(), which leaks the partially
assembled message and can be triggered repeatedly to exhaust memory.

Fix this by freeing strp->skb_head and resetting the parser state in the
abort path. Leave strp_stop() unchanged so final cleanup still happens in
strp_done() after the work and timer have been synchronized.

Fixes: 43a0c6751a32 ("strparser: Stream parser for messages")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/ade3857a9404999ce9a1c27ec523efc896072678.1775482694.git.rakukuip@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/strparser/strparser.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -45,6 +45,14 @@ static void strp_abort_strp(struct strpa
 
 	strp->stopped = 1;
 
+	if (strp->skb_head) {
+		kfree_skb(strp->skb_head);
+		strp->skb_head = NULL;
+	}
+
+	strp->skb_nextp = NULL;
+	strp->need_bytes = 0;
+
 	if (strp->sk) {
 		struct sock *sk = strp->sk;
 


