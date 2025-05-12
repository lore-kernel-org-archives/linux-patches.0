Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A546F296D3A;
	Mon, 12 May 2025 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071757; cv=none; b=nenlRgvk1vVr1UU+pGGBW8czdJtOuXM53h8IRt/C+SMlZPlsmEcgc5qTz9I1I6psR+eBPJd1aGg8Q1W1F+In1vmCJebYp8gaqhNHMH5pkCMMvo4yGaksS77Lc4f9FKE35CQtAqwkqZh6RP2reKZljXYPR5wMiw0JyRXMpu8/bbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071757; c=relaxed/simple;
	bh=aD9FK11sMzuQBOgw034GkM68wOa/fz8h/AqjZQy7g+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fifLeJpCB4fxo0qZ3/P6AXqvZDv+AmpMqIbbJIu5irkbBzkpQxbnc/kh+GfcrP0xPasM92h0CVwhYMOwbFeqbIoLTko9c7sDLqBoxnupZq5Chbc0Q1zewmiUTKa45Vl7Umw3LxmynMj8dJJSd2hIIECNu/Fz7tLaSaDW5k2hpLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frb3nDk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frb3nDk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CA2C4CEE7;
	Mon, 12 May 2025 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071757;
	bh=aD9FK11sMzuQBOgw034GkM68wOa/fz8h/AqjZQy7g+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frb3nDk/bpTxx2bf5AKi0imcWBxB0sVB64r5wa7zvSiNRf3zfe0/ZYIjaZNf6RSB9
	 9+GHXJwgZjSgwF2L03JAiHEN5VvTcsDxuEx8yrWn7gd48vyvYGCvnM89NZz7I80Pxh
	 VkXjR16UxrHp2HXL+inNBo5kcEbNQeTqlopKxR5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/197] ksmbd: fix memory leak in parse_lease_state()
Date: Mon, 12 May 2025 19:37:47 +0200
Message-ID: <20250512172045.045954789@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong1@huawei.com>

[ Upstream commit eb4447bcce915b43b691123118893fca4f372a8f ]

The previous patch that added bounds check for create lease context
introduced a memory leak. When the bounds check fails, the function
returns NULL without freeing the previously allocated lease_ctx_info
structure.

This patch fixes the issue by adding kfree(lreq) before returning NULL
in both boundary check cases.

Fixes: bab703ed8472 ("ksmbd: add bounds check for create lease context")
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 81a29857b1e32..03f606afad93a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1496,7 +1496,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease_v2) - 4)
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
@@ -1512,7 +1512,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease))
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
@@ -1521,6 +1521,9 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->version = 1;
 	}
 	return lreq;
+err_out:
+	kfree(lreq);
+	return NULL;
 }
 
 /**
-- 
2.39.5



