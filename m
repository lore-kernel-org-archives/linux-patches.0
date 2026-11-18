Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033412;
	b=ZUOwVqorUo/aKCsNedPtTFSUg1bX3bBeOde6qDBX0f30lm22aipZ+soblm6sCjo2vo5Z
	 BBdZRS3frT1afW7Ooh/xTZv4VMjz7hEx6Bhe3IqBa4ymQvne+Mpn7jHB2ws6CZZe05azW
	 tHWU6Wz31BzZxXdl0QkW0EYlYNrTBluss4zJK/gScw6gl02v2fzHUvANJbv/HdFKxsjjc
	 V/KMfAKuvcM0QffrS8RW17+00miDg5tOMBs9nbFRssiEaIHzPDMNH+S3olWhYjGuDbdYn
	 UFke8yrTfQUjEAm2b2dYJ8fHKAprkbriFLlLBvQud0WZXh5SuvwBIQMk5yqII6+Vq7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6LcY2wiFaaXrUFGukJCSPuiBTo6eNFYjtIi9RlwQQg=;
	b=WgUeZqiwVLOOVeAqA4yMFmzRo2r2zXNqND0lQU5sCxRgfFwJ90eCIpvYs0A6BK7DKC35
	 nTDA3sEpVogEt//lczBHSQaVgPQmoNH+3mlsKs6Bw/O222KpciqYbJ2uUkkIprCbPX1do
	 9OvD8ABmdsBnE+9a4iTewx1qMH2NeOOAV0Gst4ET0bytHrS0pUtG20tVwqpsDEF5fW+hY
	 uYOhfNHhz1uxHLocsZbornMmMKyqQbOOqh5KwdLIuH9ol90PSzzDsiSDoqRAZzv4vcUrY
	 h8pbxEujQktOlD+naWWdeHDlLOFdh5BtLhQnzSGn68sMs8ItpMseVohBMLFTEccQ5Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFW5N5VM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44205606A325;
	Wed, 18 Nov 2026 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFW5N5VM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545071F000C4;
	Wed, 18 Nov 2026 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033411;
	bh=M6LcY2wiFaaXrUFGukJCSPuiBTo6eNFYjtIi9RlwQQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFW5N5VMEeL575rldYroqggeEcyHpCQ01cXlBLJ/hfCmKHAzrLA33oeDXoUddnGQH
	 MASPMQSZ1wZtuuHcJ1krJB1ilngSqEELtTxv+o0iCyIlS0c39YntRYqRX2P7dwrSWv
	 mwGeJT0HYl5XBHA/8ingEsAWA9x3rRC6mybE7+kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 1741/1756] nvme-tcp: fix use-after-free of netns by kernel TCP socket.
Date: Wed, 18 Nov 2026 16:04:28 +0100
Message-ID: <20261118150118.853962006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit b013b817f32fb8c560b6970e1002e94f1c725923 upstream.

Commit 1be52169c348 ("nvme-tcp: fix selinux denied when calling
sock_sendmsg") converted sock_create() in nvme_tcp_alloc_queue()
to sock_create_kern().

sock_create_kern() creates a kernel socket, which does not hold
a reference to netns.  If the code does not manage the netns
lifetime properly, use-after-free could happen.

Also, TCP kernel socket with sk_net_refcnt 0 has a socket leak
problem: it remains FIN_WAIT_1 if it misses FIN after close()
because tcp_close() stops all timers.

To fix such problems, let's hold netns ref by sk_net_refcnt_upgrade().

We had the same issue in CIFS, SMC, etc, and applied the same
solution, see commit ef7134c7fc48 ("smb: client: Fix use-after-free
of network namespace.") and commit 9744d2bf1976 ("smc: Fix
use-after-free in tcp_write_timer_handler().").

Fixes: 1be52169c348 ("nvme-tcp: fix selinux denied when calling sock_sendmsg")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2048,6 +2048,8 @@ static int nvme_tcp_alloc_queue(struct n
 		ret = PTR_ERR(sock_file);
 		goto err_destroy_mutex;
 	}
+
+	sk_net_refcnt_upgrade(queue->sock->sk);
 	nvme_tcp_reclassify_socket(queue->sock);
 
 	/* Single syn retry */


