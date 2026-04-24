Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763E43D5643;
	Fri, 24 Apr 2026 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037978; cv=none; b=Fee7DwXAID6pusv2anDVS4qzswu7hzUtVV51grMzVzmPVSmLsxJ4Iw/hCpj5ehFi9NcbDBnhGneXNT1bpHJh8S518GoLl6IZvRxzQ/b6xLmEKl0htpOf/vH/pQqyq7ofoFzqqJle0mgwMam1lJTmUKqwnpV8RcFrAiHhNuR7p0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037978; c=relaxed/simple;
	bh=VmW6Vn6rFZywdZ+8fcPzEmfwf5e+9mMV71E0uaBEFr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKcMf0y89bCf1BPf1nhRV7vLDzEW1LKTCYWr9B06F6065Igz7xMGKHkUCZxCtBgLxGu5rYOJ9f/5d1dgbVY3KP47xtK9/WrIb67z8wQpJnRZMs2O2XoJQXarbSAWTa3SZkyX/4+kJN5rv0qWL5Ksmu+RSp90e2crC14BrsCp+iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eur8WDoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eur8WDoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035ABC19425;
	Fri, 24 Apr 2026 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037978;
	bh=VmW6Vn6rFZywdZ+8fcPzEmfwf5e+9mMV71E0uaBEFr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eur8WDoVenji+3Gng3XPVHoZvfXepPIsS318FkI2eyEYgA5MtILTWTjk+eZaxaW1w
	 w5HZHI85nYikhrvfsyJ2CBenRdwX/Rmfd2DmR/pS762FS6sFg+1zvyGLyBL83i+ZsR
	 IA0BPI7rQPOQypAHxm1NbP/wphdDInSuB9VQj7II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/166] rxrpc: Fix anonymous key handling
Date: Fri, 24 Apr 2026 15:30:57 +0200
Message-ID: <20260424132602.967081354@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6a59d84b4fc2f27f7b40e348506cc686712e260b ]

In rxrpc_new_client_call_for_sendmsg(), a key with no payload is meant to
be substituted for a NULL key pointer, but the variable this is done with
is subsequently not used.

Fix this by using "key" rather than "rx->key" when filling in the
connection parameters.

Note that this only affects direct use of AF_RXRPC; the kAFS filesystem
doesn't use sendmsg() directly and so bypasses the issue.  Further,
AF_RXRPC passes a NULL key in if no key is set, so using an anonymous key
in that manner works.  Since this hasn't been noticed to this point, it
might be better just to remove the "key" variable and the code that sets it
- and, arguably, rxrpc_init_client_call_security() would be a better place
to handle it.

Fixes: 19ffa01c9c45 ("rxrpc: Use structs to hold connection params and protocol info")
Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/sendmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -590,7 +590,7 @@ rxrpc_new_client_call_for_sendmsg(struct
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
-	cp.key			= rx->key;
+	cp.key			= key;
 	cp.security_level	= rx->min_sec_level;
 	cp.exclusive		= rx->exclusive | p->exclusive;
 	cp.upgrade		= p->upgrade;


