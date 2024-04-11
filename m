Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6645913B5B9;
	Thu, 11 Apr 2024 10:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830090; cv=none; b=QBDP24526bOkZLCJcHHDGT9MnzwyAAsX655Z/O7BfInUONDI7NT9XxqGiCaHVQFYLV2B/+zq/+XWi8LaaCSZ88gtjDzOEOKG6ZkfYwOiWuudmjVLg41jYXDxKo2vO1sLpLtUhO5b4IOKfcBkvoauuxUe7OhtWQTaFJr1aVuIQBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830090; c=relaxed/simple;
	bh=SLNx4GmimIpgCIRRelAxZRMKjwrf94FuPQRR0SSC69A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDMxdWb1g4/xCGnLbGgNRPKTGsbHHyM2DdzQwDsVlDiO+PmFybUHT6jr/UgpVgm8g6TwoI/zxc/QzSMNqzqRS61ASnKc/kToJBNx461BYbThzGrxIPvq2KSDWOSZ2S4eCbsgNDQnDIKWyDIxRmOOH9MXDF5TTmFTFNo/8hhdKAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lg9BTMzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lg9BTMzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E157FC433F1;
	Thu, 11 Apr 2024 10:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830090;
	bh=SLNx4GmimIpgCIRRelAxZRMKjwrf94FuPQRR0SSC69A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lg9BTMzTUMMXFtauTkPHf0juwSgCXUXb38m0aMb3b2vgOzAQWXMEprQL2K6k12XMw
	 mwkOevuddQMlFYeWEPKmIMlW4YuVeVJZcFcfyWkvzH9SBapSB9V5lbRSRRz0uQV11M
	 8kknFblP+qGgtzHzwFAEZYpn2quoFdWEu+n4MJJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 031/143] firmware: tegra: bpmp: Return directly after a failed kzalloc() in get_filename()
Date: Thu, 11 Apr 2024 11:54:59 +0200
Message-ID: <20240411095421.849166763@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 1315848f1f8a0100cb6f8a7187bc320c5d98947f ]

The kfree() function was called in one case by
the get_filename() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

Thus return directly after a call of the function “kzalloc” failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/tegra/bpmp-debugfs.c b/drivers/firmware/tegra/bpmp-debugfs.c
index bbcdd9fed3fb6..4221fed70ad48 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -77,7 +77,7 @@ static const char *get_filename(struct tegra_bpmp *bpmp,
 
 	root_path_buf = kzalloc(root_path_buf_len, GFP_KERNEL);
 	if (!root_path_buf)
-		goto out;
+		return NULL;
 
 	root_path = dentry_path(bpmp->debugfs_mirror, root_path_buf,
 				root_path_buf_len);
-- 
2.43.0



