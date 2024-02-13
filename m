Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158C57885;
	Tue, 13 Feb 2024 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846055; cv=none; b=PxCfa3LTr0DKR9nivBRJfMsHdR9gsy4NpW65pRLYYk1XvweVNzaP/nSWtLmqhDmJ3XkPNfqg+kpGvPxPtJvzhC8Vy3DP+/pDPlHEBWbe/yjBEsDQ+8mjmlWQylDZcN5YR8M1MI7R7wgIyhmmO9gFpedvOK6GBYh9BcD3I0SmQb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846055; c=relaxed/simple;
	bh=Sd9CLlPoRS75YYDQ+Y747ljqjeQmBo+XdoXXJqwonrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG4VEFCGtt0GnfRqfHXo71aq2Km3gYjkMVseLhe5VB+dMJJnALrWue90X/MLeaP5Nyt+ba7ldWT6NV39Fk3S+S3oeOvto2UAf7AHgeTeE+WnFIZ+oejdv1TvFmHg5k4vme/WyoxwvhSBSsBbAfxSx0aw0faRwmhzC67abncng6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhOU/cN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhOU/cN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31656C433F1;
	Tue, 13 Feb 2024 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846055;
	bh=Sd9CLlPoRS75YYDQ+Y747ljqjeQmBo+XdoXXJqwonrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhOU/cN5s+lhkANmKp/2CmClDeke87ahgsIWegYJIjjoB5Q9i1Y770avMPAi40+K3
	 SGvhhP7nwAYXQNvZQcoWz/7iA1aCbPL4TByQDoPfwjZMUzczykTgTbkNdnRV1OIDL1
	 9TIAqWyV63cWnkZmEjORRuhjM85TgpflMDOrdwss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	regressions@lists.linux.dev,
	Michael Lass <bevan@bi-co.net>,
	Jeffrey Altman <jaltman@auristor.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 124/124] net: Fix from address in memcpy_to_iter_csum()
Date: Tue, 13 Feb 2024 18:22:26 +0100
Message-ID: <20240213171857.348322363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lass <bevan@bi-co.net>

commit fe92f874f09145a6951deacaa4961390238bbe0d upstream.

While inlining csum_and_memcpy() into memcpy_to_iter_csum(), the from
address passed to csum_partial_copy_nocheck() was accidentally changed.
This causes a regression in applications using UDP, as for example
OpenAFS, causing loss of datagrams.

Fixes: dc32bff195b4 ("iov_iter, net: Fold in csum_and_memcpy()")
Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Cc: regressions@lists.linux.dev
Signed-off-by: Michael Lass <bevan@bi-co.net>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -751,7 +751,7 @@ size_t memcpy_to_iter_csum(void *iter_to
 			   size_t len, void *from, void *priv2)
 {
 	__wsum *csum = priv2;
-	__wsum next = csum_partial_copy_nocheck(from, iter_to, len);
+	__wsum next = csum_partial_copy_nocheck(from + progress, iter_to, len);
 
 	*csum = csum_block_add(*csum, next, progress);
 	return 0;


