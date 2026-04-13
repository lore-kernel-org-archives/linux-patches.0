Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA1E279334;
	Mon, 13 Apr 2026 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096586; cv=none; b=pNwQ5DBekn1TQx2Iz5sE/G9xwo5bs1kYv1u4KOje3KQjrXQkRcreiA0ZD+MsRZS8bcpDinLbDnsK9qN1KwKSyxS4k+HiacLJMgYGGUlUETO6DT2DyArkp09bFgTU9/66d9IS8PNJrNDFnklAHokTyVXyH60yOM4y5gvHBX6U4bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096586; c=relaxed/simple;
	bh=yiuEocXdkx/xGaPZsqd9PXP1mIbbFgBxZz2F1GZ6VZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzvviC/yRyTLN8D50kn0Xg+FY3EQ64/HGLhTeVVSfpOiZ6ijhRnvZp9WMAKUe4ThR8xDnGgHCCp9p7dopn9He6qw/QuSoZr06/GUY4zY+4v1+ARfbGWeLQ4C4VW1x3urfw6k5xW4aGvsGlEyT4xDDM6aBYyaoX1bb7varUzAGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIW9Rr+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIW9Rr+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AD5C2BCAF;
	Mon, 13 Apr 2026 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096586;
	bh=yiuEocXdkx/xGaPZsqd9PXP1mIbbFgBxZz2F1GZ6VZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIW9Rr+d/pdAA+xfZUdMUyUL45fnMfJqSbs/YjcISeaAvv9Vv/ArhSLl9L7EL+Emz
	 B5Hk/AY+8zWkcrLua9G7x39Y2i2G/VfeA0VRWHhlPG/cT9BZXZNbHcfO/0XEy9NFEd
	 CsWyHXzUpsE2k3PfXBrfU+RtPg3rEUhYnQN4ipxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 68/83] rxrpc: Fix rack timer warning to report unexpected mode
Date: Mon, 13 Apr 2026 18:00:36 +0200
Message-ID: <20260413155733.545213279@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 65b3ffe0972ed023acc3981a0f7e1ae5d0208bd3 upstream.

rxrpc_rack_timer_expired() clears call->rack_timer_mode to OFF before
the switch. The default case warning therefore always prints OFF and
doesn't identify the unexpected timer mode.

Log the saved mode value instead so the warning reports the actual
unexpected rack timer mode.

Fixes: 7c482665931b ("rxrpc: Implement RACK/TLP to deal with transmission stalls [RFC8985]")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-8-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input_rack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/input_rack.c
+++ b/net/rxrpc/input_rack.c
@@ -413,6 +413,6 @@ void rxrpc_rack_timer_expired(struct rxr
 		break;
 	//case RXRPC_CALL_RACKTIMER_ZEROWIN:
 	default:
-		pr_warn("Unexpected rack timer %u", call->rack_timer_mode);
+		pr_warn("Unexpected rack timer %u", mode);
 	}
 }


