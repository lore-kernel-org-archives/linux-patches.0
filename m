Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D602B5111B5;
	Wed, 30 Sep 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786261; cv=none; b=KPHtEhth1f1N2m6GzYrRrolvEmaH2Ob9Xc0CfNwKolVBFs4iKJg6eUkyXj+oBlpCsEJfOeMSHP7/2piZoP0W67hBSlh1ZB/f/KaH3fcsOloJ6P8fM5ak4nxAR5cA4AB1GxtR1huzm03Ddx+SWKCXY45wAr02O6rh6OFhToHcoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786261; c=relaxed/simple;
	bh=sveeHH9pAM+sUPuXrd7XH9QglO7+4+XI4KyBVctsOVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prvkAXUs+xJ6LT00bOt09LT0SmFKojb/Ux7YdYGAy1JXxGLPUAa8TTfhduAzCJCknR0bnhSvLVIJbpjkQNhP64k/5zTamf+Z0jIZzIZ9mqYFlYBttKSOG6oPtrb2vnlpfh+iztvdUFwqSwgK+etxeucIh8+WkZkempnN66zZNAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NliXWLPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NliXWLPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402851F000FF;
	Wed, 30 Sep 2026 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786259;
	bh=vHb2IOnkp5UgyzmnzeZIrYHDvOcikNBUkf9vvG9/Rz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NliXWLPFsWmIHsl2lz/cOqDn9aFUB1yWh14sGd8m6u1Rxutw3PQMq9w/6UNoV8zHV
	 uNAJScqlXz+Em3PF0pBukbNNl0RbbdyBMWiyZp19EmCOEdTwLXTTwZ8FPFJTHvh+1K
	 zf76kiaDj711F5djev4Y9alZdII5VdxAhAyEbgw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fabian=20W=C3=BCthrich?= <me@fabwu.ch>,
	Hans de Goede <hdegoede@redhat.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 800/982] media: ipu-bridge: Fix null pointer deref on SSDB/PLD parsing warnings
Date: Wed, 30 Sep 2026 17:25:36 +0200
Message-ID: <20260930152433.938810561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 284be5693163343e1cf17c03917eecd1d6681bcf ]

When ipu_bridge_parse_rotation() and ipu_bridge_parse_orientation() run
sensor->adev is not set yet.

So if either of the dev_warn() calls about unknown values are hit this
will lead to a NULL pointer deref.

Set sensor->adev earlier, with a borrowed ref to avoid making unrolling
on errors harder, to fix this.

Fixes: 485aa3df0dff ("media: ipu3-cio2: Parse sensor orientation and rotation")
Cc: Fabian Wüthrich <me@fabwu.ch>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Backport to 6.1.y: apply the sensor adev assignment in this tree's
  older ipu3/cio2-bridge.c and cio2_bridge_connect_sensor(). ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/cio2-bridge.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index df6c94da2f6ad..e68b735a150a9 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -280,6 +280,11 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 		}
 
 		sensor = &bridge->sensors[bridge->n_sensors];
+		/*
+		 * Borrow our adev ref to the sensor for now, on success
+		 * acpi_dev_get(adev) is done further below.
+		 */
+		sensor->adev = adev;
 		strscpy(sensor->name, cfg->hid, sizeof(sensor->name));
 
 		ret = cio2_bridge_read_acpi_buffer(adev, "SSDB",
-- 
2.53.0



