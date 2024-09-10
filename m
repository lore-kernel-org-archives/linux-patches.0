Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60F7144D1A;
	Tue, 10 Sep 2024 10:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965229; cv=none; b=WHnrMpRnN9CPLvj52aa12XEGQxjjImMdJvj9YcSs/ArYnfEQpOj1T8n0prrbtFzby4hdGVsEy6dbiGHCyMas0B+YHjWHG/a1MuAYZUVT81osz2qZVdjzxK7eDq3hjL6kE4hez6CO1+QuGh3Lx42VUOciobkrvRYkamzAIj7juGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965229; c=relaxed/simple;
	bh=ymyUwrnT/w291nFXaMi2OZtLp4BqzdyQtEDF6rVmnm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/U9UyLVs0SV8p9Yh6tl+QhKvW2Zqip/lZQVQMmbdH8aiRu9dfTaFrlsS1GKY3mWq3HcFH3a7Xz1wqKdSE4dCiJvzI/esCP2t/YQ9Q7XeefI3qdhKWYHoqZlaeET9W3FkWxvAf+KXwB2udz/Hrlm21nxNnoj+5SPcIsXLzWB4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSTPEpHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSTPEpHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0A0C4CEC3;
	Tue, 10 Sep 2024 10:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965228;
	bh=ymyUwrnT/w291nFXaMi2OZtLp4BqzdyQtEDF6rVmnm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSTPEpHJPYhFGmeWJNwWDpBzmRA8wkLoEjrhc5RB+IkeFpernZnEDxNBgXpYhBoW4
	 ++vUnQmB4NW9Ig4W+ydvveDhah93tS/zC5z/LAHl7TSao8n7qcrJqrSzVBj+Hj8vW7
	 kX4TDu44WqAAYkrykzSilVBmHiPRbtlIWHWSgaAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/186] of/irq: Prevent device address out-of-bounds read in interrupt map walk
Date: Tue, 10 Sep 2024 11:34:08 +0200
Message-ID: <20240910092600.889396601@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit b739dffa5d570b411d4bdf4bb9b8dfd6b7d72305 ]

When of_irq_parse_raw() is invoked with a device address smaller than
the interrupt parent node (from #address-cells property), KASAN detects
the following out-of-bounds read when populating the initial match table
(dyndbg="func of_irq_parse_* +p"):

  OF: of_irq_parse_one: dev=/soc@0/picasso/watchdog, index=0
  OF:  parent=/soc@0/pci@878000000000/gpio0@17,0, intsize=2
  OF:  intspec=4
  OF: of_irq_parse_raw: ipar=/soc@0/pci@878000000000/gpio0@17,0, size=2
  OF:  -> addrsize=3
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in of_irq_parse_raw+0x2b8/0x8d0
  Read of size 4 at addr ffffff81beca5608 by task bash/764

  CPU: 1 PID: 764 Comm: bash Tainted: G           O       6.1.67-484c613561-nokia_sm_arm64 #1
  Hardware name: Unknown Unknown Product/Unknown Product, BIOS 2023.01-12.24.03-dirty 01/01/2023
  Call trace:
   dump_backtrace+0xdc/0x130
   show_stack+0x1c/0x30
   dump_stack_lvl+0x6c/0x84
   print_report+0x150/0x448
   kasan_report+0x98/0x140
   __asan_load4+0x78/0xa0
   of_irq_parse_raw+0x2b8/0x8d0
   of_irq_parse_one+0x24c/0x270
   parse_interrupts+0xc0/0x120
   of_fwnode_add_links+0x100/0x2d0
   fw_devlink_parse_fwtree+0x64/0xc0
   device_add+0xb38/0xc30
   of_device_add+0x64/0x90
   of_platform_device_create_pdata+0xd0/0x170
   of_platform_bus_create+0x244/0x600
   of_platform_notify+0x1b0/0x254
   blocking_notifier_call_chain+0x9c/0xd0
   __of_changeset_entry_notify+0x1b8/0x230
   __of_changeset_apply_notify+0x54/0xe4
   of_overlay_fdt_apply+0xc04/0xd94
   ...

  The buggy address belongs to the object at ffffff81beca5600
   which belongs to the cache kmalloc-128 of size 128
  The buggy address is located 8 bytes inside of
   128-byte region [ffffff81beca5600, ffffff81beca5680)

  The buggy address belongs to the physical page:
  page:00000000230d3d03 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1beca4
  head:00000000230d3d03 order:1 compound_mapcount:0 compound_pincount:0
  flags: 0x8000000000010200(slab|head|zone=2)
  raw: 8000000000010200 0000000000000000 dead000000000122 ffffff810000c300
  raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffffff81beca5500: 04 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffffff81beca5580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffffff81beca5600: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                        ^
   ffffff81beca5680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffffff81beca5700: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
  ==================================================================
  OF:  -> got it !

Prevent the out-of-bounds read by copying the device address into a
buffer of sufficient size.

Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Link: https://lore.kernel.org/r/20240812100652.3800963-1-stefan.wiehler@nokia.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 352e14b007e7..ad0cb49e233a 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -288,7 +288,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	struct device_node *p;
 	const __be32 *addr;
 	u32 intsize;
-	int i, res;
+	int i, res, addr_len;
+	__be32 addr_buf[3] = { 0 };
 
 	pr_debug("of_irq_parse_one: dev=%pOF, index=%d\n", device, index);
 
@@ -297,13 +298,19 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 		return of_irq_parse_oldworld(device, index, out_irq);
 
 	/* Get the reg property (if any) */
-	addr = of_get_property(device, "reg", NULL);
+	addr = of_get_property(device, "reg", &addr_len);
+
+	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
+	if (addr_len > (3 * sizeof(__be32)))
+		addr_len = 3 * sizeof(__be32);
+	if (addr)
+		memcpy(addr_buf, addr, addr_len);
 
 	/* Try the new-style interrupts-extended first */
 	res = of_parse_phandle_with_args(device, "interrupts-extended",
 					"#interrupt-cells", index, out_irq);
 	if (!res)
-		return of_irq_parse_raw(addr, out_irq);
+		return of_irq_parse_raw(addr_buf, out_irq);
 
 	/* Look for the interrupt parent. */
 	p = of_irq_find_parent(device);
@@ -333,7 +340,7 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 
 
 	/* Check if there are any interrupt-map translations to process */
-	res = of_irq_parse_raw(addr, out_irq);
+	res = of_irq_parse_raw(addr_buf, out_irq);
  out:
 	of_node_put(p);
 	return res;
-- 
2.43.0



