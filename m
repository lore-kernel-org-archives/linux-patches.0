Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9B419FD2;
	Fri,  4 Sep 2026 06:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502832; cv=none; b=PbgASYruCoqc+oTbj1ypUFRhzzPF6Boj6FgXoeCMZ0kTLi7Hpf5d1LCqQD3S46Ypi6jVRzwrNI7wcRSEzQiN5++gpkxgzjJvfYcinTRaOvY6cBpKC8FHFvO5xLFV9glCJ0hRVUwkvGFO+9huJ5V9/JEfWrj7U02KJmafp6ZgVrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502832; c=relaxed/simple;
	bh=P6fFYYrGPkuCPFREbkKZti1P8ndGavbUq5lYxyl9kKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5+zYaeicmnz6qR4tNApK6JvZ9zfPXH4Qs9lh/kqmwrsWi1bfaXeJAgZ2KIfAYDgPk41zMWXsHoDvtN8/7m8a2jeegv1nOFOil1b4do5HiQ78ai7PL/Y4wMSKkJPDYr+/5MPBehgDfSoloyI75lb03poQPwrNav4vcT4OZmVvfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHQZVC92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHQZVC92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E721F00A3E;
	Fri,  4 Sep 2026 06:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502830;
	bh=/VQwOdtoayso9p0Ltb8FgwDRlj09omu4su2fylRBMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHQZVC92UjWQWTenIs5Twug1k9jMry0EVFFxvY6jzbdszuB0TlShB5AKG/94uHAq9
	 HDvBQZsTp+cP8qbu4346kV1b5lhtKRd5q5zGyAaKYdDIdrDUNIaMqiiNZ0FEDfNPFJ
	 VSeCegC4PV61o0qVZn8RHzkl6uFlyOVFNRVFpLxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 345/403] net: thunderbolt: Release the Rx HopID that was handed out on mismatch
Date: Fri,  4 Sep 2026 07:02:28 +0200
Message-ID: <20260904045742.662064950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Ye <fy15309206903@gmail.com>

commit 2f1463554d0561a2fead81e3888604e5c1125e29 upstream.

tb_xdomain_alloc_in_hopid() passes the wanted HopID to ida_alloc_range()
as the lower bound, so a taken id is not an error there: the allocator
returns the next free one above it. tbnet_connected_work() asks for the
peer's transmit path, treats any other id as a failure and returns
without releasing what it got, so that allocation stays live for the rest
of the XDomain connection with nothing left holding a reference to it.

Release the id when it is not the one we asked for, the same way the
error unwind at the end of the function releases the expected one.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-1-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -650,6 +650,8 @@ static void tbnet_connected_work(struct
 	ret = tb_xdomain_alloc_in_hopid(net->xd, net->remote_transmit_path);
 	if (ret != net->remote_transmit_path) {
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
+		if (ret >= 0)
+			tb_xdomain_release_in_hopid(net->xd, ret);
 		return;
 	}
 


