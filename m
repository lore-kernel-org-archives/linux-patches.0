Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAFD12FB12;
	Tue, 14 May 2024 10:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684223; cv=none; b=NP/mpYQjRgxoPxctUzYsSm37rvoqgjowzczgr31N2NWY+1DuQQ4GKzc8qXekfVzA26EQkAyT7AxqPb+7yiGfhy8u5gFhXTow4PHhAlR1buJf38bV/+f2AlhUrrQKDAnkVhRSb1GEplSaBj66UCOLzywl1FQwxu5XdBHeYwdl/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684223; c=relaxed/simple;
	bh=v0hT5kLsmmtM1LnIN9vVCh9r5+7NCos8OkiD6uBqVps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZgC7Fk3LU9rtgOYx1UoLXvhnAVCfNtVieulo0az5U+V5u6+E4vegel+6u39HjXZ10J3T/Huhmpr7yFgT6wy5yY0y5lJyPD0/PkSEM8BzqK+Pzgsn7WKeKO3uVK3UZIKJj6AwXgwMtnrjRXY9lJqr07VVZHwVQVNh2X7ixI8048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6xkJ148; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6xkJ148"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2DFC2BD10;
	Tue, 14 May 2024 10:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684223;
	bh=v0hT5kLsmmtM1LnIN9vVCh9r5+7NCos8OkiD6uBqVps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6xkJ148VoEaYfHSZ6FE3RX6GK5L7uz6gL7iNVYExqMHa4JoaOAvbnxW7IOwMohNr
	 s55LLopT/vSZ5LEvs1NkOPcDWhnoThBKowt4PWcLypZhdlEjbU3wk4V/JEHOATVxiA
	 48YMTcucTFMTcjTeOTuy4o/sars3Pmxk+jtV5VzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.8 311/336] misc/pvpanic-pci: register attributes via pci_driver
Date: Tue, 14 May 2024 12:18:35 +0200
Message-ID: <20240514101050.359236673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit ee59be35d7a8be7fcaa2d61fb89734ab5c25e4ee upstream.

In __pci_register_driver(), the pci core overwrites the dev_groups field of
the embedded struct device_driver with the dev_groups from the outer
struct pci_driver unconditionally.

Set dev_groups in the pci_driver to make sure it is used.

This was broken since the introduction of pvpanic-pci.

Fixes: db3a4f0abefd ("misc/pvpanic: add PCI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: ded13b9cfd59 ("PCI: Add support for dev_groups to struct pci_driver")
Link: https://lore.kernel.org/r/20240411-pvpanic-pci-dev-groups-v1-1-db8cb69f1b09@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -44,8 +44,6 @@ static struct pci_driver pvpanic_pci_dri
 	.name =         "pvpanic-pci",
 	.id_table =     pvpanic_pci_id_tbl,
 	.probe =        pvpanic_pci_probe,
-	.driver = {
-		.dev_groups = pvpanic_dev_groups,
-	},
+	.dev_groups =   pvpanic_dev_groups,
 };
 module_pci_driver(pvpanic_pci_driver);


