Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB31A840E;
	Wed,  5 Mar 2025 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198001; cv=none; b=Jeqm+IZmIYKd88/7X11kg74/UIdGihgoe+5IXKTulPSkgBm/YG23upMmtd3Tnnd3PlBlbv3WGje8ZHKU7vXlg1aucYe77t3PYq+e3V44iup0sEUsck0MTvzyMU/egKH4kNDwxEqb8fWzhTmXWAoLCgwttjbNb7IbvgtATOF4WzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198001; c=relaxed/simple;
	bh=AyP+5h13nORlhnUqTRKFHbWGAoKedNnKvST8aka+wVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLOx2Qdj6zQ4jLwo2N3n4/yP+jF4UANPSE57PU5u8x15Ppi+Bl1/Do8ecXzibTGr4QeB/XEX0GE/zSP+Nl8eoZHGVYT/PWX+B86T99KGdku5M0gJr3uma7XOrZt3PVm1HzsgrqMmAmqPZVlVCuUGEzDZqDYOeXYIRMmtpzk3yi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3aOia5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3aOia5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF7CC4CED1;
	Wed,  5 Mar 2025 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198001;
	bh=AyP+5h13nORlhnUqTRKFHbWGAoKedNnKvST8aka+wVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3aOia5SGciA0nTYg6TTIpDoSLCaypuEbci1Lw49vK1FsIwHnxqQ/QeQ6MDOYTvZK
	 l15xhGzO6r7NgJ64YMaeMRtCUJUbq65Tn9KfdBqogifVyJSpGFdVkzQ5wtM5iGIXGm
	 ytUSqLmypvzUW0j7pcd+NEgby1VB1J7DSG1AYclU=
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
Subject: [PATCH 6.12 030/150] rxrpc: rxperf: Fix missing decoding of terminal magic cookie
Date: Wed,  5 Mar 2025 18:47:39 +0100
Message-ID: <20250305174505.026416343@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



