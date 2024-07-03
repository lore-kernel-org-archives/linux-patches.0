Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B310188CDA;
	Wed,  3 Jul 2024 11:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005784; cv=none; b=NFOA0mbUtmSZvXtZBWrxd4c0vBf7Rf6fz9EfcZdocpOCGKdeVeSIbqfqdeJEf+brF6n+/go/ch38KE3h5ZrPyWl4jAOmQtOgmtLk8GlRjqP30asXE5++mt4he1T5nY/4RXHrKFMY30hRhk2DxDggjs7w90C1noblu6XtgQ5QcrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005784; c=relaxed/simple;
	bh=DA4GQ90blD2u5WGhwJvhhm9Gu24Ci9uNFizwu+ErVMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIzP4S65fb7ElGuKhxesjQr8tPjKf8GhorS8Uo+I+Z1K33VBQMKZHbOTyA2X+bHrfMS2cEwtO9X04Wff4TFZXZOa+JsEKRqdNc97qWkR5lE28zaXaxSH6Al3YS7++a/G2iUawgURJ5C3QbVLualnwKzYe1C937k4RZa4bz5kLUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsRtxaX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsRtxaX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE95C2BD10;
	Wed,  3 Jul 2024 11:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005783;
	bh=DA4GQ90blD2u5WGhwJvhhm9Gu24Ci9uNFizwu+ErVMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsRtxaX225PS5F7KN8hU5vNworGRMujBgujIlKjsIbwEJruO3s6NgqUBZdq+rbMU7
	 Q4zrF8uQ4VVsK3doM1ERZpjmkh4zvNv2lEpR8SBYvLMAPz40KI6L5T4ym5BHQFlYGI
	 7wngiikrPzzTenwaPMDMD7KaVZuYl9viXWV6W80U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/356] udf: udftime: prevent overflow in udf_disk_stamp_to_time()
Date: Wed,  3 Jul 2024 12:38:34 +0200
Message-ID: <20240703102919.839067227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 3b84adf460381169c085e4bc09e7b57e9e16db0a ]

An overflow can occur in a situation where src.centiseconds
takes the value of 255. This situation is unlikely, but there
is no validation check anywere in the code.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20240327132755.13945-1-r.smirnov@omp.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/udftime.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index fce4ad976c8c2..26169b1f482c3 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -60,13 +60,18 @@ udf_disk_stamp_to_time(struct timespec64 *dest, struct timestamp src)
 	dest->tv_sec = mktime64(year, src.month, src.day, src.hour, src.minute,
 			src.second);
 	dest->tv_sec -= offset * 60;
-	dest->tv_nsec = 1000 * (src.centiseconds * 10000 +
-			src.hundredsOfMicroseconds * 100 + src.microseconds);
+
 	/*
 	 * Sanitize nanosecond field since reportedly some filesystems are
 	 * recorded with bogus sub-second values.
 	 */
-	dest->tv_nsec %= NSEC_PER_SEC;
+	if (src.centiseconds < 100 && src.hundredsOfMicroseconds < 100 &&
+	    src.microseconds < 100) {
+		dest->tv_nsec = 1000 * (src.centiseconds * 10000 +
+			src.hundredsOfMicroseconds * 100 + src.microseconds);
+	} else {
+		dest->tv_nsec = 0;
+	}
 }
 
 void
-- 
2.43.0



