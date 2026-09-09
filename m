Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D3C353A82;
	Wed,  9 Sep 2026 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961763; cv=none; b=LoJR6fb0xCNJUy84oYpTOC1vdqpHQ23Ocf4Hy4Iy587PQg13fSeY15mgwCDTd/RIctCZ845sM/3sKfhCQg1wCn8fe7EjF4u5MPSMOO7fs6XJKotmKUQhEQgasU1yHtJblISDQcJ78Ox0d185K4npZTNpzxexbB86TNrkI630TGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961763; c=relaxed/simple;
	bh=W02acB3Ut+HNhkp1fklgksCD3A1tbcDdaJ4SYdE5Y5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTWvURnXQz6kQ4nMVjA3MTVuJbw+7cwymQNEK10GbDyCMzqRmp360GnYeb6vnzjAc6eNIwdjZ4ub/0mF7wVgLLNZ9EoH5w1p4hQd+r/yNrcck/4Z4v/e9oJnCxWXtxZshFyhWhgWEXAxMKValyjbnqYbKvBpTWwN/LBe8nxGIsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGza2mBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGza2mBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA8E1F00A3A;
	Wed,  9 Sep 2026 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961762;
	bh=yrnN/UNQesVorgONvQDU2sj7AAOtWl2dowj1xTNg4w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGza2mBcv0OFgFhUmoZoPvh2EI7y9wc2qS8AqhQdSHeksox8bJ/Q5UBkiKRZH5u5M
	 g+rOhFfhnN6osj8c0UMNgfnrtBAz0+FDA1RxXiWcLrw5o+Asyle4lBwgKB6cM0cp8S
	 g9P71cF0UV6oe/QWSpln6TtranG7V7OwC8KZFM4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Lim <foxieflakey@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 059/556] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
Date: Wed,  9 Sep 2026 15:35:39 +0200
Message-ID: <20260909134232.544945350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Lim <foxieflakey@gmail.com>

commit f025ca73decda1f895a4b80b961d3bc88825298a upstream.

During move_pages() operation, when move_pages_ptes() returns EAGAIN, the
error code is not cleared even after we processed it.  This leads to a
successful retry but then the same pages are retried again due to the
stale error code.  This time move fails because pages are already moved,
loop is terminated and move_pages() reports a failure.  Clear the error
code once we processes EAGAIN.

Link: https://lore.kernel.org/e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com
Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Assisted-by: ChatGPT:GPT-5.6-Luna
Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfau
 		}
 
 		if (err) {
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
+				err = 0;
 				continue;
+			}
 			break;
 		}
 


