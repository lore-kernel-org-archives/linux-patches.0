Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621932;
	b=UV0FH/6PXiLv/0unVjr0GyJRJ0X5ONkZmrCVjuo9qoO58JQ5x3awIwVveDLOfs4k3ZHQ
	 TUgzAPmJ7+sI9CuHVetHhg6WRokEYnye1KMnwr4xHXih62d3ZJf2RiYtNE1uDlgIIi30M
	 onBPd7LheFnklQxkONPekOVmGhCagrcYPMqjxOhw55KpN5GwIzyfsIL8Yt9jbcRpTF+bK
	 sJNnaesbOgOe3Sl9K66AKqDQ3Cx7+i+evUdubanpJl1GQ/dHJ0dbYRxMZdiai4VptiQ3x
	 16VYXClozJcjN1VuKoBfji1RlpRsIKOuVBYSk/TMuNu8c3Nx9/p2ZYcwo0N6GlJ832Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzEF7o/omOWI8CNqY8iqKh2jI3TEz65v7IfHntqQQoU=;
	b=HYFt3dc0S2do+PEqlMykjI/zy2V9yhCrneKnkPVNx//o65B+/BZL+7yw1HemirCSkTim
	 ZooIdTDsOnBI2J5eUGGJz0vNR92cTlyNI0xnmY0kzt498XGn8MCwYxsuILTIYAqjRzaxJ
	 fb7NbC88SGQrWA8JdmSfffqx3Tc6aVDw6piupwGcg0RBGAVoduExHzsOrBarSeQp0/DPd
	 5TnOQFkvvtXniXVwhjBrhKOU97lRC57dBtlONYVV5j1v09nx7MK59jurYFNigECLfTsee
	 +qzsdmXMs48s09ahT5Y/xYhX7m/wN8ryXK3rWlpfK/G5C7dbo5OL4ZtHiutHp7039Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JD8Oxe/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BC6606A32E;
	Wed, 25 Nov 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JD8Oxe/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5899D1F000C0;
	Wed, 25 Nov 2026 15:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621932;
	bh=fzEF7o/omOWI8CNqY8iqKh2jI3TEz65v7IfHntqQQoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JD8Oxe/Atb3J19JcGPL3UhkDXAyeMhUcElDfrlfSjbqwoyxBIPFGiJIvf84vjOelJ
	 XZ2HNyAwm1fK2cIwpDNNxhUH+ysvp77QI0+5hnZDgvBVA6xEtv/quOLq5efQq3ZzUl
	 755sOxWNajpXzTwmRS0oVEe7183bbFPbzIM5Qjbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/990] NFSv4.1: retain MDS I/O until both thresholds are met
Date: Wed, 25 Nov 2026 15:29:05 +0100
Message-ID: <20261125143830.948438830@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit eab627dcd18a18a44a2cbee47df3058d3637ba0d ]

When both size and I/O thresholds are configured,
pnfs_within_mdsthreshold() uses size && io to decide whether to
keep I/O on the MDS. Both variables indicate an unmet threshold,
so reaching only one threshold returns false and may trigger
pNFS layout acquisition while the other threshold remains unmet.

Use logical OR instead of AND to stay with MDS I/O until both
thresholds are met, as recommended by RFC 8881 Section 5.12.6.
The new RFC contains the same threshold selection rule as RFC
5661 which is referenced in function comment.

Fixes: d23d61c8d351 ("NFSv4.1 test the mdsthreshold hint parameters")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 3d2d219a24e47..e389fb5159d67 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2059,7 +2059,7 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 		break;
 	}
 	if (size_set && io_set) {
-		if (size && io)
+		if (size || io)
 			ret = true;
 	} else if (size || io)
 		ret = true;
-- 
2.53.0



