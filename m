Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B33250C1A;
	Wed,  5 Mar 2025 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198530; cv=none; b=gVgr3pDpsmgNIxyo+TeSe8G1bGnyXSuAUMy2UipKOTs9XmeHsLKJM9DngF10mapPdaoPHNlQKnkBfTotIzFLTg4uN8ahmss5Cpxw5c1g2FnIbTXWsE6rre9wZgzU2F82Gkd2uCl/Ag+pSrtPc0HgJm+pWFf1qd+pbSWbiUixZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198530; c=relaxed/simple;
	bh=ImIQcrhIC52yCbhpKLw+EEuE5m5pmhAdXgdGPUgL5mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ho3GsTkU6ij/2Qugo7HLrZJJaKRSMHBK9HP9md0jL4sxacGtTDBVeF50j7A/aJXbD62JhRhTl5OsdvmMO93dnkaroaKoFRVhDL1OHjhynomV9Vse3IupCK+ozwywpAPMLbW55BMXoKFLbkxWLY2cB25P4uU2/6rRFd3rK2dUAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGvasc3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGvasc3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2B2C4CED1;
	Wed,  5 Mar 2025 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198530;
	bh=ImIQcrhIC52yCbhpKLw+EEuE5m5pmhAdXgdGPUgL5mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGvasc3TDqCt7Jw7zC5EqhDTTn9rrxKlKzINheRZWlBNQ7ru808tZ3b5ZF4qitQeD
	 NCzsHTBYegXgkZy8xUx6ylPwlRFVgrrkCTHwBSrpKLv+fK55OUeaz7c8w3b3AYUeAl
	 qUP13hPQUzE6TQOLVjd1YTV66x3xmyw5FStOPCbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/157] rxrpc: rxperf: Fix missing decoding of terminal magic cookie
Date: Wed,  5 Mar 2025 18:47:43 +0100
Message-ID: <20250305174506.385189068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c34d999ca3145d9fe858258cc3342ec493f47d2e ]

The rxperf RPCs seem to have a magic cookie at the end of the request that
was failing to be taken account of by the unmarshalling of the request.
Fix the rxperf code to expect this.

Fixes: 75bfdbf2fca3 ("rxrpc: Implement an in-kernel rxperf server for testing purposes")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250218192250.296870-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxperf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 085e7892d3104..b1536da2246b8 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -478,6 +478,18 @@ static int rxperf_deliver_request(struct rxperf_call *call)
 		call->unmarshal++;
 		fallthrough;
 	case 2:
+		ret = rxperf_extract_data(call, true);
+		if (ret < 0)
+			return ret;
+
+		/* Deal with the terminal magic cookie. */
+		call->iov_len = 4;
+		call->kvec[0].iov_len	= call->iov_len;
+		call->kvec[0].iov_base	= call->tmp;
+		iov_iter_kvec(&call->iter, READ, call->kvec, 1, call->iov_len);
+		call->unmarshal++;
+		fallthrough;
+	case 3:
 		ret = rxperf_extract_data(call, false);
 		if (ret < 0)
 			return ret;
-- 
2.39.5



