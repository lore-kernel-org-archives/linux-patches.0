Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538FB3AF666;
	Sat, 17 Oct 2026 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256075; cv=none; b=qcDUoHW8rwOKsoiLj0DmSTMwtAU/irOnNR98Ti8OwS8gDC+vYzEj275KDTplONoHPK7zE8fxCbULNps2/goCAaXQlDSv/EIGWHmfFx2oFpdUohJ8UCkm2Eb3u+km4YTmhDUK1trgSCTw03bI8Ppn9TNeNR4R+6fJPPWHmmsZe3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256075; c=relaxed/simple;
	bh=gQgRqcztmVnalLb0/XhDpluEK6hPYFbl04j0DXc6V/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMrwxZG3WYf7ADs/KgPCYcoAEsjz+Z7/RJa5z4Z+RAJkhVUew5n2F+L4W/s63l4hT13SyEtSBAocjsYWF7Z1zCdfbd9udtjZ2cO5CC/oW9yJaU6Lo5Wiy20RgdBPgwaHZ5fR1lH+5/U/BkhPDfc12WxV4X8QMie8VjJqjWdW7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMNPpwy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMNPpwy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DC71F000C4;
	Sat, 17 Oct 2026 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256074;
	bh=HVkZl7C+7YvXkc4O5dHq4Dz2Gj6O/xLGdDMk1gNbCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMNPpwy1FAGfptx+LVIOQgfu1wruVkF+paj1WzPqyH4W2NGCH3LTQwnQZEx8ziLFt
	 KT7hSasME2FQvmkKL9oTJDcilowGduxVowsMWbrfcgPpDZ3XUfSyQqYFgsrxzzbCUe
	 ULcqhaFjAHCJn7Ov0dGYrlisTzyQVu8A4qS0azl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Ou <oscarou@synology.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0073/1674] lockd: fix swapped arguments in nlmsvc_match_ip()
Date: Sat, 17 Oct 2026 17:39:05 +0200
Message-ID: <20261017160433.007284501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Oscar Ou <oscarou@synology.com>

[ Upstream commit b9060689f49dc663e9a3d069c4a65ff63a836e66 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c          | 2 +-
 include/linux/lockd/lockd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 9e2a67bfd0702..bba701e1a6089 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -493,7 +493,7 @@ EXPORT_SYMBOL_GPL(nlmsvc_unlock_all_by_sb);
 static int
 nlmsvc_match_ip(void *datap, struct nlm_host *host)
 {
-	return rpc_cmp_addr(nlm_srcaddr(host), datap);
+	return rpc_cmp_addr(nlm_srcaddr(datap), (struct sockaddr *)host);
 }
 
 /**
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index 0f016d69c996e..e1920a67d6572 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -268,7 +268,7 @@ void		  nsm_release(struct nsm_handle *nsm);
  * This is used in garbage collection and resource reclaim
  * A return value != 0 means destroy the lock/block/share
  */
-typedef int	  (*nlm_host_match_fn_t)(void *cur, struct nlm_host *ref);
+typedef int	  (*nlm_host_match_fn_t)(void *owner, struct nlm_host *ref);
 
 /*
  * Server-side lock handling
-- 
2.53.0



