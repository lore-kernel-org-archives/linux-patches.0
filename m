Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6686D846F;
	Tue, 30 Sep 2025 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244776; cv=none; b=HnHiUlIk7RaETU8tySM0G1Blb9GP9eyuT3/p5HW29GQ0wilw2mTY+qjqYqlBI8TqIs2agEm+GjzMXjUO6VZWLO4lNQKmPd8XtxmRaI0HRv/fQwRPTUAz7IKDRC9Du+Ct+7GoSgsV6IgzEigntKfgHaCThKYgDVamRh+ZtiMcWdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244776; c=relaxed/simple;
	bh=rNJuxAAWzTxFdOYJdKjvZaRw8A8P313GxFixKmGk/+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhDtB+BpXBRZahe1UtZcx6ni9ApoToWGRYmdJ/4KNW1eFs/rhDefPP8xlqDVQEml+30nB2KSUWcXgzkkgnULFsd0pToRGdFEB/FiC64Z7G6ZtBrxIoNO7t0S9pFI5Gr+DTCbBfPYDjUHX+zkwIBf/gW5TjQ+dnZXlnHSy+H4a50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcIWJ7+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcIWJ7+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0562C4CEF0;
	Tue, 30 Sep 2025 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244776;
	bh=rNJuxAAWzTxFdOYJdKjvZaRw8A8P313GxFixKmGk/+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcIWJ7+dCCDxgdca7Hu+j21JiCmGtl0JLSVz+kzkm/D8S6FiramX8kV2Vsny5SpnA
	 CYHcRQAqBJvIizLCQW7oHAn4i/kvMn40eNTPUiKl9WevzOY1cIsLg+rYfPlsqbVL9W
	 MhWYPEDdaAUKP4DnS6llf2aZ9f/M6JXRBWlodR8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.16 110/143] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143835.618534398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


