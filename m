Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063665;
	b=LBkENQZARmTVivDoH7Y/DeJUWl5kHNEXQsJBDOgFo7zmB5SGKcWC/umYpMR8XBANxMQE
	 ynXKWR3rf/MIvQnEXUvMLt8xF5Ya/luxIBFmIsDfDLioHTBH1MgvBoZmZ3+rw/yuZR9f8
	 VZyk3EzXPbcrTomAaRTq9I0EMgU719tdBzelT6pzHjCzcrZchtmqIarbOJujydEk9qFWM
	 F1ghdlXyLiR71+Xc3PPjsoCb+/9mgYoJ6Ggwjmop9CYm8vYIzkKm/5WeiBnlL2Kl2hAwi
	 1DnGZaQlFG2PEChrA1TowYVYRj0NHmzxNyacGeXYMuW44NpCLG+1EoQnUUMYRe3JhMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cGHqrFoHGG2Dijc7r/68m/aKsY0fekFrDUNU8LaseM4=;
	b=e+MH+vdxwcw66E0ZGn0YHKAPn26mW9hAZd5e2kjA+4mKUwobdO6klWl79PHxwwGcBPif
	 fOJVAJq3JVvDzNs+X/nmhRJaiMFW23hGTIHSo5rbrPN1yZ5GsawhrvEceP2Lt09TkQKGR
	 nuZkFtJ6rq6nDEgtxesJKhtjSk1e3UW3bacFjWDZUdO3o8yTQpnbQAog8DnNThM2fRNFV
	 Bdw6ZVePmzSCLMySB9G0lDMgUpZ8zAlhQCxHL+AwezJBj0zs/uDR2O59QfXsVgktIfrLe
	 ej8cHoM1K4WNH+tXIvXw1qL0SLMY6BdaoQGkRlELflt1q/VUfN78AJGmxqWd2tAr0mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCwF+1zL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65334606A9CA;
	Sat,  7 Nov 2026 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCwF+1zL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1280D1F0089F;
	Sat,  7 Nov 2026 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063665;
	bh=cGHqrFoHGG2Dijc7r/68m/aKsY0fekFrDUNU8LaseM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCwF+1zLt5ijUcs2GRjC5ysViMMI8Zr/OB9vO+2b+uoL80iPyZx8mQLU2DTytZcxu
	 WNDJ6EgAzemSfqkozHRalY3Ia3ydAdO7z0xoVFYCKCEY6IsBO+f/cMcetSVmeLsE3t
	 Pc62ImvnfiqOqtHlvEumu9wc88ucSD/9LltsHw28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 778/869] ceph: fix 32-bit overflow in readdir reply count check
Date: Sat,  7 Nov 2026 08:57:40 -0500
Message-ID: <20261107134919.070522365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 52913831ba56efceaafd80b501d68fa00f79bde6 ]

parse_reply_info_readdir() checks how many entries are in a readdir
reply by computing the end pointer of the decoded array. That pointer
addition can wrap on 32-bit kernels and let an oversized count pass the
check. For example, a count of 0x40000000 with 156-byte entries wraps
to a zero offset, so the decoder can write past the preallocated buffer.

Check the count against the number of entries that fit in the allocation
before publishing dir_nr. Reject oversized replies through the existing
error path.

Cc: stable@vger.kernel.org
Fixes: 54008399dc0c ("ceph: preallocate buffer for readdir reply")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 56d8df7f7ebdd..9e1b4bc3eab7c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -436,10 +436,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err_client(cl, "dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



