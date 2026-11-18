Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028457;
	b=NdpfQAxye3lgkqF+LmKMgkFiouEt2RtJ2BJRomWuTxGAcaFzDIbyjos66XE37Tg97hNT
	 bYFwx/Wu+cL/5wFun20dlxX1OZmHO0CtNir6rg7Lt39ONqeISYjV2CkHi5cO31vOup8FF
	 Drl9xrOVVPXgtvCF+ws5hxkwZW8VRcylXNLiNx1CFW4JlR4RN5ygelSn4zN7z8mzktqKL
	 6hEw9k/eWaWsSZsN66hSC+XW19MPDadMh54X/kNmrA3dR3d58twh1MAZ8WkqYZW3pTzkD
	 EX0TNRYjfflR+kU/M3FF98tXgvlFLUH2cbP9sxfHo8aGQzwDx4VakxcsVEOVCPWXGAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KDK2hB1U5Qj96oUS2GBvQBFxcP/JOavA17gLAgXbgw=;
	b=H7DSqI2gjlIKnKM3h7aDlzjJN70l1SLDCu42sxZw2H1S03X4sSmZ9Ip78dmtGxrfqTbp
	 +4wSaB8Nut+z1zt6k4G/2FWofJWC9ClHfxsaM6+zVGdwxzEKZEKWNSBGwD9Ebpp6yrQpH
	 INjLOGVlq9HGNJ+4bSx67pHj8fkpT9Y9YcGTmkdXT8CI52DgaGlWecO7RcoNelkyi446S
	 IlneGFINzdzOmEANqvOS6CY2qzLELOCgTj936YJxtiahOQuq53OSJTVCzdzsd70KzGCjc
	 9Qw6/izfolFi/FVivt+BrXSfwVpjCz0Z8tyrou2UIUZK3rwVwDpmHO9PicYuMGueR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pB5L3Ve5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B75606A330;
	Wed, 18 Nov 2026 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pB5L3Ve5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F6D1F000C4;
	Wed, 18 Nov 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028456;
	bh=4KDK2hB1U5Qj96oUS2GBvQBFxcP/JOavA17gLAgXbgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pB5L3Ve5Va9Z03CmZLbpDvnv7ooYDzEzPgsi7uFrD2196aPBzND7MwHRySEjETkp/
	 iCS/3545z9W8haJSo7holhP2VtkqWCvDQHtaSFm4BwGZkrVrI/VjAVe+pTrneZuFd+
	 FBlkJEN2k3gmn9g9G0NyQGeOJ/Ja64R9SM/09L/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 2151/2151] scsi: core: Balance the pseudo target reap reference
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150240.028659255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Piscitelli <ooonea@gmail.com>

commit 8a832fb632da303cdf0704e0d56722ec47799f19 upstream.

With memory allocation profiling enabled, unloading scsi_debug reports
allocations left at module unload. A stock Linux 7.2.11 VM without OpenZFS
emitted the following on each of three load/unload cycles:

[    1.644665] drivers/scsi/scsi_debug.c:8863 module scsi_debug func:sdebug_add_host_helper has 1024 allocated at module unload
[    1.656260] drivers/scsi/scsi_debug.c:1261 module scsi_debug func:sdebug_target_alloc has 16 allocated at module unload

scsi_alloc_target() supplies a reap reference for its caller. The SCSI
device initializer takes another reference, which device removal drops.
scsi_get_pseudo_sdev() drops its caller reference only when device
allocation fails. On success the target cannot be destroyed, retaining its
driver-private data and its parent host and adapter.

Drop the caller reference in the common cleanup path, as the other
scsi_alloc_target() callers do.

Fixes: d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI device")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261027100859.1031135-1-ooonea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_scan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2141,14 +2141,13 @@ struct scsi_device *scsi_get_pseudo_sdev
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
-	if (!sdev) {
-		scsi_target_reap(starget);
+	if (!sdev)
 		goto put_target;
-	}
 
 	sdev->borken = 0;
 
 put_target:
+	scsi_target_reap(starget);
 	/* See also the get_device(dev) call in scsi_alloc_target(). */
 	put_device(&starget->dev);
 


