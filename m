Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828903;
	b=d+qs4XgRQfFzBkziR+z7w3woyull+nulkLshfTqpYuE4A8iQIdoTxqQqTN4PahGDvIDO
	 Izmwg4XxhSqEisLbczPNU4K37Ql6bACs+8aJ8n560ubxbgg7G6oCbbn6wKHc5i6L/K/JB
	 MB7wWWQDdSsBIOkrqNd0jHOAvICEuRJc8OA5hnufzveSI8u4cU62APGkMaBuC+mQWQ2P1
	 72ijGZfLidJaYieh0I/gg02ftesxU6N4mam47brzon7BO9LKzy2DD8FJxJA4SZu1u6phc
	 NNCKdQ1VeJCIG68PATgAE7l1Rs/7u3grC6WEV1W5IWCwgwMM6EuLv3mwgOHn/YQeeyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Av0xNTCFD9GUSAf3UPNr9o9EkOAoWoN246MqKpq0rbI=;
	b=gXvewmHGyaSPnLQgNU+OYX1+YiivGNCm0kv9zh3QKHzR8kQ5AuAT15VAMeKt+a5K9SgQ
	 Z0XiziMbjOlXLlvRIJCA/NrcbvU5xUCL2sbGmRZniGfyjMfE8vnoqbLN4ARp6iiaQC7vp
	 WBcJLOnl4omJdE1eCUywfykg1xmNlPhUqnHDQav6qk1j8WAOFMvcr+FoOa+xIwm/5TAwM
	 0i6G55hQ5Ox963ZUZDImBEQzaXykWqrq3RL6RODYchu181+hfF8r9uZVu7UmttRQby2H0
	 D/RaB5hHHmqOneH87qjwrvJHU+imQXk3A4sPJm1878ds9aIwynaK9/uHWE5pxHGecCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGA2irXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD24606A33A;
	Wed,  4 Nov 2026 21:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGA2irXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD1C1F000C1;
	Wed,  4 Nov 2026 21:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828903;
	bh=Av0xNTCFD9GUSAf3UPNr9o9EkOAoWoN246MqKpq0rbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGA2irXpxMRGupF+YKyVI62Hr5WT5Gi5CCU17Nka/J0+JGt9eR2NSqWd4spOfIJTr
	 u0ZXsE9CDYj6eRqbIxSIPs7MkirP/biGgKWBsjjyqpw+Fg1KOu7C4Cu6C0KqnnZEQt
	 oaJEjuiVETYaHzJpNCbfzKj3/+lCE5tOaTBGfJhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 316/547] xfs: dont fix the directory tree if live update fails
Date: Wed,  4 Nov 2026 16:08:20 -0500
Message-ID: <20261104211047.194326654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c8226f3d1a7eafe472addc232689e9c9a0c36a1c upstream.

LOLLM complains that we don't double-check dl->aborted one last time to
before committing repairs to the filesystem.  This is important because
the live update handler could have set ->aborted if it encountered a
runtime error.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -427,6 +427,11 @@ again:
 		error = -ESTALE;
 		goto out_trans_cancel;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans_cancel;
+	}
 	xrep_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETING);
 	mutex_unlock(&dl->lock);
 


