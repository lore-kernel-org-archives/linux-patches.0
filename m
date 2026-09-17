Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A54F4035;
	Thu, 17 Sep 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664595; cv=none; b=NV/Ugle/0WednGBWa3E55VwMT22KTuRpDrxfL39zbLLBuz6kPylkf1V/YNLCveN0rPZQ9lSPFFZfhb0CVphllZDeKg1M2CZCpDab6lLU+Pao5xAPpJwhRQfmQuq2fHqRb3CadpPwvRNWRo1c5X+31yZ+XYEFoi8AGofP3t36Pvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664595; c=relaxed/simple;
	bh=xlX9HJzsFiIFW5yRNJCM7NyTRmUOA/9FZ+POTKLx/qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmwn+cAeuCPgnufAJ7wx+VGTHChrWQ03eejHLivC/UKVNACG3wBFhtC0EKzZy4vASQu7gjqvhdx9s67f4L66yXkL3ozp6y9STV9ZYVpKO1MivBzoIABhGEe72+UoXl7FEVil6wuuDhpNKr2vXhzoY0AXI8gQCHbui8R/HV1MB+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpA+AhE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpA+AhE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572A1F000FF;
	Thu, 17 Sep 2026 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664594;
	bh=E5+9hNc3SI930eD+xHjMklAZe6nixy4dFsEfj1qGurk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpA+AhE8F3tceYJ0Fdo0f9/dCMV11YMI+6nE1G9hTFhgX+xSa4T84rtbLrlnzurv5
	 GGdp15g9Nm7cK3dVNrq20Bw3OypR99kBxZE4z2X2e4m9nkC299AfjvMpAvmzZ4qVmu
	 Myyw2vS319AXsgpx9moexUZ/dhOjFHDwSo/JmbVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0423/1250] scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()
Date: Thu, 17 Sep 2026 16:03:38 +0100
Message-ID: <20260917151603.482688012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 9a85f417018f9..cabe408214b3f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2627,7 +2627,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 
 }
 
-static void
+static noinline_for_stack void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
-- 
2.53.0



