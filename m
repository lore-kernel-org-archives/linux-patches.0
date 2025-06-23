Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0422721B8F6;
	Mon, 23 Jun 2025 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716432; cv=none; b=jh7PqCJ/DTSVHg5b/lKLkIFlhW+UwwRLt50HkCvLqwrtnnuImB9DpUlI20F0n+fV8fs3/08iOcLZNov1zPeO79ULJmUA91x8yDj0MFIxGOSNIeXBzuQ/O8GPfgAI3YCcsY4/mUXs0tmWFyk2QNdKqxC1jedM7rMTYv9Choirz0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716432; c=relaxed/simple;
	bh=OjvRTt5T147mI1LbwGC4Wxe8S1ZL93BsOpYsHuRK4lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3iJO3iNNFSWidiAZfENzyjUswCF+8SB6d/XUXzcGyAk2UY///Q4OlS6lMSTeVCVoBdV5Rb6oaW7ixniirGCbtBGAobg7qROnthz0Z9x6Rny54ltTfM7tLrr2AZdYbRvTGIzRu/UETvlXqI4KTqsfpLu3DCKVTG1Y3dskmzKJsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LByLwjrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LByLwjrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883A0C4CEEA;
	Mon, 23 Jun 2025 22:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716431;
	bh=OjvRTt5T147mI1LbwGC4Wxe8S1ZL93BsOpYsHuRK4lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LByLwjrtKEoO+TJPxJKdYeSf2SimO/8y2uL80+c2GN7srzwOFzE+D9LfgB0KyhlwV
	 bCpdsi8KISCPQ4DKFr89X71q/JkNo7nFjg/yu6FyxmuPTJfCwTCnej33pfOqVZ7kxP
	 VCr/ew6A5SU3FnoRyl7bCZaeDYj2I/v6MfCOVAIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Justin Stitt <justinstitt@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 348/355] rtc: test: Fix invalid format specifier.
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130637.187910642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

commit 8a904a3caa88118744062e872ae90f37748a8fd8 upstream.

'days' is a s64 (from div_s64), and so should use a %lld specifier.

This was found by extending KUnit's assertion macros to use gcc's
__printf attribute.

Fixes: 1d1bb12a8b18 ("rtc: Improve performance of rtc_time64_to_tm(). Add tests.")
Signed-off-by: David Gow <davidgow@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/lib_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/lib_test.c
+++ b/drivers/rtc/lib_test.c
@@ -54,7 +54,7 @@ static void rtc_time64_to_tm_test_date_r
 
 		days = div_s64(secs, 86400);
 
-		#define FAIL_MSG "%d/%02d/%02d (%2d) : %ld", \
+		#define FAIL_MSG "%d/%02d/%02d (%2d) : %lld", \
 			year, month, mday, yday, days
 
 		KUNIT_ASSERT_EQ_MSG(test, year - 1900, result.tm_year, FAIL_MSG);


