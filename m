Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7242FE042;
	Tue, 31 Mar 2026 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976641; cv=none; b=jTAMF74vibVb3qfZnebpiVciY2GaKVxqdu3deklSon874Q92VWEFZiUlzXgtfjUoys4i+kJ1CIyaN5SI8xBfKKbNdFjO2IZLP50pnN1L+kx+YWJWoC1Mzzo+tsmXTxQ0hJstEH4/LKP4qOjr+YZQG+REU3h5hD1yegEbga7Gi9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976641; c=relaxed/simple;
	bh=dpybjADJqahYI969q6XKA7Co17VpodpU0eqPSZ0FFo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEmPhPHkB1LwKhyKziuFDuX/didB4PxhLacF/hdtOf5+j9u7+4h4YLmn/TDGGbdzhWKyvj1vuFc4AFXInpS7+Z/JDChUIlYhoItMBsaHpbGhxODaaz00jQezrC3/JHp/Sa/I9kBJxPDH/KNMEf6eH7ov1O8nsAdROLN6zS+IHUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl46YT3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl46YT3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7A4C19423;
	Tue, 31 Mar 2026 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976641;
	bh=dpybjADJqahYI969q6XKA7Co17VpodpU0eqPSZ0FFo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl46YT3HhPENKMO03j9Tad9xU+o2p/WIoV4TbA9CwKeE+PR/ogers5FewxDkMYaRx
	 CEkUqPXBrD2zrfnlhcaSyym5AsvVY0DB4/yyrkD3VCmWBGcT/TqTpXV3sMAmPSa90Y
	 2K2knRyPLJFIuNw7u4y2CsehoOsXl0lZv6fo7R/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/309] ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()
Date: Tue, 31 Mar 2026 18:21:07 +0200
Message-ID: <20260331161759.501834820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f6484cadbcaf26b5844b51bd7307a663dda48ef6 ]

When ec_install_handlers() returns -EPROBE_DEFER on reduced-hardware
platforms, it has already started the EC and installed the address
space handler with the struct acpi_ec pointer as handler context.
However, acpi_ec_setup() propagates the error without any cleanup.

The caller acpi_ec_add() then frees the struct acpi_ec for non-boot
instances, leaving a dangling handler context in ACPICA.

Any subsequent AML evaluation that accesses an EC OpRegion field
dispatches into acpi_ec_space_handler() with the freed pointer,
causing a use-after-free:

 BUG: KASAN: slab-use-after-free in mutex_lock (kernel/locking/mutex.c:289)
 Write of size 8 at addr ffff88800721de38 by task init/1
 Call Trace:
  <TASK>
  mutex_lock (kernel/locking/mutex.c:289)
  acpi_ec_space_handler (drivers/acpi/ec.c:1362)
  acpi_ev_address_space_dispatch (drivers/acpi/acpica/evregion.c:293)
  acpi_ex_access_region (drivers/acpi/acpica/exfldio.c:246)
  acpi_ex_field_datum_io (drivers/acpi/acpica/exfldio.c:509)
  acpi_ex_extract_from_field (drivers/acpi/acpica/exfldio.c:700)
  acpi_ex_read_data_from_field (drivers/acpi/acpica/exfield.c:327)
  acpi_ex_resolve_node_to_value (drivers/acpi/acpica/exresolv.c:392)
  </TASK>

 Allocated by task 1:
  acpi_ec_alloc (drivers/acpi/ec.c:1424)
  acpi_ec_add (drivers/acpi/ec.c:1692)

 Freed by task 1:
  kfree (mm/slub.c:6876)
  acpi_ec_add (drivers/acpi/ec.c:1751)

The bug triggers on reduced-hardware EC platforms (ec->gpe < 0)
when the GPIO IRQ provider defers probing. Once the stale handler
exists, any unprivileged sysfs read that causes AML to touch an
EC OpRegion (battery, thermal, backlight) exercises the dangling
pointer.

Fix this by calling ec_remove_handlers() in the error path of
acpi_ec_setup() before clearing first_ec. ec_remove_handlers()
checks each EC_FLAGS_* bit before acting, so it is safe to call
regardless of how far ec_install_handlers() progressed:

  -ENODEV  (handler not installed): only calls acpi_ec_stop()
  -EPROBE_DEFER (handler installed): removes handler, stops EC

Fixes: 03e9a0e05739 ("ACPI: EC: Consolidate event handler installation code")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260324165458.1337233-2-bestswngs@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7855bbf752b1e..1f4fc78a124fa 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1655,6 +1655,8 @@ static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device, bool ca
 
 	ret = ec_install_handlers(ec, device, call_reg);
 	if (ret) {
+		ec_remove_handlers(ec);
+
 		if (ec == first_ec)
 			first_ec = NULL;
 
-- 
2.53.0



