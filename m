Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699FE46AA6A;
	Tue, 21 Jul 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647995; cv=none; b=DZZ9Vs8Ez3rrc1ucPSR215Sbi69w0vO7WNRPzx12QA5EGBJjI79dFYu4EycAcpecOFrCw4ugJj3+v/eqIMRcNraEHWbA49SFT9YER1J9ipngLdL8+WgrmolA/iRCc411x76/sIc/11PKpo+r6+n969RLJYpwiK2bMInaPr6o5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647995; c=relaxed/simple;
	bh=Xg5rCYdbU/oQBoejwfPGwBzwduj4VMGIgwMpFG/FEJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HG/aKqUkhAx+0MTbnJNddIHdC3+51cTkFnvMVjfRXuFuU9kH2QxOqnDy0drxJhAS7/R4auf1ujOvsGCtJJ77M/poq5NboKFCdkbYpVOlSRAz+/p0zJHIPAwl88O9Jz06bLpNYxbHkPecT6k41PqlirE4yCHWp1auSuZpAz1Y+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgA0q6/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgA0q6/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CFE1F000E9;
	Tue, 21 Jul 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647994;
	bh=X/JtiQKHUSNeS8sD0FKGIqTPI+pxxAA6HgxS2i/p6MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgA0q6/uk3UXegqn4/fWQnNP9DDyuHjsKLVZVtg7tw1wQHod9T7z96uahPC/sfT2L
	 IGiGuV+SB80nbPVj54xMHpCZr/uIIB5/KuVJ9mGVPsqHf4WYqFJl6tLyMEmxYZyPT8
	 Yc7caA2o3Ft4i7JmNM6MK6BSNluf3Tygtok8RsbI=
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
Subject: [PATCH 7.1 0032/2077] rxrpc: Fix leak of connection from OOB challenge
Date: Tue, 21 Jul 2026 16:55:05 +0200
Message-ID: <20260721152553.436010722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 4b28876e78fd60979afa91fd2ec6ad9cc8b7a6d0 upstream.

Fix leak of connection object from OOB challenge queue when response is
provided by userspace.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260609140911.838677-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/oob.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/rxrpc/oob.c
+++ b/net/rxrpc/oob.c
@@ -213,6 +213,11 @@ static int rxrpc_respond_to_oob(struct r
 		break;
 	}
 
+	switch (skb->mark) {
+	case RXRPC_OOB_CHALLENGE:
+		rxrpc_put_connection(sp->chall.conn, rxrpc_conn_put_oob);
+		break;
+	}
 	rxrpc_free_skb(skb, rxrpc_skb_put_oob);
 	return ret;
 }


