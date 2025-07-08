Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B62E542C;
	Tue,  8 Jul 2025 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992120; cv=none; b=BX7gzJgp4CRV6M/w1cF0OKAV26/A3lODKEDhi8HnZ8ZUkXLz7n1Xv1E0Kqhu5GbFva4uvsEbsuB9M5AkshhCnfqSu4IBkinU93HaVL7BQwQf84IcMRc47wQR2axeKe0ovkieUkakWK59QjCadGdyjX1jzhhcLkGqiMfU9dkG+uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992120; c=relaxed/simple;
	bh=vrD9e3+w6zpVAXEeZovkka1cIjd86FKnl68FhrwbT1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsRKuo/DbdIp1DjkcmQWX1rR07QjN40IVDuqKVxfgZgeqJHy4IS9aEufOWg4lqw5R82NYjd2P1Q3LZdo2rn1kMDA+fQx2+SplEE+oNZB8wf0h0Dz6P/X0UwLa+b2DqW9fhSEQfsUYP+M83Jngpgm5LTaE6/oxbF2I1zM3h4ghCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAmBh4IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAmBh4IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AF9C4CEED;
	Tue,  8 Jul 2025 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992120;
	bh=vrD9e3+w6zpVAXEeZovkka1cIjd86FKnl68FhrwbT1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAmBh4INPvtWhL2Ih0WH3LPsOMeTqOyyvVz+KXEuAdX5QohsCcLjojeo5+1s0OGOZ
	 GUUBeutC1xcgvP2roCfo07oc6qSi2evGeJ67nDtkgPLzIWnuFY4XVaFouvOJ/htReg
	 /4f2l9kmKVJV0k4acOYC8cq+em418RQfEnudpMM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/81] platform/x86: think-lmi: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:23:57 +0200
Message-ID: <20250708162227.037690385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 5ff1fbb3059730700b4823f43999fc1315984632 ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-2-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 6641f934f15bf..804e2493d7d21 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1380,7 +1380,7 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 fail_class_created:
 	fw_attributes_class_put();
 	return ret;
@@ -1602,7 +1602,7 @@ static int tlmi_analyze(void)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 	fw_attributes_class_put();
 }
 
-- 
2.39.5



