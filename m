Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623042;
	b=Srt5dGPa/luDRTyV8X18SHRHlsPm7Byk5FwmkYRWwWogn/BWJro5TL7Mfy7ukum7Lklr
	 jkoet28XyHnVLS2HJjFACS/6RZp7KMIUlrfkFASCN+wkMLKzZ23tjFQn7cfWxDi1yUqLy
	 XubVZVbZAxoK98zVjTRBIa1GP/pMf2pNTEP9Lwz+tuD/1uIv3cvwP3g68GrXBAXJ20n02
	 SWFz1yJLgHhM243kVNyaRbzNYz60/UbUG8nytb/dnGtK5w7iy1bej4erl9KEypcRziNXm
	 7LyK4NM0Av71yQvxEmA46MTf8Zf3sQgWS8BDVfBbSjBsJGbKcN0qRzmoz8tUtK684Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k5KhiFozT1BTl1VTmCLf38pXFiRAF1oInY0FKOEEunA=;
	b=e08/PQcfOLuwAntSuTEVAslD8G66BOFNEYxaOoPqrnNhi7hFcthQo/ecDEyyoQtdZDsc
	 srK1tZ6hta6/pFyqcKgpbMK6ISZ6qAd6qCj1O1pE63o6ihKRrMEgtuCi2WdOVarjVSHCl
	 /r5crYf478AfaAWMmeRa1k6iNH0tO5BRv5mwtlv0Aq1jzoaJiFLhs4ZxPFjM85buBtxo/
	 48jGa2eqhcqBeWWGLrRnTmHw9jl7P4xPs8hixP/c/FzHiWiJgSZoJUR3f4wSdqWZlzuKW
	 RwsNJKbhqpboki11JpYyBWm/pVIgTUZ71iC+RcfVhvHzFCrK3JXFZUzrShY6WCJIQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COhOKOZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9837606A32A;
	Wed, 25 Nov 2026 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COhOKOZg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D41F000C0;
	Wed, 25 Nov 2026 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623042;
	bh=k5KhiFozT1BTl1VTmCLf38pXFiRAF1oInY0FKOEEunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COhOKOZgQtSGddwzymbwc5B8WhsBusL8SG/g+ZD+t6EYBcjeVmdwi4nZBfI+lNzVc
	 vRYaCOifzjMhr9No/vMi4f0M8uXFXMweai1DKcsxBWf80q68fddrzuZl39eD1RF0gM
	 wXeZDCmeejr9Qzgz0JD59HpAxlw+B167FTe9lkjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 729/990] netfs: dont hang a read whose retry is abandoned
Date: Wed, 25 Nov 2026 15:34:56 +0100
Message-ID: <20261125143839.147894064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit d1bb754ab9e775b0fbb2743d3df425c25a561114 upstream.

When ->prepare_read() fails while retrying a read, or a subrequest can't
be allocated, netfs_retry_read_subrequests() marks the remaining
subrequests failed without reissuing them.  If none was reissued in that
pass, nothing is in progress any more to wake the collector, which
returned after the retry, so an offloaded read (readahead, async direct
I/O) never completes and its folios stay locked.

Wake the collector after abandoning, so it collects the failed
subrequests and completes the request.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_retry.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -270,6 +270,7 @@ abandon:
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}
+	netfs_wake_collector(rreq);
 }
 
 /*


