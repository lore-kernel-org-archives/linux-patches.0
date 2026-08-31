Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E44963A5;
	Mon, 31 Aug 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183528; cv=none; b=b29a7s5wEics9nwpO1GDACoFCD6lkgJ8Td1rT8W2UWFnkXnyk44wrbEx6v1BHem33taqN0HHo3iq5ZSl1uOFnnBStFR00KtxpeugYbAQHwPQoEky4F9AKvWGW//r1KW/b7MfCwp6WmBZlX+YQWyC88l27l02IuNZWkKnUQd9vm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183528; c=relaxed/simple;
	bh=E7Y6aLPtEndy3r9z9dqmGMEyRhszKb6OhCl7GM7Vit4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEBFs4le+nQdGMDpmxq8yVLxw82jYr0Xyj5fYjkxnngsuT7XvRE1J6VPKEuIvBpaN1jlUix7bPRm/m1ZsBJJz7ha5mMZwTwisGjeWz5PFhPM5ChQbVkWraPo2Ea7BCaDs+mxpnYpnPUjhYJoP19LmmjswvcFJ3GcqJvhBnLwoE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWHnlDg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWHnlDg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3241F000E9;
	Mon, 31 Aug 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183526;
	bh=Tlnl/JOXNdnrnXc5s8meYKcnyLrhgcZgIQNcfOxvgow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWHnlDg3IPyRkiEhG3w6go1pgGqMl3Bd2RsmgUUOi9yD4JjDgDrVZdwZsHtfTOzyV
	 hyYH4Kl4mNw2sGJeZBLJxZTKkUW6fraxqp+KltmDuCZ+LvsWUZtcEfCgb+PlrI8wCX
	 tvjuNp0ikkz4adBZ+NYfYBttyJiC0CERwfZqGgPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rastislav Szabo <rastislav.szabo@isovalent.com>,
	David Ahern <dsahern@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 28/71] net/tcp: fix TCP-AO key deletion in VRFs
Date: Mon, 31 Aug 2026 15:33:53 +0200
Message-ID: <20260831133400.524302082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rastislav Szabo <rastislav.szabo@isovalent.com>

commit 94ad9e114a1c7b16ea418c1456ac3835e038ab3f upstream.

TCP-AO keys with TCP_AO_KEYF_IFINDEX store the VRF L3 interface index in
l3index. tcp_ao_del_cmd() validates the supplied ifindex, but does not
assign it to its local l3index before matching keys.

As a result, deleting a key scoped to a non-default VRF always fails with
ENOENT because it is matched against l3index 0.

Fixes: 248411b8cb89 ("net/tcp: Wire up l3index to TCP-AO")
Cc: stable@vger.kernel.org
Signed-off-by: Rastislav Szabo <rastislav.szabo@isovalent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260822201119.272269-1-rastislav.szabo@isovalent.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1825,6 +1825,9 @@ static int tcp_ao_del_cmd(struct sock *s
 	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
 		return -EINVAL;
 
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX)
+		l3index = cmd.ifindex;
+
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);


