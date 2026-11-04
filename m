Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831165;
	b=c7ljHObQ3QBj+EhDsN2LMPipH0IFy52ZB3agu8d07b45eTA4+o/97ocznmaJ1WCyobcB
	 TNySnlB4YnHmrXAZgXQAu1TCKcLdoNcDpDuwExXS+den98jVbInyFMfVbYxEzziUCj0aN
	 54ridzIEsTTzEt/prLjPRR0ZSjuyokttvdemQKFwDpZ5j6mKJgHPFAaz2jNjaG+dCIGI9
	 kgOu+EoUqZpqtFTXhf9yU/rrW3iNhXd53GOF+dQ+IwJx+yehpb/y/nvkwONKZdvh9nKHk
	 iCciIZR+jAtu9LVPYbDDt1luHcLZdANxJ3uEnxddDyExFNgosDM9DNc0bserUi8i0qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EroVSU2v7Mg6UPFMk1ZaV9MoU5U8wWI4KRI3QqxbUpM=;
	b=xrklNoLPZX11okl4ncCIo8Ivmiu8WRMoKXBiUEJLn9v0Bewz92Ew2aUHnD5rFYsoabfs
	 oCMZ53zXP0bjby3OIVCqRkGZI421eeo5ohUNsL+J9aAvmeYLJ+QzY10Q/TZxaFa3D2qHT
	 jfUyXTGTH+CnHH/q8D03lAjk79SF4MwFt6XQfUzxVszN0FEqdFLpdj75dtv8t5y58WygE
	 72I+TBcBwBtuPTbYzk4hL25ZDzzUkNviMWPt6yybrOgruCJd+qxMbJF0eiew5o8ilZBSl
	 SnWC8srl13W0hPEVD251mDJUtyjHyz6pPhuzRKI4fMPPKP1WTYzwog/P8dAhnohkQ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XamXj88M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EC2606A845;
	Wed,  4 Nov 2026 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XamXj88M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C871F00919;
	Wed,  4 Nov 2026 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831165;
	bh=EroVSU2v7Mg6UPFMk1ZaV9MoU5U8wWI4KRI3QqxbUpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XamXj88MCdpb5WDfSA6bflSg1iAepHasiq4ZoizVPMtiNFLVXURTNd56ZsDejpNbd
	 HpGT+Ic8VkH5HIa0saWBsDl0mZNi3PRWTbP+61C7RGJw+JL39Z0buNB6Y1IWTJlWJ4
	 4bmiGK4xQ9nRJE1chsXWv+CzgMREeqyjnhZqRc9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0536/1005] xfs: fix integer overflow problem when setting large free areas
Date: Wed,  4 Nov 2026 16:04:29 -0500
Message-ID: <20261104211058.910197966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 7e55f84434f3a63d59feb8f89076d280ea9aa8e5 upstream.

LOLLM points out that the min_t comparison in xrep_rtbitmap_mark_free
operates on a 64-bit bitmap word offset quantity and a 32-bit
words-per-block ratio.  Unfortunately, I should have done the comparison
with the (64-bit) xrep_wordoff_t type, but used the 32-bit word count
type.  Oops.

Cc: stable@vger.kernel.org # v6.14
Fixes: 8defee8dff2b20 ("xfs: online repair of realtime bitmaps for a realtime group")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtbitmap_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -276,7 +276,7 @@ xrep_rtbitmap_mark_free(
 		xrep_wordoff_t	rem;
 		xrep_wordcnt_t	wordcnt;
 
-		wordcnt = min_t(xrep_wordcnt_t, nextwordoff - wordoff,
+		wordcnt = min_t(xrep_wordoff_t, nextwordoff - wordoff,
 				bufwsize);
 
 		/*


