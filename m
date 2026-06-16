Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7860935AC3E;
	Tue, 16 Jun 2026 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635290; cv=none; b=XWCQG6UYlfm5d2EP6B4CSwYwJFGwfczwnOrGCn5WVGpChOZSQlyCFidPEBUxQZj4+IhvBbtuG0vHYJ3ufRoolFEnbteaceVssVkrwl/wXWxfbTg9T11LARc26YnEqhbTdqg3VmLyDByOxtx71F7uxAHD1EtIyGuZnjX8W0Ni4QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635290; c=relaxed/simple;
	bh=tvmRI61bevp0Kwguz+7mL8KPX0VtZ+E1beUUdOShvj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvYwGbeBZD75lPCmHWe0J9cJN9XZQUTHz7gA+CO8kFNf+qvT6HTXYraQp2RzUcbaZodHAiNTdD5MOvnZIS+xvqfSSc3lk2zzHpvEkD1UHxi9AM8nBrYbiPDfu61YvGTFN1F/JnYY7FfBSAcZgqf9O3hlOXWfTwAeEDVvyN1IfQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyL+JbQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyL+JbQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B181F000E9;
	Tue, 16 Jun 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635289;
	bh=NqxEM41YmoT8Ql/yP6YyaaFpN45xrGvWf7RNTbvk+MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyL+JbQHhyyLSYFy+e/9y/brju75if59EmsDsjVD9AUgJL+DNUTp/Fv87pYUlUcqw
	 7l/xFvoywweQ4IGlwXg6lv7ksiwwT6eWsnYY5xiURr0Tiaq7sf1ujEK6gYpBFGh4Or
	 N294yrAzsgrIhTnxZNDEH+DfxCjvwJ7vdZ2T0EY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/342] nfc: llcp: protect nfc_llcp_sock_unlink() calls
Date: Tue, 16 Jun 2026 20:25:02 +0530
Message-ID: <20260616145048.625628246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit a06b8044169f6d5c3eb34772c13d2c0c1b205352 ]

nfc_llcp_sock_link() is called in all paths (bind/connect) as a last
action, still protected with lock_sock().  When cleaning up in
llcp_sock_release(), call nfc_llcp_sock_unlink() in a mirrored way:
earlier and still under the lock_sock().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f4268b466190 ("nfc: llcp: Fix use-after-free in llcp_sock_release()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 6e1fba2084930e..dc96d751eb278f 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -626,6 +626,11 @@ static int llcp_sock_release(struct socket *sock)
 		}
 	}
 
+	if (sock->type == SOCK_RAW)
+		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else
+		nfc_llcp_sock_unlink(&local->sockets, sk);
+
 	if (llcp_sock->reserved_ssap < LLCP_SAP_MAX)
 		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
@@ -638,11 +643,6 @@ static int llcp_sock_release(struct socket *sock)
 	if (sk->sk_state == LLCP_DISCONNECTING)
 		return err;
 
-	if (sock->type == SOCK_RAW)
-		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
-	else
-		nfc_llcp_sock_unlink(&local->sockets, sk);
-
 out:
 	sock_orphan(sk);
 	sock_put(sk);
-- 
2.53.0



