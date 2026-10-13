Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8664B95C2;
	Tue, 13 Oct 2026 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893048; cv=none; b=iWNfr4N9BPytvtoo8Bg2b+jffG2bwW3MWRzvgIBMQrZbY+jbqptLPUZRfIuVnxVzQztQ5FoUBDa+KnjdAZOIE14SfQOrz+/38Lq5laXF+lvOflcPOVfaKUF+RNBlAQuW+fkMaJ8Aw67UI7fRuiCusD0PHX3f171kw6jA77USEYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893048; c=relaxed/simple;
	bh=0Vj8o051uQ/gEl9t57nZgdDNAdKwhepIlk1jEns8t04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO30kJeDPyotRHfKkstLLlOByRa+RdYjyvgpFrMhik6S91WYv8DYmIjEb5lEg+diGozIAqQmP+RqfOifOUxfEJmi8FnbStVmMbO3wWtZY6JkjAi0B+NvktxaPL+F3cOtKvwm5ZSAU3LbgcL0VKcZeBGtdonoRc55jLJ0IsFavdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrMKH2HF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrMKH2HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7FE1F000FF;
	Tue, 13 Oct 2026 12:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893047;
	bh=5TMBr6OCLMhZH2QVv0RRfoNsmKBoSef8FtcHyekPOvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrMKH2HFR6Bf9F6KEs3ahgxrN7+KifUzBTfJWSqTl1ysGSmlC/3xPNiI2Y36suDst
	 t3mjHx+5zWyR/Z7SOZxs4H0UYK2xt3He5d4s+a/iPvWi42bwK4SJezL6l+zUl3kCsL
	 Xi6SwUUOe1GRKYTNlDEpG+4bx2fy3ZPvWZjQrRWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 094/621] pmdomain: rockchip: propagate subdomain add errors
Date: Tue, 13 Oct 2026 13:31:29 +0200
Message-ID: <20261013112923.081762505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 4c0d69d677cf5b0065ebbb3ceb8ba66fddbec630 upstream.

rockchip_pm_add_subdomain() ignored the return value of its recursive
call, so a failure deeper in the hierarchy was silently dropped and
probe still succeeded with an incomplete domain tree.

Fixes: 6be05b5ec161 ("soc: rockchip: power-domain: add support for sub-power domains")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -999,7 +999,9 @@ static int rockchip_pm_add_subdomain(str
 				parent_domain->name, child_domain->name);
 		}
 
-		rockchip_pm_add_subdomain(pmu, np);
+		error = rockchip_pm_add_subdomain(pmu, np);
+		if (error)
+			return error;
 	}
 
 	return 0;


