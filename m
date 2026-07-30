Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F543D502;
	Thu, 30 Jul 2026 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423340; cv=none; b=cywTxJnGpjJsW361bKU7lTjjUgpTq1Z/BMbX40rOZIHw7U8AvcbdzEGFsKaDc1A8LX3JJ2TN0l2AyBBI3nOi9p1QdlyIzyyb7gow6CwKpCIcGHAzDCL8/XUVy5p0fppdX7R47VN4fX4H2TSamlzakI7WfcCSxv5NrkQQ3C09lRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423340; c=relaxed/simple;
	bh=mURAvGUISYkIGo6Ex0i8R7XsgXHo0I/EwIYpt3iaxU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMoAts2x0KKimQNI2l2MkDJOxuMeaZTeMoxKHaAtgLGYY9NhzhPUXSp4Aopdk4YUoFq7SaEwbp2eotKmQE0u1SYDdTIapRfIY+GGvgKW6/VTeNY3sCRsjt2cgKT4J/5G4Vknmj6VZXtqr0DpIdLbmfZQapQtbb5s+h2yTRRiWTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3JL11lR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3JL11lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551F71F000E9;
	Thu, 30 Jul 2026 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423338;
	bh=6jimzeSiWPCcTA8wXCpfwpk8jmiYLG8/3L2IfdNKosM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3JL11lR5VYZjpF+SqrBRXB5XFwaJdJhCR7UUh+I2758zT8LLZQuGuxa8wsLujEtF
	 CtZNH3g0SGfX12p3/GyIXvjCWjOfDsvccxGvz83TbysB4bxtVEqLcMs4ur4M0DDzVU
	 rvX7rIJ2kQVSX787PRFhEwFRiuoyy78O3y8u2bvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: [PATCH 7.1 743/744] selftests: drv-net: so_txtime: relax variance bounds
Date: Thu, 30 Jul 2026 16:16:56 +0200
Message-ID: <20260730141500.107122909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit e38fec239d923de5bfb65f7fce15ca52c5a3aa7f upstream.

The net-next-hw spinners on netdev.bots.linux.dev observe failing
so-txtime-py tests. A review of stdout shows most failures to be
due to exceeding the 4ms grace period. All I saw were within 8ms.
So increase to that.

Double the bounds from 4 to 8ms. This is still is small enough to
differentiate the delays programmed by the test, 10 and 20ms.

Fixes: 5c6baef3885c ("selftests: drv-net: convert so_txtime to drv-net")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260610170651.1b644001@kernel.org/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260621200137.1564776-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/so_txtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/net/so_txtime.c
+++ b/tools/testing/selftests/drivers/net/so_txtime.c
@@ -37,7 +37,7 @@
 
 static int	cfg_clockid	= CLOCK_TAI;
 static uint16_t	cfg_port	= 8000;
-static int	cfg_variance_us	= 4000;
+static int	cfg_variance_us	= 8000;
 static bool	cfg_machine_slow;
 static uint64_t	cfg_start_time_ns;
 static int	cfg_mark;


