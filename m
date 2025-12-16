Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF24C350A02;
	Tue, 16 Dec 2025 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886194; cv=none; b=bD9GFDDJhe8ok18Kx2bVJ+jOTHKuf/oYmgEt3N7Rsycy202/tGE3cn06acF8pT+MtykEnM6eWVobj/5XxGF9EWD4ifO1E0KL2o46RGS7CFiStvvDZjP8eluU/zTUMKuGnsbDLXsH66KeUCVE0EnY0tNXIaQJDUw6L4vOeEvaxsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886194; c=relaxed/simple;
	bh=+vAqAmyRFTNRM3eQiaEhp5NudsXGtc9iRj1KFnXBBcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsJl5weYpbA+lpilSxDy8qtPXalT315cXpkqfzyALAxOfHJ+N55/hGikbbeRGvPo1YJaGqEXMHAwKeUSGl7qNIYq96zqZM5RUFBK1/kuN3sEQQkkKl7I/UCX/Xcnk4efRDkDPGXeLpHO+0YMPKJX0GKF7Xrkc9tefdUyLezMRW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=174pOnb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="174pOnb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCD5C4CEF1;
	Tue, 16 Dec 2025 11:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886193;
	bh=+vAqAmyRFTNRM3eQiaEhp5NudsXGtc9iRj1KFnXBBcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=174pOnb6Dxrdd9XfIqM2FE8ju5zzjXqeKAG0EsIeYKpVYflS/2ic/HKnww1BZLFWS
	 cWWVPLJVyUg8xCZisOV9gQ1kfHzPJDOjNlq1AJYYgywsXHiy+Jp85Z2jAkl+S09HMy
	 TaJZNIIqcPiWWOEoCc77Pv4wOsTAaQl1DbAwHtko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andrea della Porta <andrea.porta@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 366/507] misc: rp1: Fix an error handling path in rp1_probe()
Date: Tue, 16 Dec 2025 12:13:27 +0100
Message-ID: <20251216111358.718340113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



