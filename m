Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D97E344D9D;
	Wed, 30 Sep 2026 18:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794570; cv=none; b=giwX1jGTvyugw8Zb9nYD+2sBd8jP2RVpFxvQB/iVw4uXTE2K/Y97s/S3KLm7Iixiu8xyAs9+2e3olG9aUL2VOx/1Qibz6qlwGKHXzfaO7HhjqE8FYoVGagQDogtHALs2CIJFstplSB8ExzskVeOkf9DONbfwbPdd8msf++0WWAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794570; c=relaxed/simple;
	bh=8Ftaq9BR5TyDINDDqgRuUPwnx0yRGGtJIqgZz6+gBSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTOVXhllOPwaKrw4jki23MLsbXLJfGJ93K6G9Tm2GAtaIa8zs+QrQbyCRYfbfg28QmnWWPiZw47TUxDXgx/1xWyn608FU9N8L92ALBlNN7X10/K4dvSHlLooEUxe+sSIFNqO0WoB16ACqKHFxI8ZsEP6TZ8R+Y5Q7nrh9+ZYNYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmLMb3JQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmLMb3JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F511F000FF;
	Wed, 30 Sep 2026 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794569;
	bh=ncABMScEATuYC1JznMPehG+pKHGVRoJl8nMiLm2qlyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LmLMb3JQkk9b5jvpwaNQwnQRpBLeK9oo6Emx+8ikJ9FsCV7R/7hsYxnLxs9aGWwkx
	 rIZbEikG997gUDeYbYjZ2yFb2XXYRM+bxdg+kdQI0SQmzVAWZ6KgVSWwxvSDbwGL0P
	 DFmmfXobdz6Cl5Yi81yLCQlmAjkxwpbtt75miUUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0230/1193] scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()
Date: Wed, 30 Sep 2026 17:15:14 +0200
Message-ID: <20260930152439.305921643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 008afd8170871..7800af967a5c9 100644
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



