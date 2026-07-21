Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F12D5436;
	Tue, 21 Jul 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655563; cv=none; b=OsWNBU/AJwxrvH7y/EGpLjj32FQVUg26DcfWUxJACwKCxo0p0XkcFUr9xMw3o+z/5OYqkgzm6KUnKfWkAcF6IHvLyKBFlq60buf6WQqJN6W5MHxq+TPTLD/vy3yTH9qB98iYCsdosvJNURrcOyR7mYJTsLtPEKAx8RiVYj0kIUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655563; c=relaxed/simple;
	bh=pJ6yMHqdckWOYuO2l/RSoHhQQD2I7bqDYqAa6RDexOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OE47/kZYTbGNHuKG9F9iKquJjX2bKIuj28DgJvDrMmvoPWGV4AB6sZ8H9arhv8SUs/aR5YU9gBsc9lm57HgrJ1Rg+oE+/4eL7rQxURvnFm/kmBtD+RLoGHFiI9Bd++fVeLbVNnB+ppRDGJz86uxGqN744ytAX8SqK1vHl9FMCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5Upa91s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5Upa91s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040201F000E9;
	Tue, 21 Jul 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655562;
	bh=90ubW8Ut6lQc0kxmnuY5KPkU6a6ffc26HO+jDjEBqi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5Upa91ssKXR0zrISic4BFv7hQp7WJl/q/egiGY0yzqY86mAttrstCQWyhEdcUJfm
	 djozDDTngHJ2cZgygHBQ+W8zsmZ9TOFTbHMsjnDKh0S/N8YGhYQeZAmcQ8wcxRMm9l
	 tmDUsBjLU/cNi6MdBfhxMKo/KMRP51Wty9A3rvS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0049/1611] rxrpc: Fix double unlock in rxrpc_recvmsg()
Date: Tue, 21 Jul 2026 17:02:45 +0200
Message-ID: <20260721152515.928157840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit a2f299b4d5510147fa8629a6aba2869bbcc88aea upstream.

Fix a double unlock in rxrpc_recvmsg() when dealing with OOB messages.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260609140911.838677-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -470,7 +470,7 @@ try_again:
 		release_sock(&rx->sk);
 		if (ret == -EAGAIN)
 			goto try_again;
-		goto error_no_call;
+		goto error_trace;
 	}
 
 	/* Find the next call and dequeue it if we're not just peeking.  If we


