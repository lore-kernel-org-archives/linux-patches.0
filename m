Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063589;
	b=x1TQ/2BffW3XA50mJdDKACwtXZMB/DbM8fTVD3M9hJSAZ8MBZQ34UZKIbSD8ZyaEnUZ5
	 tbCUPUrDxROHlWbfP7pUmK8s5ywJg3W6PLsKyyNPfDchmUe/oFIdzWrunpAud638DA/1P
	 MkwMaJlUIm+czMvoEB/vnJ4sLjRqGl1KTlN23pCZLd1GYYTlBK5sO2yW2iuow938I878r
	 PdQrvQsCs9JRPPLPBkzwDjp8fYpiuJyqtsKm8heZmlbulb+MfUgFozh7m/WQuwNN2DdB7
	 rY8Cg5LsOq8lAtZbYdbT5zYyEPkqHmUh2rra5zKT1sd5S8dhDLX8thqjAa46M8NEaDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g2jGv3g9E8cc7h3lttgGoT7SArB/HbAOP7BO/OqDGMA=;
	b=eWJ8f6RuYyOvHrWZuC+de9MHIZYLK4Vs6sAtaH4zmxcQnweT8/aWrBeS0dHIAj6J1fAc
	 lJkLsvchCDEn2oXzSlAnd3uw+l4qb0pOGmJ8yc45CAHDPCcC795qRE4vgBI9O/KG75W2y
	 uNC18UhvbfpDti10VHgeJE5NyYBT5FhriktzMdCbymeyYvKVbbCANUb2SXRUycVEVsAQj
	 y3pGlWG/Zc/BcTnWUlm9BHhrqtphfEM8NPA1T98GOavC67G3CQCo3f78kpxgficOWxCKh
	 vn9jnquH+sUoW2kN8B0ZIIoWHa49+/HXwar9d0pkiWKk4Jhican+sNcHi1qng+nDjpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2ZX/zXM1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E70B60A263F;
	Sat,  7 Nov 2026 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZX/zXM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22D41F008A7;
	Sat,  7 Nov 2026 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063589;
	bh=g2jGv3g9E8cc7h3lttgGoT7SArB/HbAOP7BO/OqDGMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZX/zXM1lDbtIy+7XbSdeJRGZxzCIyySLWFqxoNmKlSGAx8bRSeGiPVE6yR4lyFNw
	 EvG0u2bXMMPhmweWVwtPt+JY07FMVhjW8gvebmUcfO2+P64/cDpZxcV045dvr08xuB
	 3kJEApr3fYUj8ShjIEzVoMyVZzcmHLRgy51vCRdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 715/869] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Sat,  7 Nov 2026 08:56:37 -0500
Message-ID: <20261107134917.103887277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 98ebbc973f212..8805fc454a4ef 100644
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



