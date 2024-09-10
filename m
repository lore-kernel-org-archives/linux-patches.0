Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9CC18F2D8;
	Tue, 10 Sep 2024 09:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961744; cv=none; b=oO2WqnPNjgbv5iAzLW3w1eyuD3TOFtshq9X2yEMQiDQYKdfuNh6pM3VdLgW36/qb7iBUkmpSY3tE6WZOtg7Cegvz1UQ5a2CIl1KnQ/ar9DhnAQ7hZzsxTcuTZwk6O+o1pjqCxkpRX9lKf5mD1Cfds9AFXzD7wXKiPqJpKYeJ0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961744; c=relaxed/simple;
	bh=9U7shh1/B2ixKa9lDrxEDSrLzAdOKkTj7JtlnJA73gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8E7URLehpTjgKXyvv0azR2X6q7G51P3kpZEmsyt7syeOcRSQNEFa8Pp3KiQi/n4MV7qMwcfB36uHtHNLzB7t0AgnHBQRiSvmsA1PZ80SgIvH9ML1+XqpXIlQtXDqLVaqbvlXM871yKpVAAvhr9A5tFqkilBTk8/W4eRi08W+J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZzaFh3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZzaFh3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EECC4CEC3;
	Tue, 10 Sep 2024 09:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961743;
	bh=9U7shh1/B2ixKa9lDrxEDSrLzAdOKkTj7JtlnJA73gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZzaFh3k5l6V8zqjX1w8iwyDs/k3Kdy/zUvxz/GL+pnn05UUfaWKmnSGna6d06XTd
	 mqH5dUHolcDIPZvUXwo2iGg+AsLaB8Pa+lcAFWd2+YGarTmEOGU78VkHepO5isCTW9
	 tp9CoCODwfwNlo9W79FEoy40XrqgRfSEAa7T4E8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	=?UTF-8?q?Petr=20Tesa=C5=99=C3=ADk?= <petr@tesarici.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 174/375] scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum
Date: Tue, 10 Sep 2024 11:29:31 +0200
Message-ID: <20240910092628.325272110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit a3f6a89c834a4cba0f881da21307b26de3796133 ]

Richard reports that since 772dd0342727c ("mm: enumerate all gfp flags"),
gfp-translate is broken, as the bit numbers are implicit, leaving the
shell script unable to extract them.  Even more, some bits are now at a
variable location, making it double extra hard to parse using a simple
shell script.

Use a brute-force approach to the problem by generating a small C stub
that will use the enum to dump the interesting bits.

As an added bonus, we are now able to identify invalid bits for a given
configuration.  As an added drawback, we cannot parse include files that
predate this change anymore.  Tough luck.

Link: https://lkml.kernel.org/r/20240823163850.3791201-1-maz@kernel.org
Fixes: 772dd0342727 ("mm: enumerate all gfp flags")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Richard Weinberger <richard@nod.at>
Cc: Petr Tesařík <petr@tesarici.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gfp-translate | 66 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 17 deletions(-)

diff --git a/scripts/gfp-translate b/scripts/gfp-translate
index 6c9aed17cf56..8385ae0d5af9 100755
--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -62,25 +62,57 @@ if [ "$GFPMASK" = "none" ]; then
 fi
 
 # Extract GFP flags from the kernel source
-TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
-grep -q ___GFP $SOURCE/include/linux/gfp_types.h
-if [ $? -eq 0 ]; then
-	grep "^#define ___GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
-else
-	grep "^#define __GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
-fi
+TMPFILE=`mktemp -t gfptranslate-XXXXXX.c` || exit 1
 
-# Parse the flags
-IFS="
-"
 echo Source: $SOURCE
 echo Parsing: $GFPMASK
-for LINE in `cat $TMPFILE`; do
-	MASK=`echo $LINE | awk '{print $3}'`
-	if [ $(($GFPMASK&$MASK)) -ne 0 ]; then
-		echo $LINE
-	fi
-done
 
-rm -f $TMPFILE
+(
+    cat <<EOF
+#include <stdint.h>
+#include <stdio.h>
+
+// Try to fool compiler.h into not including extra stuff
+#define __ASSEMBLY__	1
+
+#include <generated/autoconf.h>
+#include <linux/gfp_types.h>
+
+static const char *masks[] = {
+EOF
+
+    sed -nEe 's/^[[:space:]]+(___GFP_.*)_BIT,.*$/\1/p' $SOURCE/include/linux/gfp_types.h |
+	while read b; do
+	    cat <<EOF
+#if defined($b) && ($b > 0)
+	[${b}_BIT]	= "$b",
+#endif
+EOF
+	done
+
+    cat <<EOF
+};
+
+int main(int argc, char *argv[])
+{
+	unsigned long long mask = $GFPMASK;
+
+	for (int i = 0; i < sizeof(mask) * 8; i++) {
+		unsigned long long bit = 1ULL << i;
+		if (mask & bit)
+			printf("\t%-25s0x%llx\n",
+			       (i < ___GFP_LAST_BIT && masks[i]) ?
+					masks[i] : "*** INVALID ***",
+			       bit);
+	}
+
+	return 0;
+}
+EOF
+) > $TMPFILE
+
+${CC:-gcc} -Wall -o ${TMPFILE}.bin -I $SOURCE/include $TMPFILE && ${TMPFILE}.bin
+
+rm -f $TMPFILE ${TMPFILE}.bin
+
 exit 0
-- 
2.43.0



