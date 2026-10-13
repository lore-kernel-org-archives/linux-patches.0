Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B814FC355;
	Tue, 13 Oct 2026 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895905; cv=none; b=GxDviBd4oGVjrSXdvQlzLWZpjVhcy/vHAqIkCF/gltqWIeMxq16rqTBNw3pKgZa1eaEXiwIKPAmBxi6X6IRqIQv0WR8AXYEpC3yNHCxX8yevIo8tU3SL3NRF25XGNH4QgkET7GQVLEyGf1Gn4xmL9eRPtUEMb0QxMdyXVVrkH7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895905; c=relaxed/simple;
	bh=2bspznArZFXQrgfXkisz6RyWfYonDPOfUb17jO5Y0GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVztRGRHqI4Yba1YMwc/q5K5DXZam05Q6dR+bIhJsEndoXfMUxWh1I2vVpqv9uPtGzqiGyumpZ+SexfDFLLxhTEBmf63M6eMMigSrjGZexqn0AEtOA5ywZadGrkWrfikdOvoK4NKiGOuBI9qmYXQ34oWzn+x0dWteymSvCqeehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqOweUvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqOweUvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1451D1F000FF;
	Tue, 13 Oct 2026 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895904;
	bh=WZ7PWStPEw8jmrEjHTDgA94TJ0SDZDWS1T2ZWF3nH8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqOweUvmGPHHeybXiX9O+7SvgKuGBaStjXVNtvXVXrjtX5dFZX0kWqZrcxhmQ5NGE
	 ypGyzGn29xKFt9x3eKkPWXtGNeIfRjgawth4QwqSTY5x+FsKQoHraO88j23Kw4VkJU
	 dF4xLElJlD2JQFAPUSfZVm4t8ilvZBu6bjVNs3Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 415/497] pmdomain: rockchip: propagate subdomain add errors
Date: Tue, 13 Oct 2026 13:39:42 +0200
Message-ID: <20261013112917.738873931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -900,7 +900,9 @@ static int rockchip_pm_add_subdomain(str
 				parent_domain->name, child_domain->name);
 		}
 
-		rockchip_pm_add_subdomain(pmu, np);
+		error = rockchip_pm_add_subdomain(pmu, np);
+		if (error)
+			return error;
 	}
 
 	return 0;


