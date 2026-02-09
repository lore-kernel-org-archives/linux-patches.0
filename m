Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F936BCE2;
	Mon,  9 Feb 2026 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648163; cv=none; b=sLZszRONd8KOxu1lQElzSpi8/azvQIvzo/oNCPc7zMWqE0zvq6fDAYowZHQlPALdraekwabXIjRODMilqxShiPtXc5UqXZtD8anLQXvZGnQjXXmFWTq3XLY55ka6viibwoCk5NnsrJ4EtGT6m2V7wDjOsojRmFilO84iU8CmslE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648163; c=relaxed/simple;
	bh=Th1Qb9yqHxS0UrtUKyyHMlT2juJRWo4T3tt9C9z4Ru4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIaKHnup/oeXkkUk41jgzIXWxUqAb8gYoU6iljgks2emupPSRoXJkw8paOBohCcC6/Hfhkmsk4ZHUXvWq2+8NaMZk9A9g8P07iXYjAkDesg3KIgoNPi71CMN+rAIhYxXUgKqkkHH6/E19lks7Rh6lwL60FbYslXb21tT6MCrse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyTcNup5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyTcNup5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854BCC116C6;
	Mon,  9 Feb 2026 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648163;
	bh=Th1Qb9yqHxS0UrtUKyyHMlT2juJRWo4T3tt9C9z4Ru4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyTcNup5+NWKGXEHUcfRHYMtV0f3E5asAee8YdxDcaBMyiQcQKl1Fo+dCJjiMkyGK
	 LUd2emvCSOn1qt/tlb/EWzLiqhR2u0RuP9tOEDNdmLvMfFmcl2HRVMRT6OLefn4ZS0
	 RfPbJQ8LoDszFqV08Nxx4RmVdNI0pnZYavvqOUUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/69] HID: intel-ish-hid: Update ishtp bus match to support device ID table
Date: Mon,  9 Feb 2026 15:23:53 +0100
Message-ID: <20260209142302.833082415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit daeed86b686855adda79f13729e0c9b0530990be ]

The ishtp_cl_bus_match() function previously only checked the first entry
in the driver's device ID table. Update it to iterate over the entire
table, allowing proper matching for drivers with multiple supported
protocol GUIDs.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index d4296681cf720..67e3215a332e6 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -240,9 +240,17 @@ static int ishtp_cl_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(drv);
+	struct ishtp_fw_client *client = device->fw_client;
+	const struct ishtp_device_id *id;
 
-	return(device->fw_client ? guid_equal(&driver->id[0].guid,
-	       &device->fw_client->props.protocol_name) : 0);
+	if (client) {
+		for (id = driver->id; !guid_is_null(&id->guid); id++) {
+			if (guid_equal(&id->guid, &client->props.protocol_name))
+				return 1;
+		}
+	}
+
+	return 0;
 }
 
 /**
-- 
2.51.0



