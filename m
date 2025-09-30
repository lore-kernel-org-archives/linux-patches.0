Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C03C465;
	Tue, 30 Sep 2025 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246171; cv=none; b=rzK1rl3f5/WFzLw9VF19MpVKQN2bac0mqSyUGjNEgMggp7CTl5wjDoNfsb9aVRr9JCBHgym/yEHC3teNeVck3/5G0FzqBeRhHmc+XQ6D9V4M73H9mkToA26zex/2vq1tWjEMXXHiOfVYq1n4Z79t2sNATB6RldT7yH/seIYNE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246171; c=relaxed/simple;
	bh=WW0u3Jr8B7u5ZYKdcXYLvfkBUe0M5rAfevTGIE38Hus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW+Gd7718Umgaixvx8TNrwcVVYHw2QtY4TNI8ncOTk6bHpmb5Au97cwIRm5hyWEY0FiWXntMzPKlwCsfUNH7lD7P0mN/eVDTLfQkoegZfCYosLd0Z3UJLaSYjo0ek1Bb27l3G2fmV/GbS9hdWWn/PAdgjGVXSKKB2K70o7phdDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbor1fzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbor1fzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97295C4CEF0;
	Tue, 30 Sep 2025 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246171;
	bh=WW0u3Jr8B7u5ZYKdcXYLvfkBUe0M5rAfevTGIE38Hus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbor1fzddqHkLC1JjGfeJUFGC/HkVQpCFhZWb7oEqhJE/4RLS/DUhDL3BBV6YHlCR
	 3+V7TQmKW63IXQzDGL1YuW/MLWP+2Cj/P2D9iDnHtvFjLzNn2nx3FeoqKG/2blhRF+
	 jmgbWYtAnBwPvKfm1J3bqEJyAMoBIDoPEKRwAWlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 75/89] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:48:29 +0200
Message-ID: <20250930143825.008793631@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit d0ca0df179c4b21e2a6c4a4fb637aa8fa14575cb upstream.

Commit 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in
af_alg_sendmsg") changed some fields from bool to 1-bit bitfields of
type u32.

However, some assignments to these fields, specifically 'more' and
'merge', assign values greater than 1.  These relied on C's implicit
conversion to bool, such that zero becomes false and nonzero becomes
true.

With a 1-bit bitfields of type u32 instead, mod 2 of the value is taken
instead, resulting in 0 being assigned in some cases when 1 was intended.

Fix this by restoring the bool type.

Fixes: 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/if_alg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -152,7 +152,7 @@ struct af_alg_ctx {
 	size_t used;
 	atomic_t rcvused;
 
-	u32		more:1,
+	bool		more:1,
 			merge:1,
 			enc:1,
 			write:1,


