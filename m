Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8DB509EFA;
	Wed, 30 Sep 2026 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785636; cv=none; b=cjD+nLXJS5x4y7JaHxXYTjbZ5JrKIfoPxSH5MLLlvvQ31ZAcsfxgDDkfjFi0/+qJMkPBftQyDOcsvQLfzO/OsH9UCMd60OwrSqbiNdmS8zVmlbFUWfQ7KH5IQrsuvRY//YlCCcmYhWz7818xAg4rWEACsx53P53bmB8mML/Gz5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785636; c=relaxed/simple;
	bh=08ClHAAKZLnfOv9wlhIHbplHfxqW44bQCXW80LG1je8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqZpTSI9fHoIkc5+GSb03Owz+Bn4987QOq1HKZYzD7qXAc3X12p6/K1kMaSv5VvFjjw7mOJgwQU7N5rwnUZ+qPS2T2qFgulIlYGzMlONjVtAJXSJGuuo64y3m0tBN2IhvIQ7GKxqkoHZpmj86jYnGLV3G0B+MknM0RblP381ZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqPQKebm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqPQKebm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BB91F00893;
	Wed, 30 Sep 2026 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785628;
	bh=EhyKz27YhotVHAm9WwOiiQsqPV0qPKl8Yy1fdgjuJNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqPQKebmG+8SeMTUPWUkAgQtUhF7CRoBtwqJDmotYf98v1ljwvFCk0xd5VKG8ZbOH
	 X6S7LVaLiiIx0SRS2C2DCkkX2/ZJXmHYNXS/D/pYxcTbKBHybiiyB3oQbJiakSiowQ
	 beKV7MyS1x0Y/r4yk2QhdlPJlO61n7SCamGC4Zxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Xinyang Ge <xinyang@anthropic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 575/982] mptcp: close race between scheduler and state change
Date: Wed, 30 Sep 2026 17:21:51 +0200
Message-ID: <20260930152429.122392930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 42064de57fb83231fcc89663a94885f228a1ee53 upstream.

The mptcp scheduler may race with subflow sockets state change: data
transmission on the selected socket may fail and a later release could
try to use mss_now reset to 0 for a divide operation.

Address the issue by explicitly checking for the critical scenario.

Fixes: c886d70286bf ("mptcp: do not queue data on closed subflows")
Cc: stable@vger.kernel.org
Reported-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reported-by: Xinyang Ge <xinyang@anthropic.com>
Closes: https://lore.kernel.org/20260525194828.1137119-1-shardul.b@mpiricsoftware.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260917-net-mptcp-misc-fixes-7-3-rc4-v2-2-0cf5c72667c8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1636,7 +1636,9 @@ static struct sock *mptcp_subflow_get_se
 
 static void mptcp_push_release(struct sock *ssk, struct mptcp_sendmsg_info *info)
 {
-	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
+	if (info->mss_now)
+		tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle,
+			 info->size_goal);
 	release_sock(ssk);
 }
 


