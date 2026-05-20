Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA352F363F;
	Wed, 20 May 2026 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299404; cv=none; b=kajd1KDMrB13CCGVmZO/n6z9EIM5KJgBUJxdXNyw3Spe5Gw3MOY6kEfURslX266QiZGMT6VjSKypqFWDVX/yRuUqSdOJTuVigXdb+aD+sZhyXs1NYiVfDDFV/qY/J6YA7gOD/IU6ruN9UPOeGm5s7EIcfVyYUkYUKoJzoyYyuj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299404; c=relaxed/simple;
	bh=SeRpk0Z4IPvnCd9bem2FMWBsAqvXsM1sZtw1PoYHv9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBfmbvrHRGWIguESByBlcISlyu0gSw2lypbTZwB6fT8Q6/wF3yIeQa0hw47ZU1BZ3muZ73SXlL8R9ZbeFoId/+3F2bvTf1Vfd6ptHea9oyHplYD0YrHknPhvfy5IabZt4cB3fLokQs3/1hoh2av6WhA+BRNJHmN0E+GlRucBClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+yoinMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+yoinMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A873A1F000E9;
	Wed, 20 May 2026 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299403;
	bh=TKqEahbXYTAFFjYfAv06mjgDhbzGRHRQP5KO2qpcBhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+yoinMQS/50OwM3K5e0W16SC8tblHCpkKcvTyZKboPcwXpOHylOMPpm9H7iVyf7s
	 DWBRSP0s/DzYUex1JXLwoYsa6pjz+U3FUcFapbqGnKHUbGfgxpQwczUQAw7FwO1ESz
	 BtIIUn/fMNjymhlW/Lyak9GteyZB/r7npdnR+0fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 760/957] arm64/scs: Fix potential sign extension issue of advance_loc4
Date: Wed, 20 May 2026 18:20:43 +0200
Message-ID: <20260520162151.045854520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 4023b7424ecd5d38cc75b650d6c1bf630ef8cb40 ]

The expression (*opcode++ << 24) and exp * code_alignment_factor
may overflow signed int and becomes negative.

Fix this by casting each byte to u64 before shifting. Also fix
the misaligned break statement while we are here.

Example of the result can be seen here:
Link: https://godbolt.org/z/zhY8d3595

It maybe not a real problem, but could be a issue in future.

Fixes: d499e9627d70 ("arm64/scs: Fix handling of advance_loc4")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/patch-scs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/pi/patch-scs.c b/arch/arm64/kernel/pi/patch-scs.c
index dac568e4a54f2..3944ad899021c 100644
--- a/arch/arm64/kernel/pi/patch-scs.c
+++ b/arch/arm64/kernel/pi/patch-scs.c
@@ -196,9 +196,9 @@ static int scs_handle_fde_frame(const struct eh_frame *frame,
 			loc += *opcode++ * code_alignment_factor;
 			loc += (*opcode++ << 8) * code_alignment_factor;
 			loc += (*opcode++ << 16) * code_alignment_factor;
-			loc += (*opcode++ << 24) * code_alignment_factor;
+			loc += ((u64)*opcode++ << 24) * code_alignment_factor;
 			size -= 4;
-		break;
+			break;
 
 		case DW_CFA_def_cfa:
 		case DW_CFA_offset_extended:
-- 
2.53.0



