Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065350;
	b=2enNckht+lQqounEqmnB3K/CZl0NWYacNFOcZJ1ZKaWunTtnsYHXrMy6T31yGnGF3afN
	 hJ/t+czTqyv79XHNoX/t+P0DpiPTZKPBcKuf7N/S4IMrsKGNhvkaRxNSKcp035kaR+lYD
	 R11VQJ4t6+RDBpj1BXozTWvBN4/4duKK6M5NRqcD7yTu5hjx8lMp+wiCf51nmfv87awnn
	 G3L9mjXL1Wh2Wkt4l4l7J4CBtZzs75AHD+XdNiHyGatiBjaCWjniCu0Vu6tYsFXIfJHpw
	 68JEAIpDnpPVMp3uHymR0YTb8W5QkAGFDqP6YipBJXeVcepR/rI1CC4oEizr9CrxFOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yqve7dMJHSM1mK4c+wVu0YoADZkZeJQK+i79JRts10A=;
	b=Q5375CVYziUzL0L12G4r7ZGG6GCzz6K862sFdYAod6XFFI8mWJwwjjrbGwxCjmtOSYUd
	 5RvJuO6ipsjH4MAru2kUWWqO3jLYvPvxV/ooYDFr3cT+ukYb+7ve8EhEgi+qlAhqwZ2MP
	 T3asEpGRuZj3eOadjPxKtfE5Dp8BFruK+ZK0n9mrmHoPRfTZxoX/pqbD5C5kw4aq5nApp
	 AUnL8zhGIMMQpflAizTtjsdfxKJgNZlebHVLQm2jGZu8WtHOm3Oa6j3AraSlYdVbB8217
	 RrFCp8dVdB8aG7/PsL0oXrxGkvV0m4ngeZvHLqxCzrW+5OIXxNqMDt9bkdmo47KtljQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TV8nm7lo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6521A606A326;
	Sat,  7 Nov 2026 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TV8nm7lo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCFA1F0089F;
	Sat,  7 Nov 2026 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065350;
	bh=yqve7dMJHSM1mK4c+wVu0YoADZkZeJQK+i79JRts10A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV8nm7lojgvpK/F+FiKoXBTbpKUYBklqSJW++SLGKInyNkL1IM0H4uxJaag7CUs5y
	 P++pJQWdg0gsP/GK2kzwi5t0qNgFICwPu5Ps7YjuLuEE4GQD5/nUhga3t+CbMr7fBX
	 YGHl6yCKTfBtCeRA54GF7dFbmyn5XIcJJYiZB6nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1027/1257] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Sat,  7 Nov 2026 08:55:23 -0500
Message-ID: <20261107135007.685771143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8f3bdd50186e3..37d1309e93b59 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -547,6 +547,7 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 {
 	struct i2c_acpi_lookup lookup;
 	struct i2c_adapter *adapter;
+	struct i2c_client *client;
 	struct acpi_device *adev;
 	LIST_HEAD(resource_list);
 	int ret;
@@ -574,7 +575,10 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
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



