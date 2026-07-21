Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D763368AB;
	Tue, 21 Jul 2026 17:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655684; cv=none; b=bdEhp1H/4pFSwvXj4VUdW2FrPlRSooGJ4qH7VbqWEVmatWTmEyxheF4GiONL8n4ATfd8Ngwai3vp1GV0ri2qilTRq0UwA74OS0NZ5sU/7LorhzVMfpsaoDJaXDArG3CB3hWn3sDFIwqsaG0i7+X92BGJJADrTVJ/nomC8/eNWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655684; c=relaxed/simple;
	bh=xbLKd7pcS07OqfUWNU81zU7upbj2ImPkqU6fsaVfvTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3oYk4xLfRF7VORelDki41U0mV2u8Ji9sKRNjDxI49cxGHsUyhOmqqJxGLSny4UFqfPHl4Pm32dwwGm30XN2AcsS+w29d0+xSP0oSneeWfUA+Fm9xbJ+RLoSaCXGu9yo8s3Wi2LLaxM3RQafc2J3sS/FmRNB4zZA95hBMBbubL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyR5k/gV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyR5k/gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6291F000E9;
	Tue, 21 Jul 2026 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655683;
	bh=hvg3xklCYhCTDh/hp7pY3y72CqdrSqUOkiSGQnqvU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyR5k/gV9JpeYo20h0y1JkAcxZ3x+6BRDf6hijWQpxkCMaeNsuHZnCVqG12dgurGD
	 mZDZXLL5prYMWkmHjJAgL/2oHOs9pXpLPyOVvqYuidNbvWPa8AiKj58QrtP8k5QrGR
	 7qvklypFN1FqhndnpQ9ZmVb9FbMES0RGXrMl7NzM=
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
Subject: [PATCH 6.18 0048/1611] rxrpc: Fix leak of connection from OOB challenge
Date: Tue, 21 Jul 2026 17:02:44 +0200
Message-ID: <20260721152515.904494956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


