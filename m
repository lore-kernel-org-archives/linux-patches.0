Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E2223DD6;
	Tue, 30 Sep 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245829; cv=none; b=PtRNvn1wSC6gpUvcgUkBBgCmouf8GVLnFWa2Lr7IoeZJjVtkr1TbQYJQLYgNBKYrVCS31W5axD2zRJM3vBMNeLRIaBjyP392T5Qu42Q/609eZpCYm9Wrwp/17FqxkhOwjTrs5YkpuJHeuMZ+DfDhMtXpHQXnOgezbfdPynZTIpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245829; c=relaxed/simple;
	bh=4M7xiUUkSUlHAAWlM+GB3myqfTvPjy+eAz7ZgW2LwjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdd4ob1zFa/35LTDlz7evLb8CAd1F9Pvt2B5BowlymCsAFYJPryVG2wrH5o4Rbjzj0ELjBlw3rvQAxKHKGAOsOHFNFvY7d9QDznY8RXgeDDbL9JuRDf+hjxBjb6VAu+/+WV8LuLqrR7d8xOBpGeZmu9nRmHjYHaifNqLGz20vqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ioyf23NW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ioyf23NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8B8C4CEF0;
	Tue, 30 Sep 2025 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245829;
	bh=4M7xiUUkSUlHAAWlM+GB3myqfTvPjy+eAz7ZgW2LwjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ioyf23NWSHfkoLlagrvwHK9RS2bf0cUFLdriRy0TnIvinBwGWGJ+NxiHpNU2DUJrm
	 zybJWDeR4eWgzKaB5oack99EWiyghkjyHiC1r2+N13dhNG71HtXaQTH/RHBzlxe9un
	 3uEYdj8+TPAcO2VmJUTFOnW7+JjFZMEaT50TPpSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 63/91] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:48:02 +0200
Message-ID: <20250930143823.806665619@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,7 +150,7 @@ struct af_alg_ctx {
 	size_t used;
 	atomic_t rcvused;
 
-	u32		more:1,
+	bool		more:1,
 			merge:1,
 			enc:1,
 			write:1,


