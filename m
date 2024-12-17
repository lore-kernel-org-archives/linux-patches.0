Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28DB1F4735;
	Tue, 17 Dec 2024 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455375; cv=none; b=IgQkhRVGk3aL+CsJlrrd42gP2XXmvyqxLwab5KPQ0hnH5GHvKXqcV2haJu4ldMkT/WIkUr1S97HI5JRjDP860SduxzEiXu7S5g/s0sEXG+ckRoHYJ26tkmtsbZopMeeFldxUOb6Bx4xFQPoaVPijGGwo0Irk00Ur0p6pO2/w0R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455375; c=relaxed/simple;
	bh=ReG75ygnHQkDyCF3DuJDwCNva0VU9aYF9HAMrSFZxcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqN5Ag/Jjg24AE9u+w81EWPJXwfBF/QGIVoizpzQ9tX11S0HqYscZAr5XmQior+0bT7Zng04IqtIQ6w+1HnCVIcapjsBF2Lo1FYhuAMjCpfpwe9wWoNcXbqERVsksmPM2QQuf6yr2YUh5P/FUdlhjFBtRgxKsm9SV5k6pVv69J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsRdlWKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsRdlWKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC83C4CED3;
	Tue, 17 Dec 2024 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455375;
	bh=ReG75ygnHQkDyCF3DuJDwCNva0VU9aYF9HAMrSFZxcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsRdlWKRdqB6FakKcNqHvuN8D8bLEYhMFvMXhw3ZP0Yg6b2Pg1b3RSTY1vnKpNGi9
	 U5haxSXIskjHHiROJP//eTd7Qva8hVpcoFvl/efLx+oEjbZvQZpf+XcbKQCcpkkt/5
	 ecNFdLkiPUi1a9byllOHup7gVeuhMEdOWyN3iLRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.4 02/24] ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()
Date: Tue, 17 Dec 2024 18:07:00 +0100
Message-ID: <20241217170519.109248253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


