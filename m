Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3517A93F;
	Tue, 16 Jul 2024 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145109; cv=none; b=XWQonMM7g++V104nKACUPBZ2TuhC0WKO6lKrXdhf3yb5JOjnbLGjKhhBLJmktFHU3Y0BxzumxHNh5QfJgbt6j79D59p2FugGuKV4s8ouyEeDPPY/UFBGDwMJVHBbiNwIKMiT+7n4LKSSwvjnzuarS9PCqPoh2CKx4rn+71mCeKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145109; c=relaxed/simple;
	bh=v6QHiDWQl86+a3lWqOuKi1mG6k9c5v2JPXaRsZfxLLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YzmMjhJuNRuDwaoJYP4rm2CTDU4h6MaCTAzmgXnDW3dszbSb4pLb8r7FPyqLdW0FayR0sIyGbE/ZHXMYlVsIqwcFJx0LCVaMTy5KxXUC9NPhldOMHi7sro9MeWwmQ05+ND5jpkKjxMH0LtD18TpioZBcu2+U7vOygMmbobPkWzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MoVbymU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MoVbymU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B981DC116B1;
	Tue, 16 Jul 2024 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145109;
	bh=v6QHiDWQl86+a3lWqOuKi1mG6k9c5v2JPXaRsZfxLLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MoVbymUQY1qkfJAOJTI0sAdqHklH+T+O/acsDvZKC+hrNAOokCu0O6t9zIX3CyTB
	 7eA5yYhKfnYiXee7L5AlGxHIlkkzN4bgDSziworlt5kMlU25SPYKXMZP2xTeVew8xk
	 uDRd04/6d5dj86bDj7pp9BbVOUgHNudaoOzcebKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 102/143] nvmem: core: limit cell sysfs permissions to main attribute ones
Date: Tue, 16 Jul 2024 17:31:38 +0200
Message-ID: <20240716152759.903475840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 6bef98bafd82903a8d461463f9594f19f1fd6a85 upstream.

The cell sysfs attribute should not provide more access to the nvmem
data than the main attribute itself.
For example if nvme_config::root_only was set, the cell attribute
would still provide read access to everybody.

Mask out permissions not available on the main attribute.

Fixes: 0331c611949f ("nvmem: core: Expose cells through sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -462,7 +462,7 @@ static int nvmem_populate_sysfs_cells(st
 						    "%s@%x,%x", entry->name,
 						    entry->offset,
 						    entry->bit_offset);
-		attrs[i].attr.mode = 0444;
+		attrs[i].attr.mode = 0444 & nvmem_bin_attr_get_umode(nvmem);
 		attrs[i].size = entry->bytes;
 		attrs[i].read = &nvmem_cell_attr_read;
 		attrs[i].private = entry;


