Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CD73CFF6F;
	Tue, 13 Oct 2026 11:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892224; cv=none; b=g9t/1WIZC8ZUzS0ctr6NxJJ/ZO+qz18fKbZOmxdQ7mg8OjzM2ZHw0qrBfuMBHHDLfqqaRtdQeuoZ2Ey+nuw3DS1d9IR/Sph/aQsDu3hH3ict2XPqLW9ZEfmiJLZc6qx/xgiD30XWqV1F7AcOQA5t224fhr7DIDwX8X8jrOYubBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892224; c=relaxed/simple;
	bh=kPimffpCsehubwylunr/2eIUKktwjfNZS0Aj2pLwYW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQSkMbo/KCa73SCSeypqsu4wL0P4ClrFI04vBVMJZPdhcmmOesyqcau8WBeEckfW0guNc6s+d7T/IDV6WP40yZuJtwd7iYYyi6k2LeTz8eel56fZ/NGzed2qUaFwx4II1EkwcNmbBduyIUiYD65DIMTJstshLRKBeu1hYyeNLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulok4Y7V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulok4Y7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A041F000FF;
	Tue, 13 Oct 2026 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892221;
	bh=/xcFQ9dSzs7mooHIObtqhAOjKf1+cH4fvFBNF/J7NWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulok4Y7VSFwn2AfJofPQyXJX3ZekDlRyeqFOtA3xdkIqq2c6KwPifvwNI8QEsfXSd
	 qxV9f5pp05shBvVPp6H20zQx6aBO2iV0Jx8dJvTiSpDZ4jiraxKQv4x/9h6/i9cBk+
	 Xm9sl6zkTpYq5E2ZLbP5HIPUAKzy941SH+qvYR4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 101/281] pmdomain: rockchip: propagate subdomain add errors
Date: Tue, 13 Oct 2026 13:36:57 +0200
Message-ID: <20261013112857.589597524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1016,7 +1016,9 @@ static int rockchip_pm_add_subdomain(str
 				parent_domain->name, child_domain->name);
 		}
 
-		rockchip_pm_add_subdomain(pmu, np);
+		error = rockchip_pm_add_subdomain(pmu, np);
+		if (error)
+			return error;
 	}
 
 	return 0;


