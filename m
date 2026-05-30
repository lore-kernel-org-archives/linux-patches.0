Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350331CA4E;
	Sat, 30 May 2026 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159706; cv=none; b=DyWgIHCOBc/o4wLzWRo52bhvr5SZmIuJfmx1XMSRSSFwF6+u/uA/cwr8lvHy+27gceouaWm08Six6l91kOhYekBzf4qExyCBb/lCaqqAo4deRGeWjKHsPlqZWwkTe4NeVgV2zIpLjx6iHWOk48UEv5jixtrXsc0udYAkBH+9Swg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159706; c=relaxed/simple;
	bh=2RS8hP7rtdeUXmGsBkS0xVsDR+xMeqIYhCYv6g8QEDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASfj14nlupFK977zQ2a8zn2ReuoGoAuI6ndfqDNnN37PrlSB/0LmIaNjJMrIhUs22XoxdqtbphTIJYw8PgcpF86whJsnHZzW0tMuCUoLYndwaubVjwMhgtUxk7wEkVR0MNHrHhy0tDBGweFjH4bes2/qiJs6hVFfL3ajJrxyv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiS0c/an; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiS0c/an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263AD1F00893;
	Sat, 30 May 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159704;
	bh=kzddMWggutwMdq6qle8KC/KctyKPsPdPLaaRoEeoxrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jiS0c/anQvZrKyvDlWhUKkdU6yBb8ScO6l3PJi3X+PLGl3HBc5yAZkU687qU0Sb3q
	 B+FuLPF6LZaU7V4wHzE0RHjr3uJ+qVdtchEQKmdEHzttcoC/+EMmL4nJTq2Hu7JWqt
	 GcoCQ9J/XV4aSzNgZItb+v1mgXujtacgtwzDpkz8=
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
Subject: [PATCH 6.1 141/969] rxrpc: Fix anonymous key handling
Date: Sat, 30 May 2026 17:54:25 +0200
Message-ID: <20260530160304.453510938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -624,7 +624,7 @@ rxrpc_new_client_call_for_sendmsg(struct
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
-	cp.key			= rx->key;
+	cp.key			= key;
 	cp.security_level	= rx->min_sec_level;
 	cp.exclusive		= rx->exclusive | p->exclusive;
 	cp.upgrade		= p->upgrade;


