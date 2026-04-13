Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A93033F7;
	Mon, 13 Apr 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096573; cv=none; b=IfOQBwHXWM+2Tm0HhmjUW7QdoPhP9F1U/7Q7nhsi5JpMkSvpjcTwAjxfyKpu3qqxeXqZgZFdwFjYVrVZTg+b2M71OxLtEbDwPsg7AZYp3YpP0xvrt/8ZeXy3QCqfe+wg4buJ8dDnTypDYYDgtBIIXl1NONm5ByENOgeMSd/augk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096573; c=relaxed/simple;
	bh=SPg/ZU3QwT7Lcc0ENZ4EbtZNMAw3n0nBOxVmqMVIqto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYTujHYKhXWxMg7NdtMe+fEDIoLnoSxc++t5vW7IxadwzrUPmKMQY7eqstHGZxJ+vSLy2J+MvUjjJ6Kz/Ks2s7xKEumZVVUMZlYJq3m0a14P3SrwyPGrXnZ6TyXNBbjb5brHm4bDHG04P8GWA+ugdYgEH/m8e5663JDikbrSjhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z37zpEA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z37zpEA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91FDC2BCAF;
	Mon, 13 Apr 2026 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096573;
	bh=SPg/ZU3QwT7Lcc0ENZ4EbtZNMAw3n0nBOxVmqMVIqto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z37zpEA03CdX3jPo80oOvfNj5yd0IN8yQN94Cmkv7S9CIHlg+oFQcAi0L88J8++pL
	 wWR/+CQ2w9XtScrlATL0plPnnfNBBvW6hjeJAHEXDCIQr+bZuIJTFOuXWgj2KP4DOH
	 HpKBY/tZy3ZWEww3mkRQnroBjXGCkSmtcwvIdrGA=
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
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 63/83] rxrpc: Fix key parsing memleak
Date: Mon, 13 Apr 2026 18:00:31 +0200
Message-ID: <20260413155733.360775849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

commit b555912b9b21075e8298015f888ffe3ff60b1a97 upstream.

In rxrpc_preparse_xdr_yfs_rxgk(), the memory attached to token->rxgk can be
leaked in a few error paths after it's allocated.

Fix this by freeing it in the "reject_token:" case.

Fixes: 0ca100ff4df6 ("rxrpc: Add YFS RxGK (GSSAPI) security class")
Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -274,6 +274,7 @@ nomem_token:
 nomem:
 	return -ENOMEM;
 reject_token:
+	kfree(token->rxgk);
 	kfree(token);
 reject:
 	return -EKEYREJECTED;


