Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB723D091A;
	Tue, 16 Jun 2026 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633414; cv=none; b=nc8BWcTfaYaR+8SAQtczs8OHhjFEmL+5/1NkKR1ciGJIWGbK+rV4MwbDPmnR9vaoSnWyGLvV0Z1jYaz3+R/DtU6O57BwvCTIVY7pg/hkyBennDYswyJWsnGVKhCbgQKwRMeknXFYQyhCoAYJKzjbHi9FjljeZHQMmr2LY9FOPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633414; c=relaxed/simple;
	bh=eUhvbSBG/Rt9cElXMrtFnZVflHTFNuI8QhvLZ+y4/3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiNOBJJ52ia1H7/oDARkQlBxV/M3UtiBMOnoChekboiBTaL6csvgagxNyrOW5I3nVfdEPBuAD3bNdXpb72WqWeF/uWHxmZAeauUqb+lF7PJxfqs6PYY6FoWvoUmmfns/3rHlFrP+y7vMFmtJc/icQwlOx0/7hvamkcKU9dfToRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGV09fqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGV09fqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167A41F000E9;
	Tue, 16 Jun 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633412;
	bh=qmvxLqF5b6ZWYxU5+1wQskHAMjhlbETBVo9/LijALck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGV09fqfZ+NSuzH6WUN4KA+wx/BlyCuDExcNV8nVxol22iKHxcwdu1KfDiLzEarXe
	 ar0UXEiGuYHFAPLfTt2ZZ2QHKj65/cVJmgj8aVD2NhRhclpzluOKXiVD4rs37U+eR1
	 wuBXfT3qNxgOpl8fkKr3fPmzIhALD9kzYyGPuIow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 074/411] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Tue, 16 Jun 2026 20:25:12 +0530
Message-ID: <20260616145104.213563163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

commit eedf7602fbd929e97e0c480da501dc7a34beb2a8 upstream.

The work_refresh may still be pending or running when the device is
removed, cancel the delayed work_refresh in remove path.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ssp_sensors/ssp_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/common/ssp_sensors/ssp_dev.c
+++ b/drivers/iio/common/ssp_sensors/ssp_dev.c
@@ -602,6 +602,7 @@ static int ssp_remove(struct spi_device
 	ssp_clean_pending_list(data);
 
 	free_irq(data->spi->irq, data);
+	cancel_delayed_work_sync(&data->work_refresh);
 
 	del_timer_sync(&data->wdt_timer);
 	cancel_work_sync(&data->work_wdt);


