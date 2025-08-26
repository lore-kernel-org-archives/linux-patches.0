Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF3D3431FE;
	Tue, 26 Aug 2025 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217498; cv=none; b=p9TbZMPPZAqDkir7rtuX5dbomcVUJ3DeTM4tPA2S9vyYXIZSWP8UnOD3g+EJkHfS80+ZO5Dd8lZ48oz4ug5s3PODPvJIF9CzhJ9SnZgiqbIHvCy/6r9sCDgwNKrjIe+U3W4biPekS0KLtO/IIrc1+ynBBrpLkkf387zid54yClY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217498; c=relaxed/simple;
	bh=aDk2Fmxy03mz/zhIPm+voGeBiPX1saHzaEkOuDVxfr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkXsJl43qdVaN5Ej+DPnGrsgviOl14UwyZPW0/ppQFc97PYh0t/qNVLHbKiSUfTQmuwrFTlOGaL+uwXHKMlsMGnEZrTR/kqVA8TdMZ0odCR/Gs3HjL53hkeI/C961lyzejayUtWORroriCMXn9E/4hebAsCi1KDL5I5bQunMjFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN20Nb/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN20Nb/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCA3C4CEF1;
	Tue, 26 Aug 2025 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217497;
	bh=aDk2Fmxy03mz/zhIPm+voGeBiPX1saHzaEkOuDVxfr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN20Nb/bVXi+rZpG6NFPBMkP/44O7Q0ylgGuIgpplp/LJ0biQ5Rm50bnb248n/8Jh
	 B7bGEg97QWuR7VT9tx/dJEXhXh+OvPmQi2lxTn5hCUbHKCoaOMP1vlg7Erjlr7j9IF
	 6+FsyNqJgP47JOvAb9YJULJBuL6nojO2xHpD3UzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/523] powerpc/eeh: Rely on dev->link_active_reporting
Date: Tue, 26 Aug 2025 13:06:14 +0200
Message-ID: <20250826110928.516207143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 1541a21305ceb10fcf3f7cbb23f3e1a00bbf1789 ]

Use dev->link_active_reporting to determine whether Data Link Layer Link
Active Reporting is available rather than re-retrieving the capability.

Link: https://lore.kernel.org/r/alpine.DEB.2.21.2305310124100.59226@angie.orcam.me.uk
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index a856d9ba42d2..3f55e372f259 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -670,9 +670,8 @@ static void eeh_bridge_check_link(struct eeh_dev *edev)
 	eeh_ops->write_config(edev, cap + PCI_EXP_LNKCTL, 2, val);
 
 	/* Check link */
-	eeh_ops->read_config(edev, cap + PCI_EXP_LNKCAP, 4, &val);
-	if (!(val & PCI_EXP_LNKCAP_DLLLARC)) {
-		eeh_edev_dbg(edev, "No link reporting capability (0x%08x) \n", val);
+	if (!edev->pdev->link_active_reporting) {
+		eeh_edev_dbg(edev, "No link reporting capability\n");
 		msleep(1000);
 		return;
 	}
-- 
2.39.5



