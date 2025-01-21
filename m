Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE1AE571;
	Tue, 21 Jan 2025 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482508; cv=none; b=UTUtKEJSwjVA1HOexH0TEZP/2VKcIZcq8EcZ1XF4jDqIReyG/iHIMuRySwYQNa5j0+YbktuUn0OiaOC2GDLyRcCaGVA2ui9k120Hg5vh07PZmiBxdvVwlpPzBHgfxjRGnWBdUht1klKlXeC6mlGBanf171N3uGr+P+jM0i3o4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482508; c=relaxed/simple;
	bh=Dtmged0pSoIo4G0Nh1+kPTN8chcgeL0prsneawcuMxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHAriJ+sEvEMjV2pTCg+eBbF8xcZrsAViBhQZWqaDXIPGHubbWBgTDGurhNoCf7kn0qKE0Sp1TsIB6I8KQg7U8CBxSooGo0LLl8RF7jteiXL65EVyMlpphLDyQA0LpRyLkeynhhr8g00G/y+O/2NZUQCKxLhuLrb7HkLQb9awAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxxxCPzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxxxCPzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4781BC4CEDF;
	Tue, 21 Jan 2025 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482507;
	bh=Dtmged0pSoIo4G0Nh1+kPTN8chcgeL0prsneawcuMxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxxxCPzMXObmwr1EdnqR9LhS5KTD74LbLiQZWow/f0zGe/gSRxjBnPm4neFW7Q3Fn
	 gzFBdjJigAk4DWlOXlZR0J19HATdqhxP1Wx5H15a0HxVxoAY1VoFRmEP/smv7YaAuj
	 xwiNpAZNpliHCXEYgW0N0XI1ptJVbs47f6JU/DTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/122] nvmet: propagate npwg topology
Date: Tue, 21 Jan 2025 18:51:59 +0100
Message-ID: <20250121174535.728561403@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 0bda83d0fc3e0..eaf31c823cbe8 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



