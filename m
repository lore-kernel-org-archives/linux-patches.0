Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA1223DD6;
	Tue, 30 Sep 2025 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245551; cv=none; b=lysB/SWjLfkUGhwyIcgenfo6FJl/SVDKjTO6QF6ESAUbX1vypBwOV83oY4TxjOq1kgMDg1kdQR+I+nbBuZ7aXX3qorQ7trWsU0LNHPrsCoZxChfeM3c00OZZgixSHuXhd9bzk8vQyTzreZMilTGJD2KywKHvfQqEgdmHOTtXaCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245551; c=relaxed/simple;
	bh=G9g5dmvzXXQhIuN1dK/Gj+LKmz9hm8ExDHIjvC0bWDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU7nBLNLe+DSfK1BEp7uFqjkPYdFq2IXTPPqg8EweksJCmimk648q0Cxbz3Sxw22oveLuJQ7vxZaWXZ1Ekv9ZpWe6qTRCD2cMRhV3nI1BMyhWfJBp3aFMjqxjRsJNlIXNf9Jx9kSRLCx1uqwNRN+APK3ls3Z4oal03O5Fymu8II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOQp6fFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOQp6fFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECE4C113D0;
	Tue, 30 Sep 2025 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245551;
	bh=G9g5dmvzXXQhIuN1dK/Gj+LKmz9hm8ExDHIjvC0bWDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOQp6fFleF2a5tjZK6NsG20l6k7hHXp6tUrU8AV5+m4j+qpVKDpaxUMgWLyWZ1LIn
	 X58H5yKoRGVuz1Dm/LnWvCpnkZxY4f8XXWRYCv14c8naud3O3rdXedEHda3t73mOkS
	 34d3W5CsqeIS85ReVegWEuiicrqoh+P72K6xeSGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 51/73] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:47:55 +0200
Message-ID: <20250930143822.755761968@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


