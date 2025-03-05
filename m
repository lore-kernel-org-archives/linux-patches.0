Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF572512D9;
	Wed,  5 Mar 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197529; cv=none; b=sc6teZUlelhKLhZsaUxiH5n9vFyuqmXphfH9a0K06eCowhmGuBKDIaidLxtq36rBQVX+iNIZ9WtVcAbG9QADilV+V64D/j37FOa7JWXkPsr6IKVvJY0rfpBWFqBT133Ag9+R6NYUSFusMN+R+jQUR7GJ0wcC2x+5G+7JgHwkq5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197529; c=relaxed/simple;
	bh=pmWvqM4LOunEwUSjeSnyQsWqoL5BnsOQHU29jCI0Tvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlzRXnELha7Ffu8eNITpYk7l4Syu3tSqXsG4Lcx7cHmXTyg5apyAjOwK5odTWytA6MAqRWXl7SCgjMlw0tKcDwiemwRWZInDQFWTeYpMyQGS7gGFi2pKfM/CBdnk8n91dcXKvsoo+rW2CHFYco923h9qO2+hyTMBcP1oRT9PKOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4tv373g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4tv373g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7CCC4CED1;
	Wed,  5 Mar 2025 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197528;
	bh=pmWvqM4LOunEwUSjeSnyQsWqoL5BnsOQHU29jCI0Tvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4tv373gYAQDPFTKroHzvv5C1qJ/L22ZR64K9QgVyFb5+BB4XRyRbtB6YpcsYVj0p
	 VCRC4Qxw4mk0uvpMsuQwMogur6V2MBLTCFoo/7ccZ4C6NyJ37O9fPMGTO1gXRLdvXn
	 38eF3ff+VCIkjAlrb8bY8wvqtnycGhgpZj7QACHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/142] SUNRPC: Handle -ETIMEDOUT return from tlshd
Date: Wed,  5 Mar 2025 18:47:10 +0100
Message-ID: <20250305174500.790356539@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 7a2f6f7687c5f7083a35317cddec5ad9fa491443 ]

If the TLS handshake attempt returns -ETIMEDOUT, we currently translate
that error into -EACCES.  This becomes problematic for cases where the RPC
layer is attempting to re-connect in paths that don't resonably handle
-EACCES, for example: writeback.  The RPC layer can handle -ETIMEDOUT quite
well, however - so if the handshake returns this error let's just pass it
along.

Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1c4bc8234ea87..29df05879c8e9 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2561,7 +2561,15 @@ static void xs_tls_handshake_done(void *data, int status, key_serial_t peerid)
 	struct sock_xprt *lower_transport =
 				container_of(lower_xprt, struct sock_xprt, xprt);
 
-	lower_transport->xprt_err = status ? -EACCES : 0;
+	switch (status) {
+	case 0:
+	case -EACCES:
+	case -ETIMEDOUT:
+		lower_transport->xprt_err = status;
+		break;
+	default:
+		lower_transport->xprt_err = -EACCES;
+	}
 	complete(&lower_transport->handshake_done);
 	xprt_put(lower_xprt);
 }
-- 
2.39.5



