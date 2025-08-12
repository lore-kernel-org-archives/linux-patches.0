Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A82FD1AD;
	Tue, 12 Aug 2025 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024180; cv=none; b=R3pCSbEjygHBsUPH3wee1uuHU20bS3tl8nSwJ438ULcJjEtspzeut80agkdGJqpozdF8Qrsy27XULYBQ4+nGTmdguaQBaSeQMT4VDvlioUksMQ7BEMHsIy+YVh43kWbHdrFmkzu87YKLqXZ7qGY6jA8Fbg9D+K6z/ZRnYYbNI1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024180; c=relaxed/simple;
	bh=S/rLreaP384qY3WU+BqlZXViGGuXSkvRczh9HQ470q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJkqAHDbf4e6sxAtD9OE7cVL6ou2lkJSXCgOj2yZ7Pj7dKU3ume2fJcB5T4O/WrRUoG30Q+ghD+1PzHJtySdQlidTfgtMfFZg8FSbIqOdX8w9Sth/WkL0XMCKg5CFksWaK/JOJOh1fw3U07f+i2GJmNJE0FIekif9DgSdx97MZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z90z0PmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z90z0PmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F73C4CEF0;
	Tue, 12 Aug 2025 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024180;
	bh=S/rLreaP384qY3WU+BqlZXViGGuXSkvRczh9HQ470q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z90z0PmV8+NcnWB74c5yYxTF9/y/tkf8qNRi3yoG0H4tBZOgUor5wIS5ZIwbKmgqN
	 eYnRf+hswaJBmxRn/eGjgSNQZtCmcXR4+0gOoftncRr3AC9H4Z/BbwR3Qj8FGrfKx8
	 sXvsk74SH9hCbqw8jn4KjF1lIOhqWRTbOH6hcbnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 297/627] fortify: Fix incorrect reporting of read buffer size
Date: Tue, 12 Aug 2025 19:29:52 +0200
Message-ID: <20250812173430.606535025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 94fd44648dae2a5b6149a41faa0b07928c3e1963 ]

When FORTIFY_SOURCE reports about a run-time buffer overread, the wrong
buffer size was being shown in the error message. (The bounds checking
was correct.)

Fixes: 3d965b33e40d ("fortify: Improve buffer overflow reporting")
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20250729231817.work.023-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index e4ce1cae03bf..b3b53f8c1b28 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -596,7 +596,7 @@ __FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 	if (p_size != SIZE_MAX && p_size < size)
 		fortify_panic(func, FORTIFY_WRITE, p_size, size, true);
 	else if (q_size != SIZE_MAX && q_size < size)
-		fortify_panic(func, FORTIFY_READ, p_size, size, true);
+		fortify_panic(func, FORTIFY_READ, q_size, size, true);
 
 	/*
 	 * Warn when writing beyond destination field size.
-- 
2.39.5



