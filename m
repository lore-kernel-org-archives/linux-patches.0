Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B819A171671;
	Tue, 10 Sep 2024 09:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962116; cv=none; b=azuw+9rgolqqVlSuGsnz6phUDnvG5ExmOV/3c9qDzIX+brVk3PKwYiuAhIaKTcLDxo1BGA0TB5HnhKgKRPEJ4AZcZPC0IghWymldRgzLn077qaIKaos7AoSgH9zIb1ORqTVbFKaxKEAGerFAPnJ0x691RfYFoLRhnQgUgcVfXuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962116; c=relaxed/simple;
	bh=O/Bl08oIhLGEFj4S+fygYsH/T0y318yCZTEgd/UTYq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ln2mL/JHNhQsgw6UregQtQUkKMb/pQUsYUU0AJ1UW7FKPQ3oI8kEr24sRAc5w6w8f49Or7QSuxYPpt/j7NGVrf94wjEpJzz+pSppQRi0iMdQgGaKHv53ly1CUQWTlf/tdwwSkvLhnFgAGZ3kfyGnX0lTWUw+CtjUN7WoEYodkTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB9++rwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB9++rwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425CCC4CEC3;
	Tue, 10 Sep 2024 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962116;
	bh=O/Bl08oIhLGEFj4S+fygYsH/T0y318yCZTEgd/UTYq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB9++rwI7MdFRnp/0uoXxd5gRg909RzXy/mAFcYGfqtEbU2H5uoxPXfM7cJ2xCoyb
	 k4Ot9MEt0IpqyQh0ijcrFPKi0oj9wNWdkZNiIiKbXpPD6vw/8BfRwZnmECe21blrPL
	 +GkdVFPeM1ap9yHKfWdTmxMDAkelEPnQ2E+27JUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	stable <stable@kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.10 300/375] nvmem: u-boot-env: error if NVMEM device is too small
Date: Tue, 10 Sep 2024 11:31:37 +0200
Message-ID: <20240910092632.636183481@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Thomson <git@johnthomson.fastmail.com.au>

commit 8679e8b4a1ebdb40c4429e49368d29353e07b601 upstream.

Verify data size before trying to parse it to avoid reading out of
buffer. This could happen in case of problems at MTD level or invalid DT
bindings.

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Cc: stable <stable@kernel.org>
Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment variables")
[rmilecki: simplify commit description & rebase]
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240902142510.71096-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/u-boot-env.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -176,6 +176,13 @@ static int u_boot_env_parse(struct u_boo
 		data_offset = offsetof(struct u_boot_env_image_broadcom, data);
 		break;
 	}
+
+	if (dev_size < data_offset) {
+		dev_err(dev, "Device too small for u-boot-env\n");
+		err = -EIO;
+		goto err_kfree;
+	}
+
 	crc32_addr = (__le32 *)(buf + crc32_offset);
 	crc32 = le32_to_cpu(*crc32_addr);
 	crc32_data_len = dev_size - crc32_data_offset;


