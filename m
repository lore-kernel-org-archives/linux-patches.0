Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7258468;
	Thu, 25 Jul 2024 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918803; cv=none; b=DCr3G5r7R4rcbmK7aWa4/3tRP5uKDln05LsvGCMfrxP+/LPSYkSkf7C196+BMncwDwnDExTV0LWIAG7Z90wMyCnNl5+03AUT3R6gNp30Gq1EocRBxkWsUwJqJHanoAVMccdS91enG4gEc3v7TcsLbOABCb4L+TK430YKDvONo4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918803; c=relaxed/simple;
	bh=5XM6upyN+8yya/SyR4m9Q0aBOleMC94xM1b9SOu7wpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cREROtxXSk5CRzcHJeSsdG5FQncWu52vRELnHTVFDnj9weRcUDT8QVJ4FWR65mw+LrSgUwgBYsRXJEqPg/9/Qfv7wXIEL/sVrkxkUIij2V+MpxcTgyMuSMV7fL63lOPA2CqfpS/Qc6raPoKhGWw38Q4xSPUO5MuGAVCBO11A8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3dfKapY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3dfKapY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A5C116B1;
	Thu, 25 Jul 2024 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918803;
	bh=5XM6upyN+8yya/SyR4m9Q0aBOleMC94xM1b9SOu7wpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3dfKapYaYlbbGBnG1DgmK4f+HK+nDupkEK6171LhpWn//fN6aWnmK7yNCciRzbmJ
	 uV3DcOmZj5kj7rVOzDY++h+g4iWQ0UOaECG+pZP+ki/2PT6QQ91jmjSU3Hd+eHDnpX
	 wfTELUBNgNjP25FgSEfTe3JAO/xI+jmUwsN/XKMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.9 06/29] fs/ntfs3: Validate ff offset
Date: Thu, 25 Jul 2024 16:37:16 +0200
Message-ID: <20240725142731.920578719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: lei lu <llfamsec@gmail.com>

commit 50c47879650b4c97836a0086632b3a2e300b0f06 upstream.

This adds sanity checks for ff offset. There is a check
on rt->first_free at first, but walking through by ff
without any check. If the second ff is a large offset.
We may encounter an out-of-bound read.

Signed-off-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -724,7 +724,8 @@ static bool check_rstbl(const struct RES
 
 	if (!rsize || rsize > bytes ||
 	    rsize + sizeof(struct RESTART_TABLE) > bytes || bytes < ts ||
-	    le16_to_cpu(rt->total) > ne || ff > ts || lf > ts ||
+	    le16_to_cpu(rt->total) > ne ||
+			ff > ts - sizeof(__le32) || lf > ts - sizeof(__le32) ||
 	    (ff && ff < sizeof(struct RESTART_TABLE)) ||
 	    (lf && lf < sizeof(struct RESTART_TABLE))) {
 		return false;
@@ -754,6 +755,9 @@ static bool check_rstbl(const struct RES
 			return false;
 
 		off = le32_to_cpu(*(__le32 *)Add2Ptr(rt, off));
+
+		if (off > ts - sizeof(__le32))
+			return false;
 	}
 
 	return true;


