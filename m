Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045719;
	b=KEMEX9rHbl6HIxHeHraKFRkn8BQowvARIsixTU8IhCJC2sSBhA8F8IYP7SBZL2wXgyN+
	 M2IOll6mrqIPW+ydeKy2BAMED8ycmdwtdOPat56E9Knp+2eMN4eoHQOaIESicnCwHAGqk
	 bYLbgx+Os+bDmbWEAze/z/RV3gO1EdosLAG7SVws1mVNDh/eJ4rKleMUIMoGwrE+IabE8
	 Nt86Or4ZeDeRFrIW3feVKBdQywNBQux5mpScmo/5XkbM9De7Ni8ZgfGxzc4WH12qBWE4y
	 pStOCWgDtuRa7xolr9FokmZQJxfqIP4lBeVuFaVwJabn/JodpslusHMpbN7JQSKbMow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rc8Gng5ZuMjGK7E2dPR7Kb/fkzXGC2uQhmBAi6Zkx8g=;
	b=A5sxBmk3Yh2srO7MQ2zWOqrGiImNIqyk4KCpO/gnqGpNVUCjWTBRV+rbqRsPSCKbqqBE
	 sNaS31qCVLwhIvQE1M/nfwXPGA7t+wKbXkiWF6LRr1Umse5hkbDHRFT/HLs/7mXQ5h/cr
	 kEXLW/1AiKowj0G0D2kuMAdUTo+seP8sZ5p4G/y61V2gh0ZOCMsWFE0rJUFVyS0EWYRmP
	 T81GkSETjxeB19vT/SUBgJtfkAkfsjXfGDLzzNDcraRYoszSnmb/VpJ3zX+2znWKxkdRk
	 YfzCocj0Mz+DfRy5N2K3aWT6P2pTw+eaV4mD+UMmxIXmD1h0DI/wFJ53TT85wmmU/Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYxWmCCB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBD606A320;
	Wed, 18 Nov 2026 23:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYxWmCCB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BE21F000C4;
	Wed, 18 Nov 2026 23:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045719;
	bh=rc8Gng5ZuMjGK7E2dPR7Kb/fkzXGC2uQhmBAi6Zkx8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYxWmCCB+JSk+TO5I3f6m1Uh8ZrvPkmAFa36fKpvaJRysVMtiaZ1TukVT3GmB+wvr
	 uzofkJFUXJGR3owRX3L0ow2Irl11JeqptxomcJBwY9zdlLEWxE5YH2TNTZnJDJzssM
	 X7BVz4Hz0tRO/fxjv9KGHtqPkckcifkoDon925L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1023/2857] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Wed, 18 Nov 2026 15:34:17 +0100
Message-ID: <20261118150238.432659432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit a65917d0a22f9b10694853b725f9cd399fc3ef4d ]

i2c_acpi_new_device_by_fwnode() obtains an i2c_adapter through
i2c_acpi_find_adapter_by_handle(). That helper uses bus_find_device()
internally, so it returns the adapter with a reference held:

        adapter = i2c_verify_adapter(dev);
        if (!adapter)
                put_device(dev);

        return adapter;

The reference is only put on the failure path inside that helper. The
caller owns it otherwise. i2c_acpi_new_device_by_fwnode() never drops
it, neither on the -EPROBE_DEFER path nor after
i2c_new_client_device(), so every call leaks one reference on the
adapter and the adapter can never be released.

i2c_new_client_device() does not consume that reference. It registers
the new client with the adapter as its parent, and device_add() takes
its own reference on the parent, which device_del() releases when the
client goes away.  The reference obtained by the lookup is a separate
one and has to be dropped here.

i2c_acpi_notify() in the same file already does exactly this. It takes
the adapter from the same helper, registers the client through
i2c_acpi_register_device(), which calls i2c_new_client_device(), and
then puts the reference.

i2c_new_client_device() gives the client its own reference on the
adapter, so ours can be dropped unconditionally.

Found by code review.

Fixes: 605f8fc22442 ("i2c: core: Add new i2c_acpi_new_device helper function")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261012013421.3597430-1-make_ruc2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index b74f41b9515ae..731808ea5c3e7 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -545,6 +545,7 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 {
 	struct i2c_acpi_lookup lookup;
 	struct i2c_adapter *adapter;
+	struct i2c_client *client;
 	struct acpi_device *adev;
 	LIST_HEAD(resource_list);
 	int ret;
@@ -572,7 +573,10 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 	if (!adapter)
 		return ERR_PTR(-EPROBE_DEFER);
 
-	return i2c_new_client_device(adapter, info);
+	client = i2c_new_client_device(adapter, info);
+	put_device(&adapter->dev);
+
+	return client;
 }
 EXPORT_SYMBOL_GPL(i2c_acpi_new_device_by_fwnode);
 
-- 
2.53.0



