Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FD47A0DD;
	Wed, 30 Sep 2026 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784568; cv=none; b=J1Td/VxhLy4Ton/KiTzwKbNm23PA5KpMjHj1s2qPIewuxVqUnwJ3tgMLsRKKuFEWCqPNGEk5abxznCx4OGvqN9zVs2HfoKhkys/P/Ka7wymKRFyanIAWAB+x0M+01JTtxOpstiJ4eRuYsCB7qCu34cUxFbcVPMH+Mf4tsEyuOSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784568; c=relaxed/simple;
	bh=PfneMWeYAMf/MvzytHdDlKIkIAWPaiUkq14pI+Be+4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9WbjG4TAa6pvtnfD8JsIt6RKZ/En0IC7Z4+v5VHCxE5J3kWCt59COiNMp60gC/sm7eTBy53s0C5l2acbkYCQzDwwRGzLdNyHa5efcHEPQ2oDZIAtpe/04ChE08nu8SEpWArmuHmNgRYtf4HzEAHfpjm1+U8MEhW9AObtOCEt+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM5ihF0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM5ihF0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43991F0089B;
	Wed, 30 Sep 2026 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784564;
	bh=h1Q4DkHuJo47prLLWF2OmyKiH7uVqAD1pD+BH+ZDrBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lM5ihF0QWop/cSkVb8wprLh9ijpKOv7ZeabcIsW2gSWkvOj/iIWO0sMFEhNelVgLc
	 70oB7QlFMv52zI/wqIAtZTRERQQ8iWeQva2NmtiTkuq2nyveCksz+r6aBEuGsPP58K
	 299poHTPFaMk1seuU9pfTuIW7cIK4LZQ1QhBqOqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/982] scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()
Date: Wed, 30 Sep 2026 17:15:35 +0200
Message-ID: <20260930152421.086265810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 57a6ed0b41677ccc5e28cc0976e495c1dfa33747 ]

bfa_fcs_fdmi_get_portattr() gets inlined into multiple places and has
two fairly large variables on the stack, to the point of causing a
warning in some randconfig builds:

drivers/scsi/bfa/bfa_fcs_lport.c:2198:1: error: stack frame size (1560) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_portattr_block' [-Werror,-Wframe-larger-than]
 2198 | bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
      | ^
drivers/scsi/bfa/bfa_fcs_lport.c:1856:1: error: stack frame size (1600) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_rhba_pyld' [-Werror,-Wframe-larger-than]
 1856 | bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
      | ^

Mark the inner function as noinline_for_stack to keep it separate from
the other variables and prevent multiple copies of the same variable to
get inlined here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260611125601.3385418-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index b12afcc4b1894..58360ea4f0109 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2673,7 +2673,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 
 }
 
-static void
+static noinline_for_stack void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
-- 
2.53.0



