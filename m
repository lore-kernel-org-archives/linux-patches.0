Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062522;
	b=heB9T2AjcOmLHu7HtVL2OjKKIWk+WZqnvQ+93gFkJdDDMii2aPoGmHdCr9mF6gNPOMB4
	 HcdW9c3kH9Tx2QVIkBRB72d5waqUdS2xNQfBzL/Rk0DthKF8uXw/llkw29KZdTLYK14AE
	 aDRJWf8XijLF9+zd2zIpxYbyGYTMBMXACHlDBocYcDv38EmfCThVKBpaDWKQVxahJNC0x
	 SMdND2tvK9BimDOzG1cjjBhUPN/26L24XHS1DVHradW+vPjwuHdn+Y89Xg+aCFRa8jtMw
	 1dfd4gvxWyYHnlMiMS3eO91oFMpBEwXHDe7BKz/uVnjf14kwbhYlrx6c1Km3vRlXEFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dcu4GUxC2Cny2QZ2c+Ju4c0B4yJiulTAZsxxtoQ/WHE=;
	b=GutE/Hz6XutukKD1SrMlhpbYhwPBZ2OdHvetnf9UMba3TZdqbjJIXXZTla+iQ1b3Hehp
	 THu8DWuPw8a2sNpwOGWLqHBBekHvgQvijut8mf2V41gu7OrTFZdou0bo9Dwquc5VSCYEx
	 xzcbd96ru+tkL/9SC3QvMblGSKshMyGW+yQ6NpjeLYchui/Z+VwXZGjEXkjufsXieuEar
	 2HWccgFTkEQ09IUHIBmNKoKWB+Zhjc+7qhMw0wJR/58vfW7cdje8PdiMAJ7dHwhQZ0hC5
	 TqLGr/srX2LO/Ayu/VKa8XqotNbbYVRZYDZe3v/cTfl/YFvzmagVISJAW0ZCZG4Dm9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPd8EfLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01497606D836;
	Sat,  7 Nov 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPd8EfLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B218E1F008A2;
	Sat,  7 Nov 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062521;
	bh=dcu4GUxC2Cny2QZ2c+Ju4c0B4yJiulTAZsxxtoQ/WHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPd8EfLD6pSQ8YOLZvApo9QbpTD4bOQIib6bj6mAWFWLDwbyY4S1s8z+4Fown24/P
	 tK+N8+YYIDPYFw7jmsb1TTjQipauCgV0grbv1u3lvK1QACkL0xdQhQOFEO22OeskWU
	 u2t6/mJCGngN1NdIkDD9PsCc6P0iQnafibl9ygeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1416/1536] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Sat,  7 Nov 2026 08:57:12 -0500
Message-ID: <20261107135037.598632142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



