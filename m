Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5673EE1DA;
	Wed, 20 May 2026 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297369; cv=none; b=GdAp9JGl1wK7CAVnIHXsN5crvqRNpzl6hxstat//nmH+oGslIH74xrBV48WJyHSPTs6VqCScwGpVM/9bOyE67ils2Ht+JeYV641vldUuiFQKqWxAScaqb4mLpVT3IKkH5VnaxuWd2tPcmagNTQXqIiVlOUjQJh8dCZB6sDArKPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297369; c=relaxed/simple;
	bh=XbhUh/3hp0pAzlq1pS7mcyxH8YzqEg4qVP+KN8i076Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2gulnRe3JtJWnr/Zcico7DwxroNIpY5vQKE7dI410jGbQyTmgArJ3u6e4UkQLRpVA8BesxCQaHPeZensgyXtsYHl2pboa8YeZ17chdmf/btHH1lG/SezRiSBnv9IcptlkN/EMitG7s8gX37Xf31Olfdfw5OxS1Fv3lsWmhfGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxwW+WzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxwW+WzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B371F000E9;
	Wed, 20 May 2026 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297367;
	bh=YgWrpFRj5BSZQOSjwfhvnCYs3+J04WrUcuhMMpByfWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxwW+WzC/bP7gtwFiLXcZ8e6q1wBDpchvza/fbMzgGd1kBFAO4iTRrioy/cB6MQ4+
	 +xrOdYxIMbaq7+fkdHN2A0Oao9hdKMZ0+UUQk6byLyE4GL/JAwXK5kZ29F5+isX6/c
	 CICqCYtMlYrLrTn88cUcnQWV6peI++Q1G4YMlD4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 1140/1146] arm_mpam: Fix false positive assert failure during mpam_disable()
Date: Wed, 20 May 2026 18:23:10 +0200
Message-ID: <20260520162214.053792775@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

commit f1caff3335ea6eab88cdc84ec8f2e3c45ca05486 upstream.

mpam_assert_partid_sizes_fixed() is used to document that the caller
doesn't expect the discovered PARTID size to change while it is walking
a list sized by PARTID. Typically the MSC state is not written to until
all the MSC have been discovered and this value is set.

However, if discovering the MSC fails and schedules mpam_disable(),
then the MSC state is written to reset it. In this case the
discovered PARTID size may be become smaller - but only PARTID 0
will be used once resctrl_exit() has been called.

Skip the WARN_ON_ONCE() if mpam_disable_reason has been set.

Fixes: 3bd04fe7d807 ("arm_mpam: Extend reset logic to allow devices to be reset any time")
Cc: <stable@vger.kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/resctrl/mpam_devices.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -148,11 +148,17 @@ static void mpam_free_garbage(void)
 /*
  * Once mpam is enabled, new requestors cannot further reduce the available
  * partid. Assert that the size is fixed, and new requestors will be turned
- * away.
+ * away. This is needed when walking over structures sized by PARTID.
+ *
+ * During mpam_disable() these structures are not fixed, but the MSC state
+ * is still reset using whatever sizes have been discovered so far. As only
+ * PARTID 0 will be used after mpam_disable(), any race would be benign.
+ * Skip the check if a mpam_disable_reason has been set.
  */
 static void mpam_assert_partid_sizes_fixed(void)
 {
-	WARN_ON_ONCE(!partid_max_published);
+	if (!mpam_disable_reason)
+		WARN_ON_ONCE(!partid_max_published);
 }
 
 static u32 __mpam_read_reg(struct mpam_msc *msc, u16 reg)


