Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9812135A0;
	Tue, 17 Jun 2025 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178601; cv=none; b=a6g4b7J1cD920jxOO1Xh4zAWTe5YAHhRVY4OpH6KE9ggvnPDzj0Xq8r4OFOVKwXro3Edn4VuOtXiA2CewOTuZa0nIgQGzq0SvXYu/BslB5FUFUR2piweqlj4vIR4OCK0IDZ76+dWxlQUhCq1S9ZyhMgygUyXujOZhSUDQ1iFq/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178601; c=relaxed/simple;
	bh=LgIr7/SFoZj1DRDdzBp4lzmZszGc9ws7XHqhGXLwOPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeT1T9av8/l3kYC9h3ox9hAZuqbYY06/jtucqBZJ8fVIjMpeAyVRexIOBqvx+oIjFQTXc0VzGxOQGtwkaNDmRIuPCeFw7lxbmlelUo9rm+7Yr0U3fBpktEfjpm4RVQTjrtQSLMUTutCHUbz7qJf9uUlBkFgvOmlrl7ESXWiShWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx7q02sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx7q02sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1A9C4CEE3;
	Tue, 17 Jun 2025 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178601;
	bh=LgIr7/SFoZj1DRDdzBp4lzmZszGc9ws7XHqhGXLwOPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx7q02szbZwDNdoDNo4xRbb3XkOU4JKVpD7nMEzJvWWtx4waACh3LaYAkON/kWzxe
	 9H/6xK0pRAt7afBRc9Hbva+p9TUR9mZ4QhBOP/KRLLqlfgax9PWpS39sGtH0aDJZHO
	 XCYBSzUVwQKjM2iJpG3yeLCHXdRd59/keIOxU2uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jensen Huang <jensenhuang@friendlyarm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 496/780] PCI: rockchip: Fix order of rockchip_pci_core_rsts
Date: Tue, 17 Jun 2025 17:23:24 +0200
Message-ID: <20250617152511.692058155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jensen Huang <jensenhuang@friendlyarm.com>

[ Upstream commit c7540e5423d7f588c7210a9941ceb6a836963ccc ]

The order of rockchip_pci_core_rsts introduced in the offending commit
followed the previous comment that warned not to reorder them. But the
commit failed to take into account that reset_control_bulk_deassert()
deasserts the resets in reverse order. So this leads to the link getting
downgraded to 2.5 GT/s.

Hence, restore the deassert order and also add back the comments for
rockchip_pci_core_rsts.

Tested on NanoPC-T4 with Samsung 970 Pro.

Fixes: 18715931a5c0 ("PCI: rockchip: Simplify reset control handling by using reset_control_bulk*() function")
Signed-off-by: Jensen Huang <jensenhuang@friendlyarm.com>
[mani: reworded the commit message and the comment above rockchip_pci_core_rsts]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/20250328105822.3946767-1-jensenhuang@friendlyarm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 14954f43e5e9a..5864a20323f21 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -319,11 +319,12 @@ static const char * const rockchip_pci_pm_rsts[] = {
 	"aclk",
 };
 
+/* NOTE: Do not reorder the deassert sequence of the following reset pins */
 static const char * const rockchip_pci_core_rsts[] = {
-	"mgmt-sticky",
-	"core",
-	"mgmt",
 	"pipe",
+	"mgmt",
+	"core",
+	"mgmt-sticky",
 };
 
 struct rockchip_pcie {
-- 
2.39.5



