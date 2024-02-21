Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5D7BB10;
	Wed, 21 Feb 2024 13:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522006; cv=none; b=NLjyRxXT9OoW5qdggNDmYCIid6vGGss2jhIhhr6p28zsZSphrSUlYJKoY1i7sIO6RHK3mhGs0orTk5VP34edysccmmyQLCLUs0wOWkjZiI0OFGVxX2gbGRuC2R/YPR2cqlWg+XQbi+Ypd7zyFi6xfmYm6VjXmhDd1J9CyZyAYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522006; c=relaxed/simple;
	bh=s1Jpx+fajMVirv7tQgSMhwhhr0j05v5mOPcuh0yq0CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnbusjEWtJWTZ2vjMH8qB60X4BidxiGa6e1t5N3fglap6DRT0y6dYrY3Z9bPmk5Ssw37UH0ORouO7U3saQ2An68b1wi5PH4csdFlTqIrcR6yGYDC8EonRQ1Ebk0hj5b8nuQO/Roku/lnJRiPSHX/IpwBHO5gvsoKAEMlu+xdapk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCv0WtpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCv0WtpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73080C433C7;
	Wed, 21 Feb 2024 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522005;
	bh=s1Jpx+fajMVirv7tQgSMhwhhr0j05v5mOPcuh0yq0CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCv0WtpOTYlONMQtV6zGxYVXlkKO+kdqk/HPicYxmwR0QnSEBfbu5CSyZF5/Wy+QI
	 CkBJpdLk6JU54PRaUTRsAiSM+R4d1YRsv2DacAWWBqY13hGCtgQv3XuClnMyaHDcV4
	 iEUO8hrEEHRJ8Xl4Bmt/++qrZ7NEWfrTBIwrgBuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 025/476] parisc/firmware: Fix F-extend for PDC addresses
Date: Wed, 21 Feb 2024 14:01:16 +0100
Message-ID: <20240221130008.844925732@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 735ae74f73e55c191d48689bd11ff4a06ea0508f upstream.

When running with narrow firmware (64-bit kernel using a 32-bit
firmware), extend PDC addresses into the 0xfffffff0.00000000
region instead of the 0xf0f0f0f0.00000000 region.

This fixes the power button on the C3700 machine in qemu (64-bit CPU
with 32-bit firmware), and my assumption is that the previous code was
really never used (because most 64-bit machines have a 64-bit firmware),
or it just worked on very old machines because they may only decode
40-bit of virtual addresses.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -123,10 +123,10 @@ static unsigned long f_extend(unsigned l
 #ifdef CONFIG_64BIT
 	if(unlikely(parisc_narrow_firmware)) {
 		if((address & 0xff000000) == 0xf0000000)
-			return 0xf0f0f0f000000000UL | (u32)address;
+			return (0xfffffff0UL << 32) | (u32)address;
 
 		if((address & 0xf0000000) == 0xf0000000)
-			return 0xffffffff00000000UL | (u32)address;
+			return (0xffffffffUL << 32) | (u32)address;
 	}
 #endif
 	return address;


