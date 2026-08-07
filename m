Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4567343D63;
	Fri,  7 Aug 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116655; cv=none; b=H/TbiDadMVTKYMwhdFUb4SdNLCw2Yyp8HX3zCTJzuBwJ3cLiSX9gxqRM07DHY3VgisK906f/BCCsqXq25jYCXdT+LpnPD93YQa4CZhBkzZtQieeSeysk38KDHEqzRusdIuDae7k7bkr5gSTTdwRI2W25TqfHMU0TZnnH+MF5FxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116655; c=relaxed/simple;
	bh=h1An2G9mGJsDJz8la7SOnJLmz90TVNyzqrNFvXNyqiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jwbyt84c15rqw7A33xMLigRmSlS/6rRFq6fzc4I3kofiBHo8G9P8IhXc37s0tmIbK24gpe0OckFGt9YJ7sykN8mN22ItYUyq83J7oK4VeX5FfSGXvYGhUxyzH+VTEM9YJnLOPcVPz3b6TWAbb/XKwtSSPWVy8M6/Hp/usIyMySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNhtSLGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNhtSLGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF481F000E9;
	Fri,  7 Aug 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116654;
	bh=7DgoMCpCpUGac0vJGnSxNMrfqDulYU5KjiWlms9cQgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNhtSLGZ75g/kR1FzN4K19oUkehKdVlYBKYlXJAj5KNXLJ73z1SYn/079ulaXc91A
	 foJhcAYHg/3O2hhWgF73sPmX6yYWjsojNJ+8/TFMr6sM/mmcuGIb1D+WzIuk/l7Im/
	 inBf9Q8+whsXGKmQsFHNrpTC5yynxd0sRuBqpnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 044/438] mshv: Fix sleeping under spinlock in mshv_portid_alloc
Date: Fri,  7 Aug 2026 16:34:00 +0200
Message-ID: <20260807143428.938322493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit a9708e550d11a53b22d932cdbfaa10c26346a2d0 ]

idr_alloc() is called with GFP_KERNEL inside idr_lock(), which holds a
spinlock. GFP_KERNEL allows the allocator to sleep, triggering a
sleeping-while-atomic bug.

Fix by using idr_preload(GFP_KERNEL) before taking the lock to
pre-allocate memory in a sleepable context, then idr_alloc() with
GFP_NOWAIT inside the spinlock-protected section.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_portid_table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_portid_table.c b/drivers/hv/mshv_portid_table.c
index c349af1f0aaac..6f59b3e376247 100644
--- a/drivers/hv/mshv_portid_table.c
+++ b/drivers/hv/mshv_portid_table.c
@@ -40,12 +40,14 @@ mshv_port_table_fini(void)
 int
 mshv_portid_alloc(struct port_table_info *info)
 {
-	int ret = 0;
+	int ret;
 
+	idr_preload(GFP_KERNEL);
 	idr_lock(&port_table_idr);
 	ret = idr_alloc(&port_table_idr, info, PORTID_MIN,
-			PORTID_MAX, GFP_KERNEL);
+			PORTID_MAX, GFP_NOWAIT);
 	idr_unlock(&port_table_idr);
+	idr_preload_end();
 
 	return ret;
 }
-- 
2.53.0



