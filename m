Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB81C6AB;
	Mon,  4 Mar 2024 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589332; cv=none; b=L8NI/hzCxRhkl2qPict8qyD/jiIfgYaFMNlDL/onIq6i9HdLrctkAGc/fYMJd2sfbxa4PcFDct+oJAfzqWBUBro0sCJiWAyNKF7ItWMSGgV4+lo4QIGGoujnMinXGnpiU0TyO7JL43mzC92q2pFhujpX4eAvVXiGJvhWydPuArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589332; c=relaxed/simple;
	bh=HLNvujSnKNjDa3V69NJoBfSAqhM53TLEB4+1u1qLO/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7bqYYSYLlCvnqOhtnY946Dd5Rv/8Oh5O7dijTGlCTIwI/anM8Aewdq98wYWslOtTQrpL7B6ccj+Q/pdsZNwvn7hGFD0O2XcdISdiy05/VjpwDjRznWT+8L/MYQ9r+YlEpLhWIFq9lOOpGKamN7lbYEILQzjN3akb2zr4nysFj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0xMnf+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0xMnf+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C92C433F1;
	Mon,  4 Mar 2024 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589332;
	bh=HLNvujSnKNjDa3V69NJoBfSAqhM53TLEB4+1u1qLO/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0xMnf+5KXk60dz/qkJOJwAy5F1yYO/XhGAMk7ym1ML9YNLofjP5Iho/ZS6IL67pm
	 wtSzh0KSBeEbVZkSmWJ901nvicxkAXMl0KjeV6YZ5rbf+UvzpZurv+wmmN7uqbXIPb
	 PadAR1cznxmZQZx7k6OsSKQb/Ctb16oYYacVjTaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 68/84] mptcp: push at DSS boundaries
Date: Mon,  4 Mar 2024 21:24:41 +0000
Message-ID: <20240304211544.662867554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit b9cd26f640a308ea314ad23532de9a8592cd09d2 upstream.

when inserting not contiguous data in the subflow write queue,
the protocol creates a new skb and prevent the TCP stack from
merging it later with already queued skbs by setting the EOR marker.

Still no push flag is explicitly set at the end of previous GSO
packet, making the aggregation on the receiver side sub-optimal -
and packetdrill self-tests less predictable.

Explicitly mark the end of not contiguous DSS with the push flag.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-4-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1350,6 +1350,7 @@ static int mptcp_sendmsg_frag(struct soc
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
 		if (!mptcp_skb_can_collapse_to(data_seq, skb, mpext)) {
 			TCP_SKB_CB(skb)->eor = 1;
+			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
 


