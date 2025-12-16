Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7AB3570CD;
	Tue, 16 Dec 2025 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888149; cv=none; b=u/G5K9wwZMRbrzK1T+QiFlUVfqbSCQO04WIctaQ2Nas+wufQ2KejGu9i9WtU1E/Ke+DTWwF652LdNxToP+VF00rNKZwkQr+XgzZ/ePxKLW/SCJOOby8ja6mDOuKhWfne4eZ8bk3Ewvy61GZ22bvC5AvWaKO10l1wcIb69ZX4QVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888149; c=relaxed/simple;
	bh=puQp9YOQ/DJip3AOF60lovAXQC9bAoTss44CBIeVRMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0zdwiD65msWf5vqeq0Gr5IXp6s30GE3BRobfM8Opp3LZnay6/tid2lmQXgRdSiNKOOIIwnUPnM206/LKAkUg7QsqP3sKSDavs8bur7keCGVEACvH1Y5jnsBWLxf3qK5atCmOiRSD8HrCDGoY8121cudyiWzc35gDE0DxTty7nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KW0htVtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KW0htVtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF90BC4CEF1;
	Tue, 16 Dec 2025 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888149;
	bh=puQp9YOQ/DJip3AOF60lovAXQC9bAoTss44CBIeVRMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KW0htVtXra7jhNCjy666fOJ+rfj1T6ed6Al2UY/zTnRVnhA02i5mVGTQS7gTFHJDu
	 +xyoqWFa5Bms71ls6ilRRQwGh1nc48zrui8CaJLp4Ixb5vNFUvOqqfqUiEjFl3QeYc
	 +PtZmLTJbeYRA2GZMiMchhJKGJFy8P2BhOSQ02XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andrea della Porta <andrea.porta@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/614] misc: rp1: Fix an error handling path in rp1_probe()
Date: Tue, 16 Dec 2025 12:13:33 +0100
Message-ID: <20251216111417.532237198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 43cd4b634ef90c4e2ff75eaeb361786fa04c8874 ]

When DT is used to get the reference of 'rp1_node', it should be released
when not needed anymore, otherwise it is leaking.

In such a case, add the missing of_node_put() call at the end of the probe,
as already done in the error handling path.

Fixes: 49d63971f963 ("misc: rp1: RaspberryPi RP1 misc driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrea della Porta <andrea.porta@suse.com>
Link: https://patch.msgid.link/9bc1206de787fa86384f3e5ba0a8027947bc00ff.1762585959.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/rp1/rp1_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/rp1/rp1_pci.c b/drivers/misc/rp1/rp1_pci.c
index 803832006ec87..a342bcc6164bb 100644
--- a/drivers/misc/rp1/rp1_pci.c
+++ b/drivers/misc/rp1/rp1_pci.c
@@ -289,6 +289,9 @@ static int rp1_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_unload_overlay;
 	}
 
+	if (skip_ovl)
+		of_node_put(rp1_node);
+
 	return 0;
 
 err_unload_overlay:
-- 
2.51.0



