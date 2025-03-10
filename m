Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95332232378;
	Mon, 10 Mar 2025 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628517; cv=none; b=EWU4wTPH8kuLM/IGbQp3QAgRl+wA5CJSlNc7P7PAnhFzCr22ehVuUnE0yfTUAxD4Q0hh4+tGn/lghslmynveQgD0LI925rOPJ/VV9SUw1/KCrTXH3/NYP6W4AUwwda5dveSq4FYveo4ibs3ukEzgWBNgAaCfkEZEDQ7QKCnVASo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628517; c=relaxed/simple;
	bh=+xCaLLgbiUOkCen/jHx4c4EptJftgK4Z2SiG7sVDCbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsHNOCfLRcvit/37bjv868YVEpnBCxJeoQmWUSaRWqBML/PVaSOrbMLDSUs+zAoUq1v5HPfOgoE7s8nxA2tMw6A0L0m46fuc3dgPw+dtwgWBZDOlW/fboejKcK6ijzUraOwzEDycEDHLuV0XX0za/ncVHxQe1LLQCDW3GZZcRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7dmDvsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7dmDvsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E0CC4CEE5;
	Mon, 10 Mar 2025 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628517;
	bh=+xCaLLgbiUOkCen/jHx4c4EptJftgK4Z2SiG7sVDCbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7dmDvsFI49nB4viNRef758XvQFyjO+CuGBOO4O0+mA9lcn+FqWL7QqLO47PqScAG
	 WOv5+PiBsA3ESU0s8Yl3lc3K80yUkf1K0Rot0Ya2gGtv5mM+e+7lZy4mB/TRiclbph
	 T0TV9iRznt+5YY4Lw9pjauDW6oKuhbB8uvDBbRSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.1 084/109] drivers: core: fix device leak in __fw_devlink_relax_cycles()
Date: Mon, 10 Mar 2025 18:07:08 +0100
Message-ID: <20250310170430.905508462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 78eb41f518f414378643ab022241df2a9dcd008b upstream.

Commit bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize
cycle detection logic") introduced a new struct device *con_dev and a
get_dev_from_fwnode() call to get it, but without adding a corresponding
put_device().

Closes: https://lore.kernel.org/all/20241204124826.2e055091@booty/
Fixes: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Cc: stable@vger.kernel.org
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20250213-fix__fw_devlink_relax_cycles_missing_device_put-v2-1-8cd3b03e6a3f@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2023,6 +2023,7 @@ static bool __fw_devlink_relax_cycles(st
 out:
 	sup_handle->flags &= ~FWNODE_FLAG_VISITED;
 	put_device(sup_dev);
+	put_device(con_dev);
 	put_device(par_dev);
 	return ret;
 }


