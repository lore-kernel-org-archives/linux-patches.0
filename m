Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA79E35209D;
	Tue, 26 Aug 2025 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218219; cv=none; b=uUQduFVUJZdxoVhNdHdchNt1F/bWwjzheTu++PysOSeBpSijYsr7s3vExd568irzi9MNN6pb/StlfSNzoc/VHI3vGDAH8mrnJCGVv1lj+kjDApw7UB6S2KnPAukewFePeTEtSAOGjw10CKl8/nzqa5MC5vVRlpc+bXfribyFV9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218219; c=relaxed/simple;
	bh=HevwML83kkrw+yC/+IBfSoZ99k8uFb34/GHDyx7Zv+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOZNcbHk/3dVEw5CvfGGUBnXP3XGU0yILjZ95v4KBkvTsqpZG5zzgviFHUqzgz2uzGef3u0YoOhUrsqHwa+V99DTZbcvijiE1qgdWIVdl3avW1EUjbWfH2fPe9f9f6KifbvSUovFnVxUaYbGctfMCKQ8e3U/bAKrQTzaf94BVqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUditx2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUditx2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD0AC4CEF1;
	Tue, 26 Aug 2025 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218219;
	bh=HevwML83kkrw+yC/+IBfSoZ99k8uFb34/GHDyx7Zv+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUditx2tNvjgS3saVGPH61MrcdOZ63WUmcyQxDy3ulh4OBEyLCP+UxisD/eiOJUKo
	 zs3XAqmfO4GnuUB5+OF2F4LEhYEqbzW4VIgoQQF5v+vlDI8YJnVmpu03iPhvxNUK5N
	 2WxFDIjTITzZ7TGPDsqNAc4uqSZO//WHnEdpLZJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.10 408/523] most: core: Drop device reference after usage in get_channel()
Date: Tue, 26 Aug 2025 13:10:18 +0200
Message-ID: <20250826110934.522282914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit b47b493d6387ae437098112936f32be27f73516c upstream.

In get_channel(), the reference obtained by bus_find_device_by_name()
was dropped via put_device() before accessing the device's driver data
Move put_device() after usage to avoid potential issues.

Fixes: 2485055394be ("staging: most: core: drop device reference")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250804082955.3621026-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -538,8 +538,8 @@ static struct most_channel *get_channel(
 	dev = bus_find_device_by_name(&mostbus, NULL, mdev);
 	if (!dev)
 		return NULL;
-	put_device(dev);
 	iface = dev_get_drvdata(dev);
+	put_device(dev);
 	list_for_each_entry_safe(c, tmp, &iface->p->channel_list, list) {
 		if (!strcmp(dev_name(&c->dev), mdev_ch))
 			return c;


