Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE7360EF0;
	Tue, 13 Oct 2026 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895872; cv=none; b=nygdMorxcFrkeljo2SjdY535djm5BAAylVqobqWRPk8zU20t/lnnZNwkdoxf/s+2z0s+DzriKIj9Xoeg2dGveREwtsEgKbTQegee5/xsWnapyj8CvceQyPQdsjBZs7AzlE965qP61RzLXYajr8SuNk/GBdrfODxXNjFf1xQ4dwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895872; c=relaxed/simple;
	bh=NOzSpj6qgjsmKdiwDuzkrdirsBci1v9K9nrYVyIAPro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+9MLIHpAeNdrrIBeFBjYDP0rOEH3PsNFhm0k8IrndgfEX2aMKKVwG+ito1xSF+SSgRU1QcJaqtW73fQDul1tvXdbfKNexYzfkWBC5YANed/9HXKLPyugmlnethoqZvHZBFTYZsdDuN+Qa358syB6CX0fBs2t36kYvunNZ6EbF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psELd3/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psELd3/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91211F000FF;
	Tue, 13 Oct 2026 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895871;
	bh=AjRNDwH3qnfsC0d4a3oQM0WypJn++eb7WoeIoMfcCm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psELd3/PQvJLSp/DX71b4hvTNan4ycgQgMhiPlbavO8VVRzuJvccpSOef36FC5xTV
	 oT3ubDy6xDb7rpur0yGd/m3ZsebLXM0eXEmvah5CAmGKgiO9BHz4xJDzf+jnbPXCix
	 5UQHN12Yvg7qcQfdoGRbgNuZkDKI9xNCycFsOHXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 414/497] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Tue, 13 Oct 2026 13:39:41 +0200
Message-ID: <20261013112917.715684917@linuxfoundation.org>
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

commit d8b3847770661b7109146e6479eeadcdab9cecf0 upstream.

When of_clk_get() failed in the middle of the loop, the references of
the clocks acquired so far were leaked instead of being released by
the error path.

Fixes: d909072d0521 ("soc: rockchip: power-domain: use clk_bulk APIs")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -734,7 +734,7 @@ static int rockchip_pm_add_one_domain(st
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 


