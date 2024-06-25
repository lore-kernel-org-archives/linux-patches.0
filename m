Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C491487E9;
	Tue, 25 Jun 2024 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309127; cv=none; b=qlKKK0N8tO2h3e7VcxnPYi/TYV8CkIZvHb8Ngy5no4hpt89ZiYhaRMBzLJiHZwcpAKkGOO3lgMxiAybzHKs9PQfL5np4f3MK6c9iG3i9cRzseQtkexKNIg3iaZ4tiTzSFGrY7zVJOlOqua15bGbYomjGf9eTKyw/SF59ilcEI2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309127; c=relaxed/simple;
	bh=BE9rosMWpePzNrXbkb4ez2gT9dF33yBxIrxdw48nvRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrD8yGbzsb+Gxf8vXdeVmo6rPqsRB282jP2Nxw44O4tIgHiuQy44H4wNXfJhnuKVBJXVkDZRjBzfXufAPfTSDoz9ayd1BKMZ++Iug6ECouWgmmPXmKI0FTgDno1csXsV8JlkgIiLGLMqLF+S7CYOCGUfmnE1VErjixZsCIhuyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RxrMYtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RxrMYtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19797C32781;
	Tue, 25 Jun 2024 09:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309127;
	bh=BE9rosMWpePzNrXbkb4ez2gT9dF33yBxIrxdw48nvRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RxrMYtwjXLwdxOBNCy1d7sOKDaxiCoFgfEq0ImQlgyd6pAVhqPM6BBsFO/jCjRb6
	 rsZ27+sppfLd1IZzJcTF+IfpqSXqheT5VzEfAdpsFHA1dQiTRgCtGrDnzf7TsrqR+i
	 Dj0gWcd/kuJ+8+w4tMg+0vqbpaXaB+dDAyXUjEKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/192] RDMA/bnxt_re: Fix the max msix vectors macro
Date: Tue, 25 Jun 2024 11:32:56 +0200
Message-ID: <20240625085541.168320001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 056620da899527c14cf36e5019a0decaf4cf0f79 ]

bnxt_re no longer decide the number of MSI-x vectors used by itself.
Its decided by bnxt_en now. So when bnxt_en changes this value, system
crash is seen.

Depend on the max value reported by bnxt_en instead of using the its own macros.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1716195418-11767-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 9fd9849ebdd14..5b481d8539eee 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -106,8 +106,6 @@ struct bnxt_re_gsi_context {
 	struct	bnxt_re_sqp_entries *sqp_tbl;
 };
 
-#define BNXT_RE_MIN_MSIX		2
-#define BNXT_RE_MAX_MSIX		9
 #define BNXT_RE_AEQ_IDX			0
 #define BNXT_RE_NQ_IDX			1
 #define BNXT_RE_GEN_P5_MAX_VF		64
@@ -166,7 +164,7 @@ struct bnxt_re_dev {
 	struct bnxt_qplib_rcfw		rcfw;
 
 	/* NQ */
-	struct bnxt_qplib_nq		nq[BNXT_RE_MAX_MSIX];
+	struct bnxt_qplib_nq		nq[BNXT_MAX_ROCE_MSIX];
 
 	/* Device Resources */
 	struct bnxt_qplib_dev_attr	dev_attr;
-- 
2.43.0



