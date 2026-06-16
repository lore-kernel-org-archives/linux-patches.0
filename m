Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B89B3DC4D9;
	Tue, 16 Jun 2026 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635142; cv=none; b=V4zapP0G2/fjw6q8lIdsi8U8sNWbDaC3Q1o9P1hybuo5bPLp3yoXg20d0oHBDpf/rnzvCcQCgW4pb9EGVAVAzd06xs7jJVBv4HEqe2xHyFN+ml2pj/6WbMMQHOtEGTplZedjreQRIAPKmnEq1ucmBhFjb9V2s2bTU0UxP5Nu9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635142; c=relaxed/simple;
	bh=AQ9Xdij0cJ5Ui5B9nwJ2o2z1sanK93xfz51B0FqSA54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIqjmO8dWZGVGVYfHhhPNil77YzHxl56aM2K+5s+W3EiKEjzGU5nu71D35md+OUvrDTiot04CzFel2WCOhDC3jcE2gA42LTsuKY7jTLDV6Av2CE7rodTZv7MkHSi5Gp56fM6FJAabdrpkIOZxYw1euBdRGSEvBS6YrT7VCM57iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9OmfknY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9OmfknY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA51F000E9;
	Tue, 16 Jun 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635141;
	bh=vzQdmuS19j5P1t3wEcyea2OlFLE21X9Cbo63jXrnZQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9OmfknYJ4gQ/YQqqnsTCA9GVPi2h5T82fIIzM091otnQ1ULnxJdUb1waYkYudqN2
	 5b5lOz27Kezg7qHRIfY7Kz7AQ/xu5z/1v2OZFxBhPlA0vODyZPpqc0QBPJkkODealm
	 gpaEGaMQlIafRXk9X8hFpY/X+7vldgC3VuRX5DhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 5.15 397/411] net/ipv6: ioam6: prevent schema length wraparound in trace fill
Date: Tue, 16 Jun 2026 20:30:35 +0530
Message-ID: <20260616145122.298220289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ioam6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -645,7 +645,7 @@ static void __ioam6_fill_trace_data(stru
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen)
+				    unsigned int sclen)
 {
 	struct __kernel_sock_timeval ts;
 	u64 raw64;
@@ -863,7 +863,7 @@ void ioam6_fill_trace_data(struct sk_buf
 			   struct ioam6_trace_hdr *trace)
 {
 	struct ioam6_schema *sc;
-	u8 sclen = 0;
+	unsigned int sclen = 0;
 
 	/* Skip if Overflow flag is set
 	 */


