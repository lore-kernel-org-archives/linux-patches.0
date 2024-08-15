Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684DD1B29D8;
	Thu, 15 Aug 2024 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732921; cv=none; b=oMgeVF8zROuzWd4MRc398q0SECP5VlR5iFAxYplHqgTjMTXWClU2oy8vQngzp/34s67cOBudDLUgy0Lq9ljiajqtF+GnmCRle2Nv1Q/lpLop9MWaa9lhmbEPYmxokEEfjJncENUSSr4dFZbpOKkqu2QUfniRe9X7T8KDQE2Tg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732921; c=relaxed/simple;
	bh=vIZ2lBtTh0OMWFdnj4Q8iHNYA328ZGyZWR42QeOvM1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us62O/LmtD2UN0GIF1B2sR5UTN3x5x7MP6gL6kAR7E5h8BoGsBZNsauMRYqOqldIiYFMI/zqTn98iZSPqjg19f43ga3dcIrUpDh9iNi+lm4soepKNIyRkbgW5aJrzVGNP8lxbCzU66TM1XaPv8zub2b09zjTbT5ZLQmBezYwM+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZsvgfqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZsvgfqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB6CC32786;
	Thu, 15 Aug 2024 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732921;
	bh=vIZ2lBtTh0OMWFdnj4Q8iHNYA328ZGyZWR42QeOvM1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZsvgfqkjh8c6RFaEz7SeJ4elypdBxZlqsfJgXvfk9332FprkYr3ikZPFLzeqd/N2
	 k2U9+93mxtv+w9rNj54Gw63TChKqvaVf+b9igcDciSQjaLYoakiNJL59z320SmAA+l
	 o15jwBX3gVpwHCIcsZ2bF2y+U8kPc8L/+Zsf00R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 328/352] mptcp: sched: check both directions for backup
Date: Thu, 15 Aug 2024 15:26:34 +0200
Message-ID: <20240815131932.130432248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit b6a66e521a2032f7fcba2af5a9bcbaeaa19b7ca3 upstream.

The 'mptcp_subflow_context' structure has two items related to the
backup flags:

 - 'backup': the subflow has been marked as backup by the other peer

 - 'request_bkup': the backup flag has been set by the host

Before this patch, the scheduler was only looking at the 'backup' flag.
That can make sense in some cases, but it looks like that's not what we
wanted for the general use, because either the path-manager was setting
both of them when sending an MP_PRIO, or the receiver was duplicating
the 'backup' flag in the subflow request.

Note that the use of these two flags in the path-manager are going to be
fixed in the next commits, but this change here is needed not to modify
the behaviour.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in protocol.c, because the context has changed in commit
  3ce0852c86b9 ("mptcp: enforce HoL-blocking estimation") and in commit
  33d41c9cd74c ("mptcp: more accurate timeout"), which are not in this
  version. This commit is unrelated to this modification.
  Note that the tracepoint is not in this version, see commit
  e10a98920976 ("mptcp: add tracepoint in mptcp_subflow_get_send"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1124,11 +1124,13 @@ static struct sock *mptcp_subflow_get_se
 		send_info[i].ratio = -1;
 	}
 	mptcp_for_each_subflow(msk, subflow) {
+		bool backup = subflow->backup || subflow->request_bkup;
+
 		ssk =  mptcp_subflow_tcp_sock(subflow);
 		if (!mptcp_subflow_active(subflow))
 			continue;
 
-		nr_active += !subflow->backup;
+		nr_active += !backup;
 		*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
 		if (!sk_stream_memory_free(subflow->tcp_sock))
 			continue;
@@ -1139,9 +1141,9 @@ static struct sock *mptcp_subflow_get_se
 
 		ratio = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32,
 				pace);
-		if (ratio < send_info[subflow->backup].ratio) {
-			send_info[subflow->backup].ssk = ssk;
-			send_info[subflow->backup].ratio = ratio;
+		if (ratio < send_info[backup].ratio) {
+			send_info[backup].ssk = ssk;
+			send_info[backup].ratio = ratio;
 		}
 	}
 


