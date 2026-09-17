Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305724F5DEA;
	Thu, 17 Sep 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668118; cv=none; b=l3+19I9PvQowLD2Z/8RajNz1a68M+l06ZNDiivhK991rjX3qVZX9AN+UW4312poUzUCsI7pzoFOpc5Iq9IjJWOfXcwQPU0VyKadSU2ejrTTyaaFKAMTOfSVhHGRyoWXkQZDx8WMpMLs+rPHjS/mgoSNwkzTZcHcXBnPtQOI+Pco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668118; c=relaxed/simple;
	bh=2JfAxJKdxjQ/BdvZKGzujeLmASCa9xiYK7gR9eh+J6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfkVydAlhJ0xggqgsvlBbaAhuhTtAcA3+PxpFb66tlDRxrqcLace5AjwcXUoA7eoZdmC5M/6iTG9/rFN68evua7PsKVKc9hbeJSdeTTTTk+tlWb+kn29VA4Bwl2dAFgxaeBiNEAmxUp9pfzFGxAzdGv2SnNN+VXoIgSmf0fyyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqDy58uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqDy58uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494C21F000FF;
	Thu, 17 Sep 2026 18:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668116;
	bh=Wn0IS3ZPbHbUzyKBa+ciD9sBoEotGaI7WJwPCKjbQOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqDy58uhTJd5opmCeIiRCJMD0SmO7QQTQ/1ng2tLb3c7vOBdWm9XguW727kUaKpaE
	 lZ/V+hE6WwKIpcVUTk/K0ZqIvVzhc883C3T2mRmeQ9eS7izkXk2eCGRdEYNhPsUEo1
	 DxDDlHWXmpXzY/yD5tQTC08A5+Wjc0Xu8N2p87cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0318/1102] scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()
Date: Thu, 17 Sep 2026 16:04:21 +0100
Message-ID: <20260917151547.607217896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 966bf6cc6dd90..b056daa51c2a5 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2646,7 +2646,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 
 }
 
-static void
+static noinline_for_stack void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
-- 
2.53.0



