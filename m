Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036881;
	b=aY7O0WGJbvgrWuvGu6652yXHxZW9/WjQrCh3Ta19tRAAHsNMNrQC+RVmAIXaZyn2Qn6j
	 PZnshmNjKCQnpBXi4Regv1bi/Uq3GX0CzMQzCvOnLophMzUZ4Xyk7s67yue9D3ZE5bpFr
	 a8ub7WZVv8j0sESwiTz9XxD2CeR5byjWtBzN1J1B8exf+6Cwgz4XUj9kA+bknnugkDeQR
	 n/rWXPb+P2x7/z4BlqKViJit+I6hoiOTkj6mapVatcjrnrNZzjlBkXhTnNEDjoy0TUxFE
	 a36+woibtDadyvWJwRF6n1DydDP6zr0DjUvpiIatC7InBCu2QVoThLbbB1UUIbRKpLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6HT0XyFegTE0bNkXeCkj1u8BcNfDKEGamfq4pObXxc=;
	b=3wtYa6UIg6q+NhTNmn/+55QAcoF5FhGxMbB8wpK0ZHx9wqW2+PXi/c06KqrrOUB611GL
	 LK4aRHKda0unQ/DBpwkqSOHRSGfmNYh9f5z9IuVLBi2x+KRM7lt3ut/+M6X26hbDpQFq0
	 yKVNdZkn165gK51OJEpm9VWgb59isWVAbpjvXN3j5uldeCYfHuaftkwRnuOqbKLyvCGAX
	 Khb21mZ/UpVWayAu/dzqA0OMV+t0zrt7sgyMMrYYk/XF0APObOdsm6UNtJcX9MtkXSFbO
	 4LsezWSVBr3WpWaUsus6ted3ItE91dOZu0rtn/IUoE7RSCovHyV1EDGJWAV46eN4ZbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WcH9ycwM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912A3606A32F;
	Wed, 18 Nov 2026 21:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WcH9ycwM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B9E1F000CA;
	Wed, 18 Nov 2026 21:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036881;
	bh=M6HT0XyFegTE0bNkXeCkj1u8BcNfDKEGamfq4pObXxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcH9ycwMsMu9u9PktH5QjkCnNIimUpyCWzGzNvNrHRGWEIrfChPEhN7CT7BSmgcTj
	 RSq6LoE7haJc6g6YboiOvN+Uc86Vz9iqsTcZ98cfgBuN7F0aEJvsCIULVeNfjKntgi
	 hxVT/7f3u+p65G43NYUHvl0Tme9B/uUwTsVY+r14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1199/3318] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Wed, 18 Nov 2026 15:30:21 +0100
Message-ID: <20261118150356.140468683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



