Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1B4A8430;
	Wed, 30 Sep 2026 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791895; cv=none; b=MOrvs9WUQGc65uiLRARUclMrYlslSmf8JpwnHDaLSn3K5np3xEUgAfH4nDNEjiqjaVmcHHuVwWn48GNchCS9b9kzlqFnRVI2dqu7MgnC4z3eK4M2OoHyOwZz9eqxsc0Y1EVOwbTRHhR01djBaAjYwJ97RcHwIy1f2hb0wdBpTBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791895; c=relaxed/simple;
	bh=a/4B0CpjOhbvw+9lpmpcw5ASw12RCRXI+Tv0rM0kGEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnp/GZlgtVP8j0Z/toWy48TS/IkndwsWrqpi/t1Izmn8vbQoFRviaV/0O0CIukDWmtJqMj8AerYiPIPmKb5GQcVLK5rmCiXJEL1TdehkjT3I6CsIvfuS9Evo6FTdEyF8ZODfcUOi5EzGLJdHlWyTO0U0KyHlXhjsJoVhIny9EiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3r3MgVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3r3MgVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C11F000FF;
	Wed, 30 Sep 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791894;
	bh=qmsaPBf8dUoUz8n8Ax6quv9eriGMv0phrMp4R6av09E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3r3MgVCskwWK362hHQuc0/67bTo42djAbAj6dT03MwMKQVqpDOj/3l+hCLTBiaL9
	 AHXCTUwD+Kpff13t9agqTI2WSkRi+PtFlxFEz8yNV9vOZ4ohnK27yOSDatFXTuSPBT
	 xjcgmqDHP7ndzHoCH9G3/fXrU/1OsVfwwCFc8zCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Xinyang Ge <xinyang@anthropic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 419/752] mptcp: close race between scheduler and state change
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152407.349754727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1621,7 +1621,9 @@ static struct sock *mptcp_subflow_get_se
 
 static void mptcp_push_release(struct sock *ssk, struct mptcp_sendmsg_info *info)
 {
-	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
+	if (info->mss_now)
+		tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle,
+			 info->size_goal);
 	release_sock(ssk);
 }
 


