Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA74ED198;
	Thu, 17 Sep 2026 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659667; cv=none; b=Mh/HduoHWRQkh73eQTxb36vzusVJAhdLirRRekjeyRg6bp5A7wuPx50SvEc3cHLyfVCvgktLkdOsMCsmnOiyeOuJnbLeNvlo7aBIUX0eVCNuswYAJHNsTinLaY6bYD0vWpH9vz+l9QjcSVK0agNVslxErbl4ztlg3Dc1MyjKciA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659667; c=relaxed/simple;
	bh=sFMxjSZ/0rL2wrkM78CsVw0jn15BxefQpeKyQq6Hwys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHV+u/WmUCi0rHupli23BaOa8AGHTvpMwLXzfdHDc9r1m/flbAI31950wkDC56AM8k5iQT5qQt4qjbSkbvpTARJM0jc7QxeSBUGLrPpv8h0qiar/36GJQvwnXmdidKrjy6p4Rp9uoA//hiqzahC/l2x/hQUtI0v57gOGkxQ19uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLp4csWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLp4csWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B4D1F00893;
	Thu, 17 Sep 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659658;
	bh=go3GbEIkTm4Z3KEvVCVl4dhkZh4R01mUwg4r/pw9xMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLp4csWcffYLCpe/zNUny+8JRx1pDKZZICkJtEGs2K6GvqgUbz6knBAA8Kj2CTxpD
	 rAZ7xHIqix/UfqYE9tJiVi/oojWTiAAI+j9KB1dJaQEfNHokgONNm7wUJGclGCAPbK
	 XVpnAWTxnEUrj4F78Oce1QbLOyid6Qo67gWKFuJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 291/733] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Thu, 17 Sep 2026 16:09:59 +0100
Message-ID: <20260917151358.659420005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c6755be4838d6ccd641effbcdc3d917b82631ff9 ]

add_usable_mem() adds usable memory ranges for the kdump kernel.

The ranges are inclusive, but the partial overlap check uses exclusive
comparisons. This skips ranges with base == loc_end or end == loc_base.
Use inclusive comparisons instead.

Fixes: 7c64e21a1c5a ("powerpc/kexec_file: Restrict memory usage of kdump kernel")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260809162403.18142-2-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 6075b1c88511a..c2ed0d1c92e75 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -113,7 +113,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
 		loc_end = um_info->ranges[i].end;
 		if (loc_base >= base && loc_end <= end)
 			add = true;
-		else if (base < loc_end && end > loc_base) {
+		else if (base <= loc_end && end >= loc_base) {
 			if (loc_base < base)
 				loc_base = base;
 			if (loc_end > end)
-- 
2.53.0



