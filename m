Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6FB35209C;
	Tue, 26 Aug 2025 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219212; cv=none; b=TvUumz85j8WuOyfV+fOMlHFKop3gFczkZIdTxPMbVecS9oiXnxD5Ve23YENWncN3ZcEZEwbTaIkw/aCU5Oj1PQynC05j9T1gWejV7O92TEX8UzGScQzXH/RhZdOaGsGJgqpl5skjBmvA6vscdMJUJb2mtXvrklzL0lQ+eCRxHxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219212; c=relaxed/simple;
	bh=8guIjQLgTDbZ9zamICsTy6+musu1n1tBDhQ9FOMGEO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzB/cWuzMHho8Oazzz8IGHSoggQo221p8tOgN38mzsFzgiF81KMx2OW/huprf1DkM7JjJ1cE2xwgKU9VjAwqM4Ez640QelnQxC1FnQvo6td4ePnwcYRzmdwPxF1g2KR6X9lO7r8IvvP99yHJQiqOaRJGg+rrzGrhCYkMg2AE0Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZoA7egE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZoA7egE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBCEC2BC87;
	Tue, 26 Aug 2025 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219212;
	bh=8guIjQLgTDbZ9zamICsTy6+musu1n1tBDhQ9FOMGEO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZoA7egE57y1zJHDgItCaVxh6ph7rvq2EoB72yHtiM7nM1Gu9a010odBulBRnEvcz
	 YjhsKC2UslizowXsR9KdGq3BuxoKxVuEtawNELZYnzYOKBpevfM0ciFQMHhBz93SlN
	 I9yVbZ4FnqRsIQanVNMI5cSVwu+Kf2j/XkmU5KFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5.4 296/403] wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()
Date: Tue, 26 Aug 2025 13:10:22 +0200
Message-ID: <20250826110914.984557794@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 81284e86bf8849f8e98e8ead3ff5811926b2107f upstream.

A new warning in clang [1] complains that diq_start in
wlc_lcnphy_tx_iqlo_cal() is passed uninitialized as a const pointer to
wlc_lcnphy_common_read_table():

  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2728:13: error: variable 'diq_start' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
   2728 |                                                      &diq_start, 1, 16, 69);
        |                                                       ^~~~~~~~~

The table pointer passed to wlc_lcnphy_common_read_table() should not be
considered constant, as wlc_phy_read_table() is ultimately going to
update it. Remove the const qualifier from the tbl_ptr to clear up the
warning.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2108
Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>>
Link: https://patch.msgid.link/20250715-brcmsmac-fix-uninit-const-pointer-v1-1-16e6a51a8ef4@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -974,7 +974,7 @@ void wlc_lcnphy_read_table(struct brcms_
 
 static void
 wlc_lcnphy_common_read_table(struct brcms_phy *pi, u32 tbl_id,
-			     const u16 *tbl_ptr, u32 tbl_len,
+			     u16 *tbl_ptr, u32 tbl_len,
 			     u32 tbl_width, u32 tbl_offset)
 {
 	struct phytbl_info tab;


