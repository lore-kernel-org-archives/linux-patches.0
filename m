Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAA13C0A03;
	Sat, 17 Oct 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257296; cv=none; b=jC+fNOAbu6CiVfPStNruV2MqqyWATjeHuC34dBDIkPScv8R7WRS0oD5H1WibDe/RNQAm+Ukp5YddCA1OWMWk1D7Z9AQrqW7TPSb+POv4cikQgyKcYEYQYq1GXwLiCgRJq1+r1bvoR+McQ3WL5Vj0kFSMMI862QWe4OnqAVNMItg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257296; c=relaxed/simple;
	bh=bEfaBMY2zKp3WJzKB1od6/YRrgBKwcwudoZj0vPFczE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP1HQVEGLienwZr9bNYEyLuco7omffWODhbrjRXZPlyWSSHGK9WQXaKVE2A2uxXv/Icd1EqmllHacZWJFPwdriL4jDVkYlV9Y01sCUGaMmHiYU6xjeis30u+xWLbQhZGnhqN9xiBzJqIwX79xck47RZSchUFQtnd/f1sWSr1nwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja+PYmTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja+PYmTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040421F000C4;
	Sat, 17 Oct 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257295;
	bh=qBAZTvKE8Gf49kueAs8fwOdUQCzKNnV2YRBjUnwKu8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja+PYmTUGWF4VUnPPgohysySmiJQXcRe34D192FZf1ywViJ9wXsgJK2jAJtOgIJb9
	 tbPLbXNn0aoRnChf4rp+UznJZSJLMopt1YoceilYh3Nlv7W6z8W/eWwmOtBpEB4l4U
	 ELRPLfKWa4nM58uE6/XZ7PR24UzZ3klSgqo5vKO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0513/1674] pmdomain: rockchip: propagate subdomain add errors
Date: Sat, 17 Oct 2026 17:46:25 +0200
Message-ID: <20261017160444.273220782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
[ sashal: goto err_out instead of return, so the np reference taken by for_each_child_of_node() is dropped ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -854,7 +854,9 @@ static int rockchip_pm_add_subdomain(str
 				parent_domain->name, child_domain->name);
 		}
 
-		rockchip_pm_add_subdomain(pmu, np);
+		error = rockchip_pm_add_subdomain(pmu, np);
+		if (error)
+			goto err_out;
 	}
 
 	return 0;


