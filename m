Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20ED25D904;
	Tue, 11 Mar 2025 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707182; cv=none; b=PhtaVEmfn/k+rADK4qQ72Zunhnaa4XicNjsx/FbCtoDoMWmpH1usyWleEgbqb7icw1L24ToQect69ZXITvrnSW8ZXj5MGa3fNdw6RDqiZ0ilmmjmlu/R8uIG66jQOqolaP0GrcTDzSZi7x+Kh/JIA9UN0JKUkBWBXbaV8gcaRCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707182; c=relaxed/simple;
	bh=rSnUy9T5XqusC1Fc8wFNbpo5Ih1MnGYgPF7jxLsGX3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1kXtxA7SGn6uTG0yUSkkpYeuIZyfKb5xroTD2w5y0GgHh54UuQZV1tZZYrp2RQEKx2j1tTzHgnZ8TuQFW2Q6M+kxQaWiX3vGkemqfYg8IwDNUxAnd2aRfgJjbveXSGbsmJ5qfaxUvscG8/Dl6/fR2koep/QWkO7Faio+CL0M3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjySuDw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjySuDw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D834C4CEE9;
	Tue, 11 Mar 2025 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707181;
	bh=rSnUy9T5XqusC1Fc8wFNbpo5Ih1MnGYgPF7jxLsGX3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjySuDw5tcRt16bgR6ZWDA6iyGfdJ6+wdeKLwknz3UfRgFfjXE0EuyWe6+z5cP29b
	 qBvP7eCS1qvRry37eof9B12iMG7w8s8sGMvViMhnEPakeHEacgcfCgvpn9SKKw4qqM
	 poAmr3noGzB5CTY/MvxwIoyPkDby/YCPeP5b5NTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 301/462] netdevsim: print human readable IP address
Date: Tue, 11 Mar 2025 15:59:27 +0100
Message-ID: <20250311145810.253425948@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

commit c71bc6da6198a6d88df86094f1052bb581951d65 upstream.

Currently, IPSec addresses are printed in hexadecimal format, which is
not user-friendly. e.g.

  # cat /sys/kernel/debug/netdevsim/netdevsim0/ports/0/ipsec
  SA count=2 tx=20
  sa[0] rx ipaddr=0x00000000 00000000 00000000 0100a8c0
  sa[0]    spi=0x00000101 proto=0x32 salt=0x0adecc3a crypt=1
  sa[0]    key=0x3167608a ca4f1397 43565909 941fa627
  sa[1] tx ipaddr=0x00000000 00000000 00000000 00000000
  sa[1]    spi=0x00000100 proto=0x32 salt=0x0adecc3a crypt=1
  sa[1]    key=0x3167608a ca4f1397 43565909 941fa627

This patch updates the code to print the IPSec address in a human-readable
format for easier debug. e.g.

 # cat /sys/kernel/debug/netdevsim/netdevsim0/ports/0/ipsec
 SA count=4 tx=40
 sa[0] tx ipaddr=0.0.0.0
 sa[0]    spi=0x00000100 proto=0x32 salt=0x0adecc3a crypt=1
 sa[0]    key=0x3167608a ca4f1397 43565909 941fa627
 sa[1] rx ipaddr=192.168.0.1
 sa[1]    spi=0x00000101 proto=0x32 salt=0x0adecc3a crypt=1
 sa[1]    key=0x3167608a ca4f1397 43565909 941fa627
 sa[2] tx ipaddr=::
 sa[2]    spi=0x00000100 proto=0x32 salt=0x0adecc3a crypt=1
 sa[2]    key=0x3167608a ca4f1397 43565909 941fa627
 sa[3] rx ipaddr=2000::1
 sa[3]    spi=0x00000101 proto=0x32 salt=0x0adecc3a crypt=1
 sa[3]    key=0x3167608a ca4f1397 43565909 941fa627

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241010040027.21440-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/ipsec.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -39,10 +39,14 @@ static ssize_t nsim_dbg_netdev_ops_read(
 		if (!sap->used)
 			continue;
 
-		p += scnprintf(p, bufsize - (p - buf),
-			       "sa[%i] %cx ipaddr=0x%08x %08x %08x %08x\n",
-			       i, (sap->rx ? 'r' : 't'), sap->ipaddr[0],
-			       sap->ipaddr[1], sap->ipaddr[2], sap->ipaddr[3]);
+		if (sap->xs->props.family == AF_INET6)
+			p += scnprintf(p, bufsize - (p - buf),
+				       "sa[%i] %cx ipaddr=%pI6c\n",
+				       i, (sap->rx ? 'r' : 't'), &sap->ipaddr);
+		else
+			p += scnprintf(p, bufsize - (p - buf),
+				       "sa[%i] %cx ipaddr=%pI4\n",
+				       i, (sap->rx ? 'r' : 't'), &sap->ipaddr[3]);
 		p += scnprintf(p, bufsize - (p - buf),
 			       "sa[%i]    spi=0x%08x proto=0x%x salt=0x%08x crypt=%d\n",
 			       i, be32_to_cpu(sap->xs->id.spi),


