Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B8D43E4A1;
	Tue, 16 Jun 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624079; cv=none; b=Z04e92LUkQBvE84z/FjADvAFwZvdZduocI3SYBpkYdx5HX5ROkhSiIDNEz1bnc3P5ZXcbI6eBftXvkOWYa1+NRuyR/euLG2xBrbe0GlNTe97ilMhvf9F4ZJKpHfGspCzPIKSxzl728AsBnCu397uLZyavYcyM8PaiLRbOmHa7ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624079; c=relaxed/simple;
	bh=LwXuOlZjAkxbHh1a2CnjnUD8zrwKRnN6hybca9/s2lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkH3/+4EIhuTTySxJ2c39F87/XgJxoRwqBHmkz3F5HWIeICMKn4bkoLLXyp8ULKbd0DD+d4cCo+724fWhil/JetDAcKR70Ztj1PCiU05B5L25MXLIHLcs8vLdDzKpeCz39h4d7oA/+f0nY4d+yVuwOw/Oo+ivZgDtNIhu9mPZVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9xizgLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9xizgLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B3F1F000E9;
	Tue, 16 Jun 2026 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624078;
	bh=w6EHnXSsePTQ2+6ghgCfKAUhzZYl4Xmm0CtD4sx7GtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9xizgLlCGIc7O8ggrXjlcb/4WbG0oRHziv/X5bQAH6BsWmhJNrbU5jTXWN+dRhQC
	 ASnZ7vu7Y+v/QIIjq91hMcExBnqy7yCZjhh7yvyCgaG+Ldh+ImOtz37NMVXNmfCMxi
	 Pr+Mn4lzNEY46sopth2TOVVjihvvTh0ZHcyXrSKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 235/378] mptcp: check desc->count in read_sock
Date: Tue, 16 Jun 2026 20:27:46 +0530
Message-ID: <20260616145122.613275555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

commit c378b1a6f8dd3e02eb08661f4d5d50f236eead03 upstream.

__tcp_read_sock() checks desc->count after each skb is consumed and
breaks the loop when it reaches 0. The MPTCP variant lacks this check.

This is a functional bug, other subsystems also rely on this check:
TLS strparser sets desc->count to 0 once a full TLS record is assembled
and depends on this break to stop reading.

Add the same desc->count check to __mptcp_read_sock(), mirroring
__tcp_read_sock().

Fixes: 250d9766a984 ("mptcp: implement .read_sock")
Cc: stable@vger.kernel.org
Co-developed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-9-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -4411,6 +4411,8 @@ static int __mptcp_read_sock(struct sock
 		}
 
 		mptcp_eat_recv_skb(sk, skb);
+		if (!desc->count)
+			break;
 	}
 
 	if (noack)


