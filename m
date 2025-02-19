Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221E81DE3AE;
	Wed, 19 Feb 2025 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955920; cv=none; b=QpusVjKWzGxRKU33w9AJPk8rLc+16XvG1ZIKzWnJnRyH/T2c5TKDykY9jJW/v0mPGVZPuNG4whvWofVUGmJ1dHWiqHpt7YnS9gI/+yTqks7jtQ+8ty+l64/nEf0vJIsQmwUJIJwwzveh2JPGbxaUQK2UzJcqL5e1LUgXnGFBVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955920; c=relaxed/simple;
	bh=WJ9QrhpDG3PBkQJEgOATq+H58dvJkm4W2aGRYHy/C+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa5DZApWu+OrjT/+GXk2LPo2Rc8Vy8nYRAWqvNpryzcdFdzaGQseqeE/PgBi+f31/T75UUX5caohilpV0uFfVLb/zipiSJUU2LIdOhy+y3oirxDGu2AoS35SMtMeoXZ6Sm3LAIG5i4UQKicKw/+l8yaOT959gHQ3Ii3pYEzLQDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hH+41Vw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hH+41Vw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAC3C4CED1;
	Wed, 19 Feb 2025 09:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955919;
	bh=WJ9QrhpDG3PBkQJEgOATq+H58dvJkm4W2aGRYHy/C+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hH+41Vw9U/i9vemZI9jOrQYW4AxSfQvIxWt1BE/Re5v0Mzoe3I4eP142rzrFY4N+M
	 fz7sweV7HfrKMedE7srWYQQUZB5/Isw+hDHyhLCAfrm2I+UXNVE+dFcEyZvWzlhpii
	 5+rby0Jq3f1U1yqZKVqshicZzAvAwZPIkXQLhGIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.6 136/152] netdevsim: print human readable IP address
Date: Wed, 19 Feb 2025 09:29:09 +0100
Message-ID: <20250219082555.423615193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


