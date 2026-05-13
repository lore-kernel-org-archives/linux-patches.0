Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDFB349CFC
	for <patches@lists.linux.dev>; Wed, 13 May 2026 02:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640846; cv=none; b=UraRJ5AojdL/DF0PR7o8NLvg5nyGz2OePprLFH9h/f1bLzx83wvHNBfw7OJ6De21WQ5Hi6t5M1p+sfjFih3STvfFxkmLzhaAWHWqaasdZXa7rE9IdM+xWNLOFcjLi0rdfSVwt1tL3wmhVv+NxzX/JWwPde6pNZTNXIVMnFkuRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640846; c=relaxed/simple;
	bh=h81wKV3WHFoCuwtNrhGiVPTt55Ja70Wq+uFWGB7Lg4k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VQtCWTZZNn+it2ykmDe1lKg4mDgbcQA0wqQSQK+R5hON98WqejUX8+n5GUVREdZ5VUZD66CKcAuo6DNntjW6xugM9IDiONXw3lGwTnLbxHZiLkzl/yT3fYNQ92yjhKIOqh4woxMLKLUS5Als0LYUo+NBhJQZTTzg2ET6XRPcSjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=BFn8QPB1; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="BFn8QPB1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=BFn8QPB1NlEX3gA4eJ5OAU6A9CCZggwhk4LlxmqkwDgvKEZbU04UjQNK/0kU968oylIVXvtAZoeys
	 o51hj65Jc2avY5RzHve0rybXCSErSxnmZdkq/wUdIVnNMeV1f8EYIDSVjLmzeA20KeshxnkKcKu+vC
	 A2YqUqi7TsRrZ1oI=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-07-12085 (RichMail) with SMTP id 2f356a03e7c24b0-04504;
	Wed, 13 May 2026 10:53:58 +0800 (CST)
X-RM-TRANSID:2f356a03e7c24b0-04504
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	pengpeng@iscas.ac.cn
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	yoshfuji@linux-ipv6.org,
	dsahern@kernel.org,
	kuba@kernel.org,
	justin.iurman@uliege.be,
	netdev@vger.kernel.org,
	justin.iurman@gmail.com
Subject: [PATCH 5.15.y] net/ipv6: ioam6: prevent schema length wraparound in trace fill
Date: Wed, 13 May 2026 10:53:57 +0800
Message-Id: <20260513025357.3161377-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e67ba9bb531e1ec6599a82a065dea9040b9ce50 ]

ioam6_fill_trace_data() stores the schema contribution to the trace
length in a u8. With bit 22 enabled and the largest schema payload,
sclen becomes 1 + 1020 / 4, wraps from 256 to 0, and bypasses the
remaining-space check. __ioam6_fill_trace_data() then positions the
write cursor without reserving the schema area but still copies the
4-byte schema header and the full schema payload, overrunning the trace
buffer.

Keep sclen in an unsigned int so the remaining-space check and the write
cursor calculation both see the full schema length.

Fixes: 8c6f6fa67726 ("ipv6: ioam: IOAM Generic Netlink API")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/ipv6/ioam6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index bb7ad0d1cacf..765b87c18a4c 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -645,7 +645,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen)
+				    unsigned int sclen)
 {
 	struct __kernel_sock_timeval ts;
 	u64 raw64;
@@ -863,7 +863,7 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_trace_hdr *trace)
 {
 	struct ioam6_schema *sc;
-	u8 sclen = 0;
+	unsigned int sclen = 0;
 
 	/* Skip if Overflow flag is set
 	 */
-- 
2.34.1


