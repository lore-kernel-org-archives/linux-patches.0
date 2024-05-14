Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB43A757E8;
	Tue, 14 May 2024 11:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686401; cv=none; b=ryCgpZ6c+Eq++uGCAJ2SogwJ5Vo/G5UxMHC3Yu/b2mlYMnJvXJqDhs1hYeV2eGN/8JvGHyxZDoZ1rLhszAwLyn+ym/iGQyk17WbUbga/WFCcPRqN98l4WpqmTidIRpJzecW9neT6j5UKZejTxEPTL7nMZteQIzLofK90GJWSAiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686401; c=relaxed/simple;
	bh=ZLUUA7PeJwd3Nv9x0Ukxd0sJh2ikqDDRc+OxoV368j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVK0vLFfov+ycw4A0rmr05SHuO4UneTULM2BkrIeBauy3USN2VbLsr+dhxEZCUNHtxyGBVYLKsGNTrnmnfyHE1iQwwjjKC0v6CQHH2lEk4lOd1yB782UrAiCnMM5Ue+P/+1FejZB3N0dFnM83m5cYKQnIQRF07Xn+oG9S8tEkSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rw5GBaOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rw5GBaOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48397C2BD10;
	Tue, 14 May 2024 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686401;
	bh=ZLUUA7PeJwd3Nv9x0Ukxd0sJh2ikqDDRc+OxoV368j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rw5GBaOK07c8b/zNY+ak7Dh08nmB9xSl8PWsSDsl0UDi8JPUhn9TPK9yYPTv2N5fZ
	 Ji/1HN0e7CzRsZan8sFAmdGiwb32DOatklW6XnWOnOwK9WeH9+7oSmCrL0cLzGUiC0
	 Ybwbj+bjtAvfZXPBwTToLqzBB+FkEO7iVDWVnBwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <joneslee@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/236] selftests: timers: Fix valid-adjtimex signed left-shift undefined behavior
Date: Tue, 14 May 2024 12:18:08 +0200
Message-ID: <20240514101025.154946817@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 076361362122a6d8a4c45f172ced5576b2d4a50d ]

The struct adjtimex freq field takes a signed value who's units are in
shifted (<<16) parts-per-million.

Unfortunately for negative adjustments, the straightforward use of:

  freq = ppm << 16 trips undefined behavior warnings with clang:

valid-adjtimex.c:66:6: warning: shifting a negative signed value is undefined [-Wshift-negative-value]
        -499<<16,
        ~~~~^
valid-adjtimex.c:67:6: warning: shifting a negative signed value is undefined [-Wshift-negative-value]
        -450<<16,
        ~~~~^
..

Fix it by using a multiply by (1 << 16) instead of shifting negative values
in the valid-adjtimex test case. Align the values for better readability.

Reported-by: Lee Jones <joneslee@google.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240409202222.2830476-1-jstultz@google.com
Link: https://lore.kernel.org/lkml/0c6d4f0d-2064-4444-986b-1d1ed782135f@collabora.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/timers/valid-adjtimex.c | 73 +++++++++----------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/timers/valid-adjtimex.c b/tools/testing/selftests/timers/valid-adjtimex.c
index 48b9a803235a8..d13ebde203221 100644
--- a/tools/testing/selftests/timers/valid-adjtimex.c
+++ b/tools/testing/selftests/timers/valid-adjtimex.c
@@ -21,9 +21,6 @@
  *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *   GNU General Public License for more details.
  */
-
-
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
@@ -62,45 +59,47 @@ int clear_time_state(void)
 #define NUM_FREQ_OUTOFRANGE 4
 #define NUM_FREQ_INVALID 2
 
+#define SHIFTED_PPM (1 << 16)
+
 long valid_freq[NUM_FREQ_VALID] = {
-	-499<<16,
-	-450<<16,
-	-400<<16,
-	-350<<16,
-	-300<<16,
-	-250<<16,
-	-200<<16,
-	-150<<16,
-	-100<<16,
-	-75<<16,
-	-50<<16,
-	-25<<16,
-	-10<<16,
-	-5<<16,
-	-1<<16,
+	 -499 * SHIFTED_PPM,
+	 -450 * SHIFTED_PPM,
+	 -400 * SHIFTED_PPM,
+	 -350 * SHIFTED_PPM,
+	 -300 * SHIFTED_PPM,
+	 -250 * SHIFTED_PPM,
+	 -200 * SHIFTED_PPM,
+	 -150 * SHIFTED_PPM,
+	 -100 * SHIFTED_PPM,
+	  -75 * SHIFTED_PPM,
+	  -50 * SHIFTED_PPM,
+	  -25 * SHIFTED_PPM,
+	  -10 * SHIFTED_PPM,
+	   -5 * SHIFTED_PPM,
+	   -1 * SHIFTED_PPM,
 	-1000,
-	1<<16,
-	5<<16,
-	10<<16,
-	25<<16,
-	50<<16,
-	75<<16,
-	100<<16,
-	150<<16,
-	200<<16,
-	250<<16,
-	300<<16,
-	350<<16,
-	400<<16,
-	450<<16,
-	499<<16,
+	    1 * SHIFTED_PPM,
+	    5 * SHIFTED_PPM,
+	   10 * SHIFTED_PPM,
+	   25 * SHIFTED_PPM,
+	   50 * SHIFTED_PPM,
+	   75 * SHIFTED_PPM,
+	  100 * SHIFTED_PPM,
+	  150 * SHIFTED_PPM,
+	  200 * SHIFTED_PPM,
+	  250 * SHIFTED_PPM,
+	  300 * SHIFTED_PPM,
+	  350 * SHIFTED_PPM,
+	  400 * SHIFTED_PPM,
+	  450 * SHIFTED_PPM,
+	  499 * SHIFTED_PPM,
 };
 
 long outofrange_freq[NUM_FREQ_OUTOFRANGE] = {
-	-1000<<16,
-	-550<<16,
-	550<<16,
-	1000<<16,
+	-1000 * SHIFTED_PPM,
+	 -550 * SHIFTED_PPM,
+	  550 * SHIFTED_PPM,
+	 1000 * SHIFTED_PPM,
 };
 
 #define LONG_MAX (~0UL>>1)
-- 
2.43.0



