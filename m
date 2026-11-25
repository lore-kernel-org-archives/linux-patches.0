Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626330;
	b=0eGzIr1ROGr9psyeg5oQVNP+E/5YGYBMtlBjoDgKRIAPx6I7Y6SbLAEYyrNWdOxw3let
	 B3gwIRpxGcBfH+2458N5i/urnpS+CBCl6OPHwFXyeBMZUGEmloItA091DuuQt/vnpMHQ3
	 Ur4xuKJ6IE/v6SUKEbKLXHB+bdPHxb9ZJIRaawdK6UnOkq/b+w5W41Okc9ypL78NHb15K
	 Dpnc4nr06Nh/zAoNLbg58subri082ZeUaFAcWZEfqLla7kv37svk75VFw5CBtcTv8AfxE
	 W83LWwA3hkXs3SbahMzUx3xHDc803Zgz9sOgUJWmaFJJZYWv5dbVT5HZ3xrY8i5dwew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PGSCi8MEJjy4f5OYFxlAc3/s8bCNmcpLK/40SgoDhQA=;
	b=Dx9uLc0r2Uamta71CEI1vWUykpzvKdmWgdr2F4fNPbPr++kvZ1WBtQqNUSSf6CGYbWc4
	 cqhAiAAyBC2NI0l+7G5s4DlwSQYiUQ9qAgAS++ScxWgze/yZvrzo868zPPG9neSo12tZY
	 QmWhpHR0MELFyQfuyHKOpl9KjLuDxXgFHypdQxH9UQ6oum8YljOC8U4ZbLXCHjfHHkqxn
	 vjeUX6gyl62yGwYi1PO+XzxeQGT894vc1rWI4xiAdkyb96TtTCIgiy7FNdMUEclhaSOYV
	 X0bNlO5Ox70y/UOQgyEtzUNuGxkvl5+vZ0TkNd/RrIf4mfPkkVN+PIdRyE9k1nHgrTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yu1pw2vO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3AA606A33D;
	Wed, 25 Nov 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yu1pw2vO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA44B1F000C0;
	Wed, 25 Nov 2026 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626330;
	bh=PGSCi8MEJjy4f5OYFxlAc3/s8bCNmcpLK/40SgoDhQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yu1pw2vO8zH1vBQSUNnMnShcq4E+6XglrxP5XTUoVhCBOcsnxSjHA05gL2tdUQja8
	 a1rc/crxMgx/nitt5BlYGs0W4dpurJ+TxU0TSi9nKlgV/9UlPSpYZbYFSnVDjoWMou
	 sbML3oMXp43mEruuMH9JjDuNforIAe0NlER8DZd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sandeen@redhat.com,
	Stefano Garzarella <sgarzare@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.12 809/816] 9p: fix privport option setting wrong RDMA field
Date: Wed, 25 Nov 2026 15:39:17 +0100
Message-ID: <20261125143907.894725387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit 7fb9bd3659051ff74a29387de0023bb8300e4aa7 upstream.

While reviewing a patch adding vsock transport to 9p, I noticed that
since commit 1f3e4142c0eb ("9p: convert to the new mount API"), the
Opt_privport case incorrectly sets rdma_opts->port instead of
rdma_opts->privport, so mounting with the privport option overwrites
the RDMA port number instead of enabling privileged port usage.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Cc: stable@vger.kernel.org
Cc: sandeen@redhat.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20260703102254.114446-1-sgarzare@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -370,7 +370,7 @@ int v9fs_parse_param(struct fs_context *
 		break;
 	case Opt_privport:
 		fd_opts->privport = true;
-		rdma_opts->port = true;
+		rdma_opts->privport = true;
 		break;
 	}
 


