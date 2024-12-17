Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030221F8689;
	Tue, 17 Dec 2024 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456378; cv=none; b=BUS283c73QY7dV62P21trNRoK9OGUZhAxJWVvMmbsVckNChBfjiBG2AOxEGFozzz/cnsR1+5Zqg/oKRvkJV8PJhk7JaC10ZpgQ1ABWXHlWx5xtMJFk8yEzw8u6bCJHcA2GgtxyuBcphGztynGGv8MpaULzqDmJzgGnrp0gEekoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456378; c=relaxed/simple;
	bh=3i3jqqdzPxz6q1NGbgM/thnl5p04VRJDzSYBqLjwm/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7ljY3FpoHXn01Glz02YN33k0g7WOmnVSEPRrBVSGDVnkCuSGrVXcuoRejOA+fdFH7x84oz9SGaNh1hB13p1JkRxbvqtxuoVY8RrXxlVzsfJx7Dfj5WBMh6Pl0OdFIljCBUAhebrP9VsCJGCJoj8HN1UpLZARj1hZzQfsu7vt1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQdtIIgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQdtIIgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D440C4CED3;
	Tue, 17 Dec 2024 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456377;
	bh=3i3jqqdzPxz6q1NGbgM/thnl5p04VRJDzSYBqLjwm/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQdtIIgroRmNeGPjnXHjgdFXz9YzwCnJh0UXUmh+lKPTkJhA3GMe0nt169BNuQDuj
	 3bCPaA3b8wW7u3xniNQRwl6Rf9r4MUYHCe6wc1T/DzeGqkN4sI13Hyc+R790cp4FW9
	 2nkVUZIX0+vlbt/Zm2Wa7SvhIGgUGcrswdi4Pm3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 040/172] ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()
Date: Tue, 17 Dec 2024 18:06:36 +0100
Message-ID: <20241217170547.927977990@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 676fe1f6f74db988191dab5df3bf256908177072 upstream.

The OF node reference obtained by of_parse_phandle_with_args() is not
released on early return. Add a of_node_put() call before returning.

Fixes: 8996b89d6bc9 ("ata: add platform driver for Calxeda AHCI controller")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_highbank.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -348,6 +348,7 @@ static int highbank_initialize_phys(stru
 			phy_nodes[phy] = phy_data.np;
 			cphy_base[phy] = of_iomap(phy_nodes[phy], 0);
 			if (cphy_base[phy] == NULL) {
+				of_node_put(phy_data.np);
 				return 0;
 			}
 			phy_count += 1;


