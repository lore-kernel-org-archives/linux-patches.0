Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054004;
	b=xKgqHvYTVxae43BJwYcTqJglhTuROEkXYLSSUjBkkUnWVKDmj96mok0WtDqav5irma/q
	 8Jo/x9geMBVG/hys/eA4CdStczmc2pqs24adqSG9V5moajP4zU5xwEw1EcrCF0EGz03bh
	 ESwk+N/y4axK7jkPmVIp7Cmi60rFwmSlq1VL0XRyzE7B/g5KPfe9kqrZ3Ldl/lb20fQi7
	 HWQPTfept1UJJDsUQPinMKpPfJu7xHehRfuh8kVEHnyPKASsM5z7qaA+AiAhn3zp8G5kU
	 /CfOvapat+4UbcFsRhhwspOTqGr2fmZtLguJJX3/3TiBXE7ZcCXov26xGZMZ/GBR6Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCJJFV62dKcpQliZ5s/vXB/+QMiOX0e5ngdXU/8zKdQ=;
	b=4nLl8hPdMzYZEqvUoIlH+Qp0otQ+ITCYj8DJ9TYSMJsTqS7cC+bjkXMUXagymkFZXf03
	 n1h6dTeDlzcWjXCx38a2Ln+u6kPbfyU6krliX/e0SouUSHukAMSe73jOoPeczcnQbpOTJ
	 zup+0RKBmhzgk4dt/wUlTpeOUqhxFmfZ1AyLEsBXIgcJTD718m2ML90DIqajDhi9w9Dm4
	 G7Klv44oZmFp9//Z5RS0GQ0dF74J8pgnPYdQ0NhH/VTNPGqAtOGPR8FrvZFBJM72Y58J8
	 +BCpARApTLkQ4UDcHTM/ZOG1+LgzDa2deUZcoriC8Sm4reR41K+ZD2j56PfAJHqyurg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGt5hQLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B040E606A31C;
	Thu, 19 Nov 2026 02:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGt5hQLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC661F000C4;
	Thu, 19 Nov 2026 02:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054004;
	bh=oCJJFV62dKcpQliZ5s/vXB/+QMiOX0e5ngdXU/8zKdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGt5hQLfZ0HniyRK5SoTNpMCeDC5EChC0ilENtnXRAtdiCxd3iT6kU4fn7TYL28b7
	 6FJm9GzzYYcCutlJ+f/CGniZQyR5irfSL4o8obJ4cMZNRmd5pgulmo4dtVzkVB3jDL
	 0y2/11CYDdCwFIUy4jEVy+R7ggbiDtHtM0YnqAQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1122/2214] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Wed, 18 Nov 2026 15:46:38 +0100
Message-ID: <20261118150056.978264990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1ee80ada212c3..9081ee60bd702 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -524,6 +524,7 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 {
 	struct i2c_acpi_lookup lookup;
 	struct i2c_adapter *adapter;
+	struct i2c_client *client;
 	struct acpi_device *adev;
 	LIST_HEAD(resource_list);
 	int ret;
@@ -551,7 +552,10 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
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



