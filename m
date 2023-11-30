Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C4B54F9B;
	Thu, 30 Nov 2023 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asniIJGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E26C433C7;
	Thu, 30 Nov 2023 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361845;
	bh=12G0y3HtGD6f3e14q5xep6L+6noxgedl+GjQwfnmNJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asniIJGwilqPKp4jDkqUMTMGLb0oE0uOS9O5nLw+RvTPUJYM+K9sHclmHQb5mnacI
	 pog5WFLawosMJ9JfZoANQW4SWqM8YxnwmXVUV6Hy0Fgtduejcpo/AIHf/qy+IRZl3v
	 12Q07yqtMhu3lKqr/GKyrwgq6rC+hlZ63l/uPWmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 69/82] bcache: prevent potential division by zero error
Date: Thu, 30 Nov 2023 16:22:40 +0000
Message-ID: <20231130162138.163473667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

commit 2c7f497ac274a14330208b18f6f734000868ebf9 upstream.

In SHOW(), the variable 'n' is of type 'size_t.' While there is a
conditional check to verify that 'n' is not equal to zero before
executing the 'do_div' macro, concerns arise regarding potential
division by zero error in 64-bit environments.

The concern arises when 'n' is 64 bits in size, greater than zero, and
the lower 32 bits of it are zeros. In such cases, the conditional check
passes because 'n' is non-zero, but the 'do_div' macro casts 'n' to
'uint32_t,' effectively truncating it to its lower 32 bits.
Consequently, the 'n' value becomes zero.

To fix this potential division by zero error and ensure precise
division handling, this commit replaces the 'do_div' macro with
div64_u64(). div64_u64() is designed to work with 64-bit operands,
guaranteeing that division is performed correctly.

This change enhances the robustness of the code, ensuring that division
operations yield accurate results in all scenarios, eliminating the
possibility of division by zero, and improving compatibility across
different 64-bit environments.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-5-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1103,7 +1103,7 @@ SHOW(__bch_cache)
 			sum += INITIAL_PRIO - cached[i];
 
 		if (n)
-			do_div(sum, n);
+			sum = div64_u64(sum, n);
 
 		for (i = 0; i < ARRAY_SIZE(q); i++)
 			q[i] = INITIAL_PRIO - cached[n * (i + 1) /


