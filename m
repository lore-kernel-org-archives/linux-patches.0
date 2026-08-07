Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E0472F98;
	Fri,  7 Aug 2026 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116901; cv=none; b=LEE9UNyI4lLQ2rfZkdtNUnH3iLZj9oB48CcztwuWMTewbPxSIlhHUNHYJnGzq1Jl1BofZZkI8XSwpHVW0ZBfrZX1BcZ1+65n7oNpnRH/70PpTmltjzR8/KMDRzxQLeEyvbOFIafUpisKj6qFxn09KD3JHEG61QvLoGiIRW7kaaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116901; c=relaxed/simple;
	bh=6DIIAh8D5ujmekgzABJeT5jczI6WppwcYjzuKEhvF4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKsMRXSeFQKn+godDBR6VOcmcV3InJQHnc4DVA+r21dr5tr4EFiVQugR2Uhc0fMGAtcgtnVZCVme0elMb/yzSswfzi0lFzgWGgRVoFWsYFN1HxL9hd8F4MlJHJruPovsJjCilECrND37aSB4tYAvMIGmw/5h3yQYXLm4lggJ7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXBJRBbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXBJRBbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2CF1F000E9;
	Fri,  7 Aug 2026 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116900;
	bh=QpXSjjos3cpZookPC+50RjY3eX+5H0K8yQ9FLDuyBws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXBJRBbfZV3sSHbqWHK+KzFX+13SFhKSSJuVfA6dtm0F3LPfJSNA3WzYQ7XN/RvcU
	 h9NRMhaAvoCMZK73C3Q91sfP29j9fup0ydm4kJfKdC9BkAtusbbsMZ51nce5jApBGK
	 Sc2wdgo9DevJhIhUhQDYFfypGlpAa14q4i+01CuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 131/438] Bluetooth: ISO: lock sk in iso_sock_getname
Date: Fri,  7 Aug 2026 16:35:27 +0200
Message-ID: <20260807143430.787876587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 89cf154d7c18e6e94a3da83051f3cf2bac317ae2 ]

Accessing iso_pi(sk)->conn requires lock_sock, which is not held here.

Fix by adding the lock/release.

Fixes: 2df108c227b2 ("Bluetooth: ISO: Fix using BT_SK_PA_SYNC to detect BIS sockets")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f1399ddd6ad05..476c679791234 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1471,6 +1471,8 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	lock_sock(sk);
+
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
@@ -1492,6 +1494,8 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 		sa->iso_bdaddr_type = iso_pi(sk)->src_type;
 	}
 
+	release_sock(sk);
+
 	return len;
 }
 
-- 
2.53.0



