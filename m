Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975022FDFF;
	Tue, 22 Jul 2025 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192223; cv=none; b=ixwvLxyo0K/VNXN4p193iM1WqpJqZfkXa+KA74f1PCOr0D/mTJvYrRoTCw6ob4tvxqq6lcHMTWmZqGAUC51bGGLWgeydiopt5pdG+ByvKZKX4JVFIzUy3kEdWs8PVmE4PwAdGCzBjhZk0xR6xwsREpDS4I/Tspydh8v6VJKUTEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192223; c=relaxed/simple;
	bh=/Se7Teyt4xmVh9rWX6IAH1HkHwkqyjCMrjS54KvWodM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O55T6MKsT7xVv3GpJAbZ3+lGsbvxbroBAcGRO0aU4aF+TvEftksUAaYlXzksWgRartvsRtjkQ0G8mCSVTcx5Tq8ON3D7y2Yyyzlfd10N4suwDCG1w+yAom1H1OosQrT4+m75/4AUyn1RswUmX9DCjm03zEP812e4y5hfmZ7mXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eXxivaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eXxivaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF172C4CEEB;
	Tue, 22 Jul 2025 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192223;
	bh=/Se7Teyt4xmVh9rWX6IAH1HkHwkqyjCMrjS54KvWodM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eXxivawoWNqC9PVM6vvZ/5YKPQmXDCligWQc9xPEKMoOzUtrebEIGOxSO49aXCdS
	 xtLA8K/Xp23qO9x4QgHSIRrygRKyyHz7PSAbFR6/DxbJZe9zUyN9tKrRzFPbydtL9N
	 F8MT48HOVtz+5U/20Q+qr0urnqGFDNdzfI3aAtJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	INAGAKI Hiroshi <musashino.open@gmail.com>,
	"Michael C. Pratt" <mcpratt@pm.me>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 79/79] nvmem: layouts: u-boot-env: remove crc32 endianness conversion
Date: Tue, 22 Jul 2025 15:45:15 +0200
Message-ID: <20250722134331.302130274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michael C. Pratt <mcpratt@pm.me>

commit 2d7521aa26ec2dc8b877bb2d1f2611a2df49a3cf upstream.

On 11 Oct 2022, it was reported that the crc32 verification
of the u-boot environment failed only on big-endian systems
for the u-boot-env nvmem layout driver with the following error.

  Invalid calculated CRC32: 0x88cd6f09 (expected: 0x096fcd88)

This problem has been present since the driver was introduced,
and before it was made into a layout driver.

The suggested fix at the time was to use further endianness
conversion macros in order to have both the stored and calculated
crc32 values to compare always represented in the system's endianness.
This was not accepted due to sparse warnings
and some disagreement on how to handle the situation.
Later on in a newer revision of the patch, it was proposed to use
cpu_to_le32() for both values to compare instead of le32_to_cpu()
and store the values as __le32 type to remove compilation errors.

The necessity of this is based on the assumption that the use of crc32()
requires endianness conversion because the algorithm uses little-endian,
however, this does not prove to be the case and the issue is unrelated.

Upon inspecting the current kernel code,
there already is an existing use of le32_to_cpu() in this driver,
which suggests there already is special handling for big-endian systems,
however, it is big-endian systems that have the problem.

This, being the only functional difference between architectures
in the driver combined with the fact that the suggested fix
was to use the exact same endianness conversion for the values
brings up the possibility that it was not necessary to begin with,
as the same endianness conversion for two values expected to be the same
is expected to be equivalent to no conversion at all.

After inspecting the u-boot environment of devices of both endianness
and trying to remove the existing endianness conversion,
the problem is resolved in an equivalent way as the other suggested fixes.

Ultimately, it seems that u-boot is agnostic to endianness
at least for the purpose of environment variables.
In other words, u-boot reads and writes the stored crc32 value
with the same endianness that the crc32 value is calculated with
in whichever endianness a certain architecture runs on.

Therefore, the u-boot-env driver does not need to convert endianness.
Remove the usage of endianness macros in the u-boot-env driver,
and change the type of local variables to maintain the same return type.

If there is a special situation in the case of endianness,
it would be a corner case and should be handled by a unique "compatible".

Even though it is not necessary to use endianness conversion macros here,
it may be useful to use them in the future for consistent error printing.

Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment variables")
Reported-by: INAGAKI Hiroshi <musashino.open@gmail.com>
Link: https://lore.kernel.org/all/20221011024928.1807-1-musashino.open@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: "Michael C. Pratt" <mcpratt@pm.me>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250716144210.4804-1-srini@kernel.org
[ applied changes to drivers/nvmem/u-boot-env.c after code was moved from drivers/nvmem/layouts/u-boot-env.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/u-boot-env.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -139,7 +139,7 @@ static int u_boot_env_parse(struct u_boo
 		data_offset = offsetof(struct u_boot_env_image_redundant, data);
 		break;
 	}
-	crc32 = le32_to_cpu(*(__le32 *)(buf + crc32_offset));
+	crc32 = *(uint32_t *)(buf + crc32_offset);
 	crc32_data_len = priv->mtd->size - crc32_data_offset;
 	data_len = priv->mtd->size - data_offset;
 


