Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4F3D6CB7;
	Wed, 20 May 2026 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297205; cv=none; b=V6kpoZ3qQJ7pZueAWbqH2GEsrwgGu1KbpKzDsHq+V24SoJXLGzm4a/3XxJk9PJK2DeuT64Xa4AmlfySYEB67svTkThrsnwCV7khOZgVQFf2c7p1kOJ1uHeTc7dxlgRPr9nVz32LO0xTujxEutqt/Y+gClGnacdVbecA2afBdvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297205; c=relaxed/simple;
	bh=5K5f5fZs5U1jmZWcNMVHk03QFngu4vmsVwNXcvoEov8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTkfx7sXZ1TPMWpULJPkcN/mI/wcaMtRlbQp1vzY3tk4vvwjPqy9U7hu1kAurnaYJHoeuvaxiELy5Alx02icKMc+vK3fgd9NDJf6hN27TajH0aEfC0h46p5uAyC51ZBSJ9Ff9/13+1kJzH7+4zkTiZ8iKIB6+6FvKHiK3mQIn2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hrwtdsxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hrwtdsxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007F61F000E9;
	Wed, 20 May 2026 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297204;
	bh=FihiYs5QTLqKw1S0A9ddAmvG4RNYtMhaK7MwGnsBlG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hrwtdsxgosi0nVJP8+IUJpDKYaYLnodZDwqF57dzXc7eOkxIzJHm5uTdsizUzEZ54
	 duKrjjGvBlNaXd9mOg+c13miqHbuZyMB1o7A/ADtbD08XfiGLxDXVHoQ0Clp5feZ4e
	 8CQreXGoCp5btyLS/gNALgHQ+XkfpT4kE9RYJQ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 1048/1146] net: ena: PHC: Check return code before setting timestamp output
Date: Wed, 20 May 2026 18:21:38 +0200
Message-ID: <20260520162211.948305464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Kiyanovski <akiyano@amazon.com>

commit 24a08d7d6218d60c033015cf4870b6096446e734 upstream.

ena_phc_gettimex64() is setting the output parameter regardless
of whether ena_com_phc_get_timestamp() succeeded or failed.

When ena_com_phc_get_timestamp() returns an error, the timestamp
parameter may contain uninitialized stack memory (e.g., when PHC is
disabled or in blocked state) or invalid hardware values. Passing
these to userspace via the PTP ioctl is both a security issue
(information leak) and a correctness bug.

Fix by checking the return code after releasing the lock and only
setting the output timestamp on success.

Fixes: e0ea34158ee8 ("net: ena: Add PHC support in the ENA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260507003518.22554-1-akiyano@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_phc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/amazon/ena/ena_phc.c
+++ b/drivers/net/ethernet/amazon/ena/ena_phc.c
@@ -46,9 +46,12 @@ static int ena_phc_gettimex64(struct ptp
 
 	spin_unlock_irqrestore(&phc_info->lock, flags);
 
+	if (rc)
+		return rc;
+
 	*ts = ns_to_timespec64(timestamp_nsec);
 
-	return rc;
+	return 0;
 }
 
 static int ena_phc_settime64(struct ptp_clock_info *clock_info,


