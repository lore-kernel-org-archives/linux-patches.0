Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CDA3346BD;
	Mon, 29 Dec 2025 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026024; cv=none; b=tl50gFNH2/YxbBDPUuU0xFQ6pYhJ16mMfsVMpLMXdsnOU45N+ZJ2eJhtIbpXdr/EhWP1peDKJ8Uu78YfYNDB/ugYm7fE7EVXKgUKn4vXTKEuxB55WQpO/vJLq7/RCCxbGBqQqnOCQd9sE6pcc/yIgFnUTimKgpFu78JzTT8cR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026024; c=relaxed/simple;
	bh=yMbIPaNGp0CtT5GNs4Ay90/hLvPzTs4xng70KveKV5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alJFm4+yksl0vs2RwsWCDQwlLuasgBZKbRTaXo18m9Fr+2S8Exi7S21s7H6OJtTuB9AYdtmVKjdCLsCDcgnX80YRBrHl9W+PKYbG/UF4Fj9+Kvsbw7/YJHOWehcvsiRZm3tnJxBpUEqsPMV01PrEzzuOoNHf5pe87Xf0L//OMIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMv0xVr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMv0xVr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEF4C4CEF7;
	Mon, 29 Dec 2025 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026024;
	bh=yMbIPaNGp0CtT5GNs4Ay90/hLvPzTs4xng70KveKV5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMv0xVr3z14sZ4vGdKHSZVrYOCHkMVTNyPheexDBF54LH1VHVvXUDBJgTtvMPh/tE
	 /YIumHyQ1MJskRh1eM/9CWnw5SGw7wa6Qpu6eCYdI/j+MB7+q2eKmXtZMFy5BGioyJ
	 k7BCLbl1vgVJRF4/kJiIdTSK4paqd0iNeewwDq6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 377/430] SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf
Date: Mon, 29 Dec 2025 17:12:59 +0100
Message-ID: <20251229160738.193930532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit d4b69a6186b215d2dc1ebcab965ed88e8d41768d upstream.

A zero length gss_token results in pages == 0 and in_token->pages[0]
is NULL. The code unconditionally evaluates
page_address(in_token->pages[0]) for the initial memcpy, which can
dereference NULL even when the copy length is 0. Guard the first
memcpy so it only runs when length > 0.

Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1083,7 +1083,8 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, (char *)xdr->end - (char *)xdr->p);
-	memcpy(page_address(in_token->pages[0]), xdr->p, length);
+	if (length)
+		memcpy(page_address(in_token->pages[0]), xdr->p, length);
 	inlen -= length;
 
 	to_offs = length;


