Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3413BC0B;
	Wed,  3 Jul 2024 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004489; cv=none; b=NbQv2JGL6sN3DvLLJJL6nWnCp8VWYejJ3qzvcy/ATmZU314LtaxiFHJUVT9MMVM28G1QqKrU7/ZBzHGWREWTiXgZtRuPKhtov8S10XdBaKr36oHcLRIegLLjQcNjyw+mcfFkbvzECnZ1SLxJz8wLslg5n+E/z8JpmoWbeaMYfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004489; c=relaxed/simple;
	bh=5u3hfL92p46r6mB0Pb8ZVcIPQb/mqYPCaEmoysAZjFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI4fraU+F26usf8R8N7z04auHoHrUUcRiYaGjHJyBr8WtVwvRWaQWFDHrD3NThw8SOWN5jAPN71hLWiFxm1arP5KY/MZMDs8VGQAbfx9bygW7+6DIf3hBxtWwcFVqDum29bBMwxlOsRXjmJjQy+5mG1cqLcnbfrIJ165gPNli2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYIyZevW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYIyZevW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5FCC2BD10;
	Wed,  3 Jul 2024 11:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004489;
	bh=5u3hfL92p46r6mB0Pb8ZVcIPQb/mqYPCaEmoysAZjFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYIyZevW+3brxbXpmluZmSKw7ETGcARhKk2MFa1xiSTR9SHH0pyWX7X7IxD6+qfoW
	 c/5kgzvh26y1fkr5nfsEv0d3h/2iJIwmzLZujmvZiE70BzIii3G+0eWPtQFAESFINo
	 v2OQCdQMfupgD8dBZvqPXL/ea7rM3l3k8r9DXJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/290] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed,  3 Jul 2024 12:36:48 +0200
Message-ID: <20240703102905.219871511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit efaf24e30ec39ebbea9112227485805a48b0ceb1 ]

While dumping sockets via UNIX_DIAG, we do not hold unix_state_lock().

Let's use READ_ONCE() to read sk->sk_shutdown.

Fixes: e4e541a84863 ("sock-diag: Report shutdown for inet and unix sockets (v2)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 5bc5cb83cc6e4..7066a36234106 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -164,7 +164,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-- 
2.43.0



