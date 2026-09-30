Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377D936826E;
	Wed, 30 Sep 2026 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796554; cv=none; b=N9N/rDsYaarOQJ0BFrBcNpj5gUakrMveU6E1P5XLRT5Gh83zTxd78sbP/58g8nPEtMoRpaD5puqDz9xPG4snPsTVfb0TTuvHscH6xmRif52qUaFGOl2gIHgEqJzb17Ms0exzAHlbo6w+TrKOo03kuDuargZGUiumrE6xBUKJM2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796554; c=relaxed/simple;
	bh=PHevpp7KE8/yNOw9qAV1zGA19DOxBRHOqat9+4OPyeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urwnuN7gHH7t1MT3AzhRnBjAIzS5kgBXanCaDG2Ldg758XA3d87Sq4PsthW5eyNa5ok/ufs7y+5KsajKSs2PGJqXwjfcl1L+yARWsAhrqWYnMHZm0kR5FmKxswmNMlDi+F4vmaP59gCBi5nAMv7dY//R3sE3XqtR0N8DPE4oR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9sZ3XpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9sZ3XpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CAB1F000FF;
	Wed, 30 Sep 2026 19:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796553;
	bh=DFPpOjLqzRMfqmNQRvOLcIuHyZK43WAS6Lv1UVAH9sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9sZ3XpN4cEo6gycLVt9EXbV1KToAuVBHD1D3K3MG47M7BgGIkF6DKsssoFlj430o
	 HocCuuUrUM6vx2yIxhZ4plw9WCfUFDmIF6OwC4BwG2UKu31XPkt4AEBz4/8qegV9cy
	 NaW0Y2n5bhLxu9dvtJaE6arvuFMSFWEsK4fz3qgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0909/1193] hwmon: (w83793) release probe data through kref
Date: Wed, 30 Sep 2026 17:26:33 +0200
Message-ID: <20260930152454.437696161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c702a5f18b780e477eccbbab558e590e9673e4cb upstream.

w83793_probe() initializes data->kref to manage the lifetime of the
driver data. The normal remove path drops the driver-owned reference
with kref_put(), while watchdog users take and release additional
references through the same kref.

However, the probe error path still frees data directly with kfree().
This bypasses the kref-managed lifetime and discards the initial
reference without a matching kref_put(), leaving the reference
accounting unbalanced.

Drop the probe-owned reference with kref_put() instead and let
w83793_release_resources() perform the final free, matching the normal
remove path.

This issue was found by manual code inspection.

Fixes: 5852f9609d21 ("hwmon: (w83793) Add watchdog functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260914073638.1662500-1-lgs201920130244@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1929,7 +1929,9 @@ exit_remove:
 	for (i = 0; i < ARRAY_SIZE(w83793_temp); i++)
 		device_remove_file(dev, &w83793_temp[i].dev_attr);
 free_mem:
-	kfree(data);
+	mutex_lock(&watchdog_data_mutex);
+	kref_put(&data->kref, w83793_release_resources);
+	mutex_unlock(&watchdog_data_mutex);
 exit:
 	return err;
 }


