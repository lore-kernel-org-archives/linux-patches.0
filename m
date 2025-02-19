Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28621EEA2A;
	Wed, 19 Feb 2025 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955421; cv=none; b=hKC9d/CYloitxyRXGQTOHJLQE4Fqz/6HiMBPqi8w7BSVu7lExiiXErPNWkU4hoTVTPRVkr3k5MCk8yh/kKlgTyrE6I3NGBud3aciUvuDZUM45nh01pPG+ra3vH/ZN1jAd92F5SIwBdBPe3NmbRzhuHorgLfZUD1Su+xPrbd95qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955421; c=relaxed/simple;
	bh=qgsTKqmVCT7ZqcAHTR/c/A9f8HkP5hI16QcugY34Fx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wdugtf2DiJly+77ZxN0wXOT1m14gdKLzrrmQwEyyXXChuhHcD45IHyFoKmRHTlEb6g8UF8VwCjH0flyeDtgOMk0qmfKgyqz1kdsyA6SuK3QGtGLMtyY2amDOUpxGGqr7MG6lyfG6U5+p7yF3P/FUoT43uChE9/VXHz5GazBZRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRyRe7RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRyRe7RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24140C4CED1;
	Wed, 19 Feb 2025 08:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955421;
	bh=qgsTKqmVCT7ZqcAHTR/c/A9f8HkP5hI16QcugY34Fx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRyRe7RT92qgu8S6H3SdpUcOUi+ilNCkQjckstXDGnFJOkmqhCpL/iU5V5maes2vl
	 J0CXCgbpr10XLNNIL86EbjyqCJBLOIIq6C6HXrCG64Lmr0not3UQVqv2x5ergCrlFO
	 3m8jmgAS7F4WnVr3aw+o4wsqsWH5Hkbq559FEgfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20N=C3=BCrnberger?= <stefan.nuernberger@cyberus-technology.de>
Subject: [PATCH 6.12 230/230] Revert "vfio/platform: check the bounds of read/write syscalls"
Date: Wed, 19 Feb 2025 09:29:07 +0100
Message-ID: <20250219082610.679699587@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 61ba518195d61c38c6cb86f83135e51f93735442.

It had been committed multiple times to the tree, and isn't needed
again.

Link: https://lore.kernel.org/r/a082db2605514513a0a8568382d5bd2b6f1877a0.camel@cyberus-technology.de
Reported-by: Stefan Nürnberger <stefan.nuernberger@cyberus-technology.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -393,11 +393,6 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
-	if (off >= reg->size)
-		return -EINVAL;
-
-	count = min_t(size_t, count, reg->size - off);
-
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -479,11 +474,6 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
-
-	count = min_t(size_t, count, reg->size - off);
-
-	if (off >= reg->size)
-		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


