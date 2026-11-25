Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623395;
	b=A1t7xvI4ytvFDiX3FPOLtmOPhWA60u205vCI/u5yx36wFyhBfM1bzJvFaOWLC2SiXwTC
	 0QUQYUaiwg29PV5UQ/4FZrHEgLoVS4EI7XYvdhBnj8X7KARg2BfUEWIHKSW9suujy3+UK
	 W4Yc2cieZXkTxnZSYrExYrdoIdDFLTxWjDfVsc3Czj3oECZPRfJIOlNQCFCSUS483bLn1
	 hL8xiSs7G+wbjw52czzYM2XkT9YUQfdcsZLd53l5PA6xXdPyNGjyBaROnoBc3/y+0bR/w
	 6V1obIICVHuKihMu8sh8pouK8iihWiYScOmkxerDUwgW07W8VSVGlRrRcwz161n72Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ht/p7XNXgobLYAlJYVz8ItZ4AIDXuDq10LIHibQRbhg=;
	b=xdi4WtSSQt/a/JA0cWDIfEIy0VTb6DO+oAKa0lRXSNGtr00LaThwh+On1nhPU03gbxhN
	 MlRIiac/CmLw2aWR//+xpjwT/yb6r3XnLYto7PUAZRBdnkq63ChTR8W8Ve7A1294dLWJR
	 T105rvGL+rkJwe4rCdfXeJ4C+LsY1sduUoz7iKmzzVA4133UyeaZ0xSyaDwn3ChRZfGUR
	 ZW0fdldAe7rGywzQrYuXQL6lx4wrB1miabs+s5JJqWlrIT35F71+MDJpo9u+bwjrF5Fxx
	 9IWPmgStlGllL2BT7R2sSvPlropzsiQR9JFmBdJgHmk+CrLYFZWKdTY5lI+CFgLZw4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDGnLOZw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F51606A321;
	Wed, 25 Nov 2026 16:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDGnLOZw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F0A1F000C4;
	Wed, 25 Nov 2026 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623394;
	bh=ht/p7XNXgobLYAlJYVz8ItZ4AIDXuDq10LIHibQRbhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDGnLOZwzdX7zjozwPCcKGGYSkt6Is2Ig6cwZfwmxEVPWxOY+C7UBY5GAbMlR/fqa
	 7ki2bdXnmJmKYgxPgMu0gVOMfD0Q82SxQZOfvWBwqDcLNG5AgK3XUofNInakHuxYfz
	 uQx7LQf9ECqJjdB3b4DI3ApMPH1k98U+gRIL31eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 846/990] smb: client: retry writes that couldnt be issued due to a reconnect
Date: Wed, 25 Nov 2026 15:36:53 +0100
Message-ID: <20261125143841.848924490@linuxfoundation.org>
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

commit 64db0dc1f3e689145e698bc1b20ee70b1724b945 upstream.

__cifs_issue_write() fails a subrequest with -EAGAIN when its handle got
invalidated or its credits belong to a session from before a reconnect,
both before sending anything.  netfs used to retry any -EAGAIN by itself,
but now only retries subrequests marked for it, so these writes fail and
their folios end writeback clean, losing the data.

Mark them for retry instead.  The retry gets the handle reopened and
fresh credits in cifs_prepare_write().

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -140,10 +140,12 @@ out:
 	return;
 
 fail:
-	if (rc == -EAGAIN)
+	if (rc == -EAGAIN) {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-	else
+		__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+	} else {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_fail);
+	}
 	add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
 	cifs_write_subrequest_terminated(wdata, rc);
 	goto out;


