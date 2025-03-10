Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93B21E087;
	Mon, 10 Mar 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627000; cv=none; b=k7HYNU+3Zk3xmfbGLFIvah92i1g3OUjWaNFfT6efZ7n79xqljRDNHm/KQzf9jFaXT7CgJUTAK6x19OdLXFgqw+88yN+2oj3uYy7s9s+R/VsittqiRxsLxDffS75jx/ieriviI1wk9dMNKm2W5ZIl6FuSbJsjm2EMnPNQmAOaC/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627000; c=relaxed/simple;
	bh=xGia79jGQqqBFnJIvjrMymqc5aCuJTIvJAQ6G8/8AqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD8JqfFAHlu3ROVKh3nSEiM3tHzKjrSZMel4Ht/U0427g2GyYwaJkS3TNw1/ObiqHlRR8LdKdR3lus9r+blOFGIf4ptJ34MDFAcPx1ctvSEmyvwGkDHKm/BlLfmk12w5nT5xxoj4Kv7ijFxhphlpkYEALegDu+ycCANC44r/wOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ7UJiO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ7UJiO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462F2C4CEE5;
	Mon, 10 Mar 2025 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627000;
	bh=xGia79jGQqqBFnJIvjrMymqc5aCuJTIvJAQ6G8/8AqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ7UJiO908FsBuj+eagJPtGvQ/wFdQIPznDy9e0TIe8xnjdQQT2AUMXKDQ2a17hYY
	 m6ttQo5kcLpe5qz5VL1Jk34lO8QGgrmctO8VIW3l8J2D4BA13xcQQBg3jTl9REdpPM
	 LeX4hvqlG0Tfxpin9nQ+5mXTajDrXxwJb1USPJjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.13 187/207] drivers: core: fix device leak in __fw_devlink_relax_cycles()
Date: Mon, 10 Mar 2025 18:06:20 +0100
Message-ID: <20250310170455.217006123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2079,6 +2079,7 @@ static bool __fw_devlink_relax_cycles(st
 out:
 	sup_handle->flags &= ~FWNODE_FLAG_VISITED;
 	put_device(sup_dev);
+	put_device(con_dev);
 	put_device(par_dev);
 	return ret;
 }


