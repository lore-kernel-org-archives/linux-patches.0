Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DA939FD4;
	Fri, 24 Nov 2023 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XItPbPZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E32C433C8;
	Fri, 24 Nov 2023 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848798;
	bh=CtkJ3DtwuiuW7M+bUaHTBxUD8GCrC9lXYRIN+LAylW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XItPbPZfHXs67DmhDpmrE9dNkMeiTLSOnmXWJeTMNrqFnHbUxoIS5K+Ck1XHhqa37
	 BO+qE4C1lhIhW+XYyoYBesM2BDR9Bsew+pB8i/fn61TCjNFnyEAC5lQz+agEYZ/CoJ
	 Jb+5xWD2DIkVq2JS3ASkFz53iq7Vos5vzvIgNvT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Ferner <joe.m.ferner@gmail.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4.19 85/97] media: sharp: fix sharp encoding
Date: Fri, 24 Nov 2023 17:50:58 +0000
Message-ID: <20231124171937.356518894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 4f7efc71891462ab7606da7039f480d7c1584a13 upstream.

The Sharp protocol[1] encoding has incorrect timings for bit space.

[1] https://www.sbprojects.net/knowledge/ir/sharp.php

Fixes: d35afc5fe097 ("[media] rc: ir-sharp-decoder: Add encode capability")
Cc: stable@vger.kernel.org
Reported-by: Joe Ferner <joe.m.ferner@gmail.com>
Closes: https://sourceforge.net/p/lirc/mailman/message/38604507/
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/ir-sharp-decoder.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -23,7 +23,9 @@
 #define SHARP_UNIT		40000  /* ns */
 #define SHARP_BIT_PULSE		(8    * SHARP_UNIT) /* 320us */
 #define SHARP_BIT_0_PERIOD	(25   * SHARP_UNIT) /* 1ms (680us space) */
-#define SHARP_BIT_1_PERIOD	(50   * SHARP_UNIT) /* 2ms (1680ms space) */
+#define SHARP_BIT_1_PERIOD	(50   * SHARP_UNIT) /* 2ms (1680us space) */
+#define SHARP_BIT_0_SPACE	(17   * SHARP_UNIT) /* 680us space */
+#define SHARP_BIT_1_SPACE	(42   * SHARP_UNIT) /* 1680us space */
 #define SHARP_ECHO_SPACE	(1000 * SHARP_UNIT) /* 40 ms */
 #define SHARP_TRAILER_SPACE	(125  * SHARP_UNIT) /* 5 ms (even longer) */
 
@@ -176,8 +178,8 @@ static const struct ir_raw_timings_pd ir
 	.header_pulse  = 0,
 	.header_space  = 0,
 	.bit_pulse     = SHARP_BIT_PULSE,
-	.bit_space[0]  = SHARP_BIT_0_PERIOD,
-	.bit_space[1]  = SHARP_BIT_1_PERIOD,
+	.bit_space[0]  = SHARP_BIT_0_SPACE,
+	.bit_space[1]  = SHARP_BIT_1_SPACE,
 	.trailer_pulse = SHARP_BIT_PULSE,
 	.trailer_space = SHARP_ECHO_SPACE,
 	.msb_first     = 1,


