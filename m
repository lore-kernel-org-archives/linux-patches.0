Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028C3B8BC0;
	Thu, 15 Jan 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500089; cv=none; b=U7rlqONHQ9tpij7/Ao5kuN1wuvn8O3VZAqFgJz+0haQ2zcI55+ruM9aXhUG9p1L3H7/wPBEVAlCPPSG8BxWWJaaqhvIyONVfyCXxI0EKvsJqemYPX4bF3ReU2dF3W+/67xjVdZBAuYcJmhVufR7wiUiI+o1u5/ZS64+wFRADQdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500089; c=relaxed/simple;
	bh=8BlapkuyYiW857UDmh35MfPY46sQQZuMiQPg77+Zwzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+8OEe8zrcGJBoRgSsUHBwEulF2HDBikNCQUxzUludS00UGGZPzN007Q0JOAvsOncDu5XI5iZgM4div/hHeFn+rJ8k0QIGBMz/UM7ChDBKDEreWM75iJlxzAttgrwR1YKPG8wRcGzy4EprQGWnHJY+C88s5Ss7lTRLNOJvBRmII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiS3ow/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiS3ow/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC1C116D0;
	Thu, 15 Jan 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500089;
	bh=8BlapkuyYiW857UDmh35MfPY46sQQZuMiQPg77+Zwzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiS3ow/NcARMbFTysOfRSPEWNQ3NTWUS0y3ndZSDpWGneJL3Opq9rjWitnho6Vv4i
	 N5Kfjo46fv5K3AhPkbtaQX/XBTXlufaKWUwHOmRXElATKZucA872U56JiAmyXg+sm0
	 us1AVG+Qy/yzvk9abMFU6s5MUdPGw6KrJr1D2izs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/451] powercap: fix race condition in register_control_type()
Date: Thu, 15 Jan 2026 17:50:48 +0100
Message-ID: <20260115164247.119048061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 7bda1910c4bccd4b8d4726620bb3d6bbfb62286e ]

The device becomes visible to userspace via device_register()
even before it fully initialized by idr_init(). If userspace
or another thread tries to register a zone immediately after
device_register(), the control_type_valid() will fail because
the control_type is not yet in the list. The IDR is not yet
initialized, so this race condition causes zone registration
failure.

Move idr_init() and list addition before device_register()
fix the race condition.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
[ rjw: Subject adjustment, empty line added ]
Link: https://patch.msgid.link/20251205190216.5032-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index fe5d05da7ce7a..2019b61e7b901 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -625,17 +625,23 @@ struct powercap_control_type *powercap_register_control_type(
 	INIT_LIST_HEAD(&control_type->node);
 	control_type->dev.class = &powercap_class;
 	dev_set_name(&control_type->dev, "%s", name);
-	result = device_register(&control_type->dev);
-	if (result) {
-		put_device(&control_type->dev);
-		return ERR_PTR(result);
-	}
 	idr_init(&control_type->idr);
 
 	mutex_lock(&powercap_cntrl_list_lock);
 	list_add_tail(&control_type->node, &powercap_cntrl_list);
 	mutex_unlock(&powercap_cntrl_list_lock);
 
+	result = device_register(&control_type->dev);
+	if (result) {
+		mutex_lock(&powercap_cntrl_list_lock);
+		list_del(&control_type->node);
+		mutex_unlock(&powercap_cntrl_list_lock);
+
+		idr_destroy(&control_type->idr);
+		put_device(&control_type->dev);
+		return ERR_PTR(result);
+	}
+
 	return control_type;
 }
 EXPORT_SYMBOL_GPL(powercap_register_control_type);
-- 
2.51.0



