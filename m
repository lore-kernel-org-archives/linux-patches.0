Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A0330EF88;
	Tue, 16 Jun 2026 07:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781593219; cv=none; b=Oxrl6DsBkWnynbW8e8gPyix0Z8+njdp+YoTxJe/ku+IwwZhbT5sx0gGf2JCFEatZNC5IDkeW6TmqiUXgnFyZpJ5XvKrRz7Sbe6EV2fGbdZtJzQwORVC78Wq+DAlYN378jcaS0e1MoaVEhRCQRhENohcNujDkbMSIddnasUj8dVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781593219; c=relaxed/simple;
	bh=g7+XuO7O78SYFXYukWKPiwsl6CH+0kp1oD5KIzU2xqU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=uCO0BQM3DGBgZyx9YbHFH0oOEasuBtMRyaWuGeoZk7kND0DVwuk+NabUtaJ5y0Rfb3mgr9MSZq0VugfxXsqGdq0L7fNufGkI9INlXuRAuh9wScdZCw06yQDEjy8lsE7daUr8LPt/qgsUI10ASLHSGg/iKfJOgZw6zR0ld4Wu1YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYxEv3q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYxEv3q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E151F00A3A;
	Tue, 16 Jun 2026 07:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781593207;
	bh=SqhIQgfpI9hd/JDiHNEdM+03Xjr8jM7Amb+bd1TxeTI=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=hYxEv3q8JKdqIJGemtul4Udk9GtkoPYXd5TbaiJ+vnx3pVFt97uIky0czqDI+CIb7
	 yd50MQ+1joN0zWaOgOhGMrNWFPmv2nefIF6YpPSAwdm3nyqf4tOU9T/SldO+evSzw5
	 TWSi3HU9Rn1T9ElYxGRi40t8jvoTKMOMneiLnY9s=
Subject: Patch "net/ipv6: ioam6: prevent schema length wraparound in trace fill" has been added to the 5.15-stable tree
To: 1468888505@139.com,davem@davemloft.net,dsahern@kernel.org,gregkh@linuxfoundation.org,justin.iurman@gmail.com,justin.iurman@uliege.be,kuba@kernel.org,patches@lists.linux.dev,pengpeng@iscas.ac.cn,yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 16 Jun 2026 12:28:40 +0530
In-Reply-To: <20260513025357.3161377-1-1468888505@139.com>
Message-ID: <2026061640-unpaired-splicing-5773@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    net/ipv6: ioam6: prevent schema length wraparound in trace fill

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-ipv6-ioam6-prevent-schema-length-wraparound-in-trace-fill.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-246719-greg=kroah.com@vger.kernel.org Wed May 13 08:26:54 2026
From: Li hongliang <1468888505@139.com>
Date: Wed, 13 May 2026 10:53:57 +0800
Subject: net/ipv6: ioam6: prevent schema length wraparound in trace fill
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, pengpeng@iscas.ac.cn
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org, justin.iurman@uliege.be, netdev@vger.kernel.org, justin.iurman@gmail.com
Message-ID: <20260513025357.3161377-1-1468888505@139.com>

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


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-5.15/net-mctp-ensure-our-nlmsg-responses-are-initialised.patch
queue-5.15/net-tcp-md5-fix-mac-comparison-to-be-constant-time.patch
queue-5.15/net-ipv6-ioam6-prevent-schema-length-wraparound-in-trace-fill.patch
