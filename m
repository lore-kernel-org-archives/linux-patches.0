Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8A3271464;
	Mon, 13 Apr 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096400; cv=none; b=NiylVuGSXN9pKBeudMucEIeqm8UcxmV13X9gUA5PPaKyRUiu/ZZ9Sr5X1FQ7kMESZ85TOH0Thu4er86DXJUGiuyN55qEx4NanFruTyooFIvV+a1iUEvP1cvyPb0f8r3XE4zyrpY8/Pcg7yNOog8s0AO92v6u9fdBtIWn34H/kvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096400; c=relaxed/simple;
	bh=V2yHaPuww0XSJnCIky4r9UtouZSje0RTz6/ZkrKjC3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1h5JW+krRfdYdxc2BBSuR5GqG2tOVOMWXWnf2440AsBYd9RWSX+teMpKVv6m3uGJOfFt59Jo+tpkyL984xxX61karO0XNSnMoz3+BOMpW05qqGz1e19QmJOJorgu3cVoQladvJ16ZPJBOFI7LgY3UKCiprIq7RVugLhr6zgrjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGdfgIPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGdfgIPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725DFC2BCB0;
	Mon, 13 Apr 2026 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096400;
	bh=V2yHaPuww0XSJnCIky4r9UtouZSje0RTz6/ZkrKjC3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGdfgIPkueOhHBPGbjdaxi5OyYZxGG6n30WrHinXQMRaUY2I6IYYw/Jsx3Heqts5g
	 /8JUZYh0LaH4EQe1jXorX0p6U2cqbvtYBp6FF4nxdk/+WwyFHBfaQUufeaE0Jan84H
	 qbZ7OzjaP3B61/FqO6UeInJzPcx3vFxVqz0wEJbE=
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
Subject: [PATCH 6.19 66/86] rxrpc: Fix key parsing memleak
Date: Mon, 13 Apr 2026 18:00:13 +0200
Message-ID: <20260413155734.017046395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


