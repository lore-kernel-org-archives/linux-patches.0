Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C1E2F90C5;
	Sat, 12 Sep 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223253; cv=none; b=dR3nJSKlckPxwovwuWlephR82EgIG/yy7Z0mj76SW/8j+PmQoMyZ1t9M98i1d0PKRwvp3JqWRyyLHWJKtYdJc8cOZnq+fwAHdJKUoIijhOUnvSYPUIZeCXYAxkziJtDC+jM4ew4hwxPhWxUZXYws5U0oY1EV7SvAw7tBPRjYFo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223253; c=relaxed/simple;
	bh=WHnTgWGH07k9S1G1clMntKe22QTmujc/2F2csZ+zZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3JWFVVeYRZgy4bbqFSfiOkVFLShCU1epQSOu0GdUndv2EqXZvYmafIUFlAJ646lf07frHBHnTgpeaXHhOb2zG8uRr0y3IUfLvoUBuZqcoO2yADcHHvO5Ks0O267erw1KBiihsVcnIYJAwmNG4PtqX/sk72lWqpOzPyM8nUKsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vq4/lpAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vq4/lpAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DCF1F00893;
	Sat, 12 Sep 2026 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223252;
	bh=lhDgV+Ky5PI1lEdzgAASQpy41oXf3Izrkq60c1j+Kz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vq4/lpAyCQ+XgnNk/AjyUHJXgHVyZz84yuKvdSCW+n9zFQlZ0Z4Rt+ah4rV7UBsZb
	 F3EhELOzP+8F0uY2IOpF7B1zhyMfT7XB8d74JYSQh3y02NkHNI9MSlXcJIirXdPJSm
	 cmW0tZtICQI6FMHf4H7flwGnoLjHrzipRXdDVQWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0751/1424] firmware: arm_scmi: Avoid IDR updates while cleaning channels
Date: Sat, 12 Sep 2026 08:53:03 +0200
Message-ID: <20260912065624.115187110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit c38b1e19485aaa820e52cfe162525a8af67563da ]

scmi_cleanup_channels() walks the TX/RX channel IDRs with
idr_for_each() to free transport resources and destroy the dedicated
transport devices before calling idr_destroy().

The destroy callback removed each entry from the same IDR being walked.
That is not needed for this cleanup path, and it is unsafe because
idr_for_each() has not advanced its radix-tree iterator while the
callback is running. Removing the current entry from the callback can
invalidate the iterator state. The callback also cannot be protected by
rcu_read_lock(), because scmi_device_destroy() may sleep.

Leave IDR teardown to the following idr_destroy() call and keep the
callback limited to device destruction.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-6-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 639029defd3e7..640d873979088 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2539,7 +2539,7 @@ static int scmi_channels_setup(struct scmi_info *info)
 	return 0;
 }
 
-static int scmi_chan_destroy(int id, void *p, void *idr)
+static int scmi_chan_destroy(int id, void *p, void *data)
 {
 	struct scmi_chan_info *cinfo = p;
 
@@ -2552,8 +2552,6 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 		cinfo->dev = NULL;
 	}
 
-	idr_remove(idr, id);
-
 	return 0;
 }
 
-- 
2.53.0



