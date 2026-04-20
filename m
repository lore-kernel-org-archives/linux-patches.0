Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC53633A70A;
	Mon, 20 Apr 2026 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700017; cv=none; b=Sf4FOm5W/Mitng/ZN7tteJ+kA0VAKFwRv/KHPK39I7DyMOCbSEFAvSUJySKOnWClcqb7J33ievStBOBhy8I0AY6ITwtUPLskVYYHTwWWWmRKs7x/iSvKup61hL3dpQ/aqOTQc8/xPX+/RTWpis3ePYvdz5WgzyETvD6TUKE+XTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700017; c=relaxed/simple;
	bh=AVjyD4dNMXBDxkbSAPXzh+coTsWaaP9aBn8EmecrsOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT3fQAGwAv6BCGglHaQFOaKnhgn68JrYvPwyeI03mS5kTahwnMx3LXfiHuBDfg6GoVq0D9ILvE1Da439DYh8seErZ+63Nsb/g2MO0LSZzArs4qDOR+qDBZm1ujb5U+FuzTbVjbJYyiMBy0FqEq4UjhEUvYkpbmxBHR8o+JehiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo9tebck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo9tebck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B8CC19425;
	Mon, 20 Apr 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700016;
	bh=AVjyD4dNMXBDxkbSAPXzh+coTsWaaP9aBn8EmecrsOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo9tebckC7O5/o2mZZ2Oa+beYAJ1ckEaKstEBcc/XP6jwixArP8rpYRRSLWXXZanl
	 KEn9c+XjmzvzkdaTTPKjfllg0sd8+tV3qD1yJetrk6b+LZm4y1KpTGDcvmLrS6gpz+
	 +aBxxz/Q22DXc4+AHETc0q2s1XL1wNzqcTgn1j6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 002/220] RDMA/irdma: Fix double free related to rereg_user_mr
Date: Mon, 20 Apr 2026 17:39:03 +0200
Message-ID: <20260420153934.106843371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 29a3edd7004bb635d299fb9bc6f0ea4ef13ed5a2 ]

If IB_MR_REREG_TRANS is set during rereg_user_mr, the
umem will be released and a new one will be allocated
in irdma_rereg_mr_trans. If any step of irdma_rereg_mr_trans
fails after the new umem is allocated, it releases the umem,
but does not set iwmr->region to NULL. The problem is that
this failure is propagated to the user, who will then call
ibv_dereg_mr (as they should). Then, the dereg_mr path will
see a non-NULL umem and attempt to call ib_umem_release again.

Fix this by setting iwmr->region to NULL after ib_umem_release.

Fixed: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260227152743.1183388-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c454a006c78e0..496d3fedaa9e6 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3721,6 +3721,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 
 err:
 	ib_umem_release(region);
+	iwmr->region = NULL;
 	return err;
 }
 
-- 
2.53.0



