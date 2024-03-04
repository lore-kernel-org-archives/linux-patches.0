Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4CF7A736;
	Mon,  4 Mar 2024 21:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587881; cv=none; b=YvDmE8HBE5pAR3w3ItZHvEUncWGH47ZJ3O1i3ThZxzY+fRIbXWhUChxWwc4BrgSFW9y1ME3GkFWWsl0dxuxXk26Fy0NbqF2r/Vi0czb+B8hsfbjTDDBEo2gqWMYc8OXRjdvbGYuNGSo/NAFUhXRLkJRa9BtcMY9ouBbJzpoYMQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587881; c=relaxed/simple;
	bh=sYgPJf14L5zr06qJN5/ARMQu0lfDLDDqprcRorYsurg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFGsUNjTu+REwSGcoCpC+Goa9GRdBrdxReAS//VZqVxujOnTqr/10hPHfhvv4DyyeWQ3CQ1ptUMvdOxr4OcZmJyAmTSpY24fLrEzSPiRC1nycPj33YaapY5N0R2ByxCqNKQQGf58xLP0GkXCgicGpTarbbMtZrmk2qrc758HfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH9HM1N7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH9HM1N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF586C433C7;
	Mon,  4 Mar 2024 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587881;
	bh=sYgPJf14L5zr06qJN5/ARMQu0lfDLDDqprcRorYsurg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JH9HM1N7EYvqEijv9xAvLWarbewsfgCyCZ/tNEIeEumXiTcqUK0pBH+Y1NBYD//Wi
	 Ohh3uVif/F6A2PvYPSqtgV2sQghmaY9vKHnthK5x/RUJICIrzS5sdTbfyMLOI7ZKZC
	 6GSghZCBKcMCAnAhRP53fbTldZESm3ITXgi0C5pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 126/162] mptcp: fix snd_wnd initialization for passive socket
Date: Mon,  4 Mar 2024 21:23:11 +0000
Message-ID: <20240304211555.776488270@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit adf1bb78dab55e36d4d557aa2fb446ebcfe9e5ce upstream.

Such value should be inherited from the first subflow, but
passive sockets always used 'rsk_rcv_wnd'.

Fixes: 6f8a612a33e4 ("mptcp: keep track of advertised windows right edge")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-5-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3225,7 +3225,7 @@ struct sock *mptcp_sk_clone_init(const s
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
 	msk->snd_una = msk->write_seq;
-	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
+	msk->wnd_end = msk->snd_nxt + tcp_sk(ssk)->snd_wnd;
 	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 	mptcp_init_sched(msk, mptcp_sk(sk)->sched);
 


