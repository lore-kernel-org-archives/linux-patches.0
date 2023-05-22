Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E98171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AEDC433D2;
	Mon, 22 May 2023 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783086;
	bh=EzyF6OLAiRZi1VdOa+f93VuGjdKRP5UzH9D3GxGBV6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOpcg1Cwq+eUYYt2sE8u4Gy/ro6kEN/6QSuiLJOQmANG9bv2Iu0U6E5brJzHE62/G
	 M4qSOY3HD9SCMfVuk6O1iBfh2KOzoNhwwW7m0hsYln3luni6Wmcjxf+dxLT+zf9NN+
	 JMGIGASJOkbscvBO5xdIomWzMgSEprDyU/7pZ0Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/203] SUNRPC: Clean up svc_deferred_class trace events
Date: Mon, 22 May 2023 20:09:19 +0100
Message-Id: <20230522190358.704326546@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 45cb7955c180a2a34d291e68938250c4f9bd294f ]

Replace the temporary fix from commit 4d5004451ab2 ("SUNRPC: Fix the
svc_deferred_event trace class") with the use of __sockaddr and
friends, which is the preferred solution (but only available in 5.18
and newer).

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 948f072ada23 ("SUNRPC: always free ctxt when freeing deferred request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 2a598fb45bf4f..d49426c0444c9 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1923,19 +1923,18 @@ DECLARE_EVENT_CLASS(svc_deferred_event,
 	TP_STRUCT__entry(
 		__field(const void *, dr)
 		__field(u32, xid)
-		__array(__u8, addr, INET6_ADDRSTRLEN + 10)
+		__sockaddr(addr, dr->addrlen)
 	),
 
 	TP_fast_assign(
 		__entry->dr = dr;
 		__entry->xid = be32_to_cpu(*(__be32 *)(dr->args +
 						       (dr->xprt_hlen>>2)));
-		snprintf(__entry->addr, sizeof(__entry->addr) - 1,
-			 "%pISpc", (struct sockaddr *)&dr->addr);
+		__assign_sockaddr(addr, &dr->addr, dr->addrlen);
 	),
 
-	TP_printk("addr=%s dr=%p xid=0x%08x", __entry->addr, __entry->dr,
-		__entry->xid)
+	TP_printk("addr=%pISpc dr=%p xid=0x%08x", __get_sockaddr(addr),
+		__entry->dr, __entry->xid)
 );
 
 #define DEFINE_SVC_DEFERRED_EVENT(name) \
-- 
2.39.2



