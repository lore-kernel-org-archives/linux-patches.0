Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5B4556BA0;
	Mon, 31 Aug 2026 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184027; cv=none; b=Tgr6j3WKQiHC04vmsbNp4WmIsWRZi/Z7HMorvRT8bwY5xkrdacVdlqY5kRsLsAG8UgesE7WwzBAyMwOvTSG2V8ib3hd75yTQr6BrYeJLF7uHVbLGtpBE0wAMWIGbUK2Qlt9/avjj6xS5gCucOcMnUlYE4DoOelPG/NpUXpKQZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184027; c=relaxed/simple;
	bh=Af7SZLwO1KnBPVD+GrIFLdU31yq1+2cXZiE8Js99a1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1aaLIzaytAQmF29vwXOptJUSWEE4xUkWwMKt0SAQXQEVGN62PNQFEsQqtWenmvUkow8CyEBxFjnMyBpKNb3BOdq+KXw37j0euOWrCaaNetDs4zphSoxDx+XYAqFfiyEJE8SsLW3oLJQO3U+WEU5UfkYdmCR+eI36DHqWYhNyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6zO3irr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6zO3irr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53E81F00A3D;
	Mon, 31 Aug 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184025;
	bh=XRbFEee/jbbWACi0W86RL2fow0r8ab7Sf//ltAv9zR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6zO3irrZ4V20GcLZHETky+HnUtOnHPTkfTLRDr4uPkwZ/go6l+gIuiRNss0bWKTW
	 dD9entmpdSVreasRyKjlIibKleb1HTrKOZFatqaMQuTP+iN15WjkvcWr/NO75RD+Fq
	 jgVGI/9NyRmuRXdCi6lfWa/jHUFsCYNG0zJT1COs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rastislav Szabo <rastislav.szabo@isovalent.com>,
	David Ahern <dsahern@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 48/83] net/tcp: fix TCP-AO key deletion in VRFs
Date: Mon, 31 Aug 2026 15:34:24 +0200
Message-ID: <20260831133401.952674895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1854,6 +1854,9 @@ static int tcp_ao_del_cmd(struct sock *s
 	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
 		return -EINVAL;
 
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX)
+		l3index = cmd.ifindex;
+
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);


