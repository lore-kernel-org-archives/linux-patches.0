Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044412;
	b=VgNH2NbrEG64XFtMOUjcRW+PX5Cq3KyKxyUqct2XtTeMQaxO0sdh1janS55F6Zlh56d0
	 wGdbaHaS9e2763cS/jpg4huuXm5YRWDGVSZ7GOrGCmaTOBrJhEA9vrPoD9r3PMzadi9fU
	 5pPAWfAj1DSlbgIOHPf8HEtVvOvA+5dUxYKpuvtKmZFyXjsjbJHCQ9hMOy2cWMANbsG6b
	 +xPAzeW7n4OQ5u99zY/nOKMNEAe0gj2ZN6Or98671mwYXzxOyVDq46DXB/zPPYu/KuWwV
	 JXakpXAWMysFp6nU9tIn4jCcnz2CEtyT7RFWLKe9+AamYFe+ooqievuV9SE0josNpTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Q3RyYvXEu8eWzP9ltZtO9YhijTjTn0CBgRv6IDTWZ8=;
	b=0N8ZiYNiqP0GxquojpffIeZdScjNrdAUiMehz2a9YjvjsPom9l69RT7ut8dXQACk/I5j
	 K376uJYpCiP3wsWcD8JwoeSJp/AWM7XXzSqgGVWYJl3yED5fJ8KZT74D7hPDNT90AmcMU
	 nnKeJNjlTPLp0FVSwhoh08ukyQPMAoxsV9zNqRJdZKbfK6o7u/ORMuCqfplFCDfHJeXbI
	 BhFkl7eKveXE8XjxviyZY4BHEKxgXe7Z6GU4fRzVrczZNOps6tfQHmuxYJ1pmFf+gfaMd
	 FSS2Mv2Kbdmgdlr11jNL03SWB197HvsAGh2oJV85XDfRzjoFoXgttLRif9rFW5PhIhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGu2T1+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1FD606A320;
	Wed, 18 Nov 2026 23:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGu2T1+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947191F000C4;
	Wed, 18 Nov 2026 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044412;
	bh=1Q3RyYvXEu8eWzP9ltZtO9YhijTjTn0CBgRv6IDTWZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGu2T1+wjdeE/bafdkGmUhdjM1Aaqjor8qz1QKRHF8d2YQAC8qrtROdvnbt2zSngm
	 Kxd8fz+BTpMbD5KOKA8abM7Y5MMkNW3U51k6enJRtiqE0PrLP9l00QDJHMTlQY8jXI
	 8PoBT3ADN2ggrhIszi0hG6TO8DgjOoznkjq+kPuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Berman <elliotjb@elliotjb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0521/2857] bs/ntfs3: fix NULL folio dereference in ntfs_lock_new_page()
Date: Wed, 18 Nov 2026 15:25:55 +0100
Message-ID: <20261118150220.228700423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elliot Berman <elliotjb@elliotjb.com>

In 6.1, __filemap_get_folio() returns NULL on failure.  The backport of
commit 95b917a14b15 ("ntfs: Do not overwrite uptodate pages") keeps the
original IS_ERR() check, which is always false here, so a failed folio
allocation while reading a compressed file dereferences NULL in
folio_test_uptodate(). Check for NULL and return ERR_PTR(-ENOMEM).

Fixes: 95b917a14b15 ("ntfs: Do not overwrite uptodate pages")
Signed-off-by: Elliot Berman <elliotjb@elliotjb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index a44b7338621e0..fa443144f6d1a 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2172,8 +2172,8 @@ static struct page *ntfs_lock_new_page(struct address_space *mapping,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	struct page *page;
 
-	if (IS_ERR(folio))
-		return ERR_CAST(folio);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
 
 	if (!folio_test_uptodate(folio))
 		return folio_file_page(folio, index);
-- 
2.53.0



