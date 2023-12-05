Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A396FAF;
	Tue,  5 Dec 2023 03:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9L7uhYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00F8C433C8;
	Tue,  5 Dec 2023 03:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746665;
	bh=kGJ/+iLwMamoXF196i58rfUizj0vRppOtVceG85amr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9L7uhYCVJbisSgqpKiGIrAue1N9fBRVP8N8P+C2UrJ6wxTzheVruWrYahchnwCCt
	 OfT9FUcEdV7UX6PNI0L57s+xF4IvmlhjEugnaTUPGvhMHuv1L3H7xNi16UejOA/A7t
	 mbMLoGJt8FldB1GiUP48y8rcBzYBKLgpeObP0aEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ungerer <gerg@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/134] net: dsa: mv88e6xxx: fix marvell 6350 probe crash
Date: Tue,  5 Dec 2023 12:15:58 +0900
Message-ID: <20231205031540.912575429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ungerer <gerg@kernel.org>

[ Upstream commit a524eabcd72d28425d9db242cf375d0389d74eba ]

As of commit b92143d4420f ("net: dsa: mv88e6xxx: add infrastructure for
phylink_pcs") probing of a Marvell 88e6350 switch causes a NULL pointer
de-reference like this example:

    ...
    mv88e6085 d0072004.mdio-mii:11: switch 0x3710 detected: Marvell 88E6350, revision 2
    8<--- cut here ---
    Unable to handle kernel NULL pointer dereference at virtual address 00000000 when read
    [00000000] *pgd=00000000
    Internal error: Oops: 5 [#1] ARM
    Modules linked in:
    CPU: 0 PID: 8 Comm: kworker/u2:0 Not tainted 6.7.0-rc2-dirty #26
    Hardware name: Marvell Armada 370/XP (Device Tree)
    Workqueue: events_unbound deferred_probe_work_func
    PC is at mv88e6xxx_port_setup+0x1c/0x44
    LR is at dsa_port_devlink_setup+0x74/0x154
    pc : [<c057ea24>]    lr : [<c0819598>]    psr: a0000013
    sp : c184fce0  ip : c542b8f4  fp : 00000000
    r10: 00000001  r9 : c542a540  r8 : c542bc00
    r7 : c542b838  r6 : c5244580  r5 : 00000005  r4 : c5244580
    r3 : 00000000  r2 : c542b840  r1 : 00000005  r0 : c1a02040
    ...

The Marvell 6350 switch has no SERDES interface and so has no
corresponding pcs_ops defined for it. But during probing a call is made
to mv88e6xxx_port_setup() which unconditionally expects pcs_ops to exist -
though the presence of the pcs_ops->pcs_init function is optional.

Modify code to check for pcs_ops first, before checking for and calling
pcs_ops->pcs_init. Modify checking and use of pcs_ops->pcs_teardown
which may potentially suffer the same problem.

Fixes: b92143d4420f ("net: dsa: mv88e6xxx: add infrastructure for phylink_pcs")
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6d7256ea477a1..dc7f9b99f409f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3892,7 +3892,8 @@ static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (chip->info->ops->pcs_ops->pcs_init) {
+	if (chip->info->ops->pcs_ops &&
+	    chip->info->ops->pcs_ops->pcs_init) {
 		err = chip->info->ops->pcs_ops->pcs_init(chip, port);
 		if (err)
 			return err;
@@ -3907,7 +3908,8 @@ static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
 
 	mv88e6xxx_teardown_devlink_regions_port(ds, port);
 
-	if (chip->info->ops->pcs_ops->pcs_teardown)
+	if (chip->info->ops->pcs_ops &&
+	    chip->info->ops->pcs_ops->pcs_teardown)
 		chip->info->ops->pcs_ops->pcs_teardown(chip, port);
 }
 
-- 
2.42.0



