Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50D8472769;
	Fri,  7 Aug 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114773; cv=none; b=tkdjBxuYjaLytG7O2jGvDJEirERbKE1y4ZE8A4fk+EaYopgA98Nko2H5ka0dMbgcdG9cGDmNgYBCEaRqQsVJ0ZwCD49aX4m9sGyF19BUfrVQmBRngXJ+HfqXIXCOBaEEgh+X7p+HgfWgl8150STd4H8H/0znftx36eX+L0y1CT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114773; c=relaxed/simple;
	bh=J6YR6qAs5WlAynkc9Ya5QLHVxIHQDcPrjl6GiXtbl1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5ZMtn5DfXIPrQizMhmOkUmzSR04kR5WCPAM3uSKv68yS3Aryesnzi21mh6cMf0UVzMPcDGiMDXYPH60kbrwQJEYXNnmWrVaLyClHTe4Rj58owVPFje9Hdt2uqPQgc+UrqCSRMxSgHH/Bmj6yOglWKuCdLepJVhUB6WsJu8gl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVxbh9We; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVxbh9We"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099211F000E9;
	Fri,  7 Aug 2026 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114772;
	bh=OzI0zfoD0ybVNTwXD0NQrYzpvSy0wGgg2jSCH30086c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVxbh9WeVqZ+rsyC6EQfJksFbAr71hcoAhb5w2AbWvl3ppaDlGiGMi+eq4s4bCL+G
	 gqR/UmpkgqtwuOTPEZkV0TuWpst0Ic3TzPgAQvBBql69Wb6csdL9t6XhWyUxxghUQy
	 j9klH48zUs06+zsz4lthxYWij75LsZZl62pn89yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/396] mshv: Fix sleeping under spinlock in mshv_portid_alloc
Date: Fri,  7 Aug 2026 16:33:21 +0200
Message-ID: <20260807143425.155246095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



