Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DA2351C04;
	Fri,  4 Sep 2026 05:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499636; cv=none; b=ig8A98ScC6rNTsJ8gSJjwPNkT1kmlO8P9lGAEWEQQHaPvUOERdBYgNQ3olCPMrwYcGLPcNFxpEXKixXBhPpP7IQHyx6S6IowHxHPdw0yNtoWt0BFI0xssGCu6wMc0aHaqoKqQ1EMUq6s/1i0bbDzlfk61zuh3RgHLxVge7wGHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499636; c=relaxed/simple;
	bh=M9xYhpjLBY7H1gIZE7EliEUEk6d3Cn9ecJwhI/8ChVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhHJXyW/2aPMwLruyYJmWxSs9CWw4MMiGzTKkQQYqMudQh/7h88FgBqQFHNgV5PoLi+6QOWUqbKjH9+3isBDoPaEN6IckN2N54NewtW11892/0Bk2znAxf8d632WWKkZbPf9NULfcWXAKUIUvXOndWxA7INdFcXDj9wfE2QAE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cosrRSGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cosrRSGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1639D1F00A3D;
	Fri,  4 Sep 2026 05:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499635;
	bh=2uSEEaJraov9661jj3fxpsss+SajdZARYnAXE5Otu9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cosrRSGAUUV6XCRFnu8Pc4aDRPBSLn2rtsaQ0YDfBWRn536yvefQNla2rBwN0XhPQ
	 EvkVC8W4LmAA4U/XGEs0nwwy6Cnlp6LUWqDv/w5g8GPEhQ5B3WhqZO4IPCTMc1UycI
	 dXh4NMNfXy/T3yJlPkDbiSd9jbBtFkWkm3cVKd9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Ou <oscarou@synology.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 486/713] lockd: fix swapped arguments in nlmsvc_match_ip()
Date: Fri,  4 Sep 2026 06:57:34 +0200
Message-ID: <20260904045814.722935699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Oscar Ou <oscarou@synology.com>

commit b9060689f49dc663e9a3d069c4a65ff63a836e66 upstream.

When releasing locks by server IP address via /proc/fs/nfsd/unlock_ip,
nlmsvc_unlock_all_by_ip() calls nlm_traverse_files() with the server
sockaddr as the opaque @data argument:

	nlm_traverse_files(server_addr, nlmsvc_match_ip, NULL);

The match callback is later invoked from nlm_traverse_locks() as:

	match(lockhost, host);

where the first argument is the nlm_host that owns the lock, and the
second argument is the @data that was originally passed down (here the
server sockaddr).  This is the convention every other match callback
relies on (nlmsvc_mark_host(), nlmsvc_same_host(), nlmsvc_is_client()):
arg1 is the real nlm_host, arg2 is the caller-supplied reference value.

nlmsvc_match_ip() has had these two arguments reversed ever since the
unlock-by-IP feature was introduced in commit 4373ea84c84d ("lockd:
unlock lockd locks associated with a given server ip"):

	return rpc_cmp_addr(nlm_srcaddr(host), datap);

Here @host is actually the server sockaddr, so nlm_srcaddr(host)
dereferences a struct sockaddr as a struct nlm_host and reads garbage
at the offset of h_srcaddr; meanwhile @datap is actually the lock
owner's nlm_host but is compared as a sockaddr.  As a result the
comparison practically never matches and locks are not released for the
requested IP.

Swap the arguments so the lock owner's source address is compared
against the requested server address:

	return rpc_cmp_addr(nlm_srcaddr(datap), (struct sockaddr *)host);

Fixes: 4373ea84c84d ("lockd: unlock lockd locks associated with a given server ip")
Cc: stable@vger.kernel.org
Signed-off-by: Oscar Ou <oscarou@synology.com>
[ cel: fix the misleading typedef parameter names too ]
Link: https://patch.msgid.link/20260617075738.1151797-1-oscarou@synology.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/lockd.h   |    2 +-
 fs/lockd/svcsubs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/lockd/lockd.h
+++ b/fs/lockd/lockd.h
@@ -314,7 +314,7 @@ void		  nsm_release(struct nsm_handle *n
  * This is used in garbage collection and resource reclaim
  * A return value != 0 means destroy the lock/block/share
  */
-typedef int	  (*nlm_host_match_fn_t)(void *cur, struct nlm_host *ref);
+typedef int	  (*nlm_host_match_fn_t)(void *owner, struct nlm_host *ref);
 
 /*
  * Server-side lock handling
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -557,7 +557,7 @@ EXPORT_SYMBOL_GPL(nlmsvc_unlock_all_by_s
 static int
 nlmsvc_match_ip(void *datap, struct nlm_host *host)
 {
-	return rpc_cmp_addr(nlm_srcaddr(host), datap);
+	return rpc_cmp_addr(nlm_srcaddr(datap), (struct sockaddr *)host);
 }
 
 /**


