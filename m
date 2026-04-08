Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6E37F8C2;
	Wed,  8 Apr 2026 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671827; cv=none; b=MAP6kS3YdArmYnxSeNcBcrDqlz+QRw7dIhdk56IM6FCMagf8M/uieFyy+jApQfUjOB9WJLfzx1N10H3nXKeA+t6iAsCvFizxl4HQba5XQkFeib+YCyaZgIqvx2WywHD0cQkY00TBnO2lRSrJXydfnbJjhp2oDu2n1Csxge+6DWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671827; c=relaxed/simple;
	bh=Zv0XoKmJ+ctr6mSdXhQcR5zOhrKqglvg9ZIGkzUVDRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXBtawVRxzZ4bBvPlF4Tkx1kzUH3XrY6Oylt+b2ZNy5XmVsiRk2n1LnCl7tE14jWsvA8jYiXuEJdB1SVJsiqPh/bhnOumARG8bVz7yZ6mvH3L501nnUmIxIWpPje+PIO9AdPMtbHlIvdQ3LnQhKT4/VgQDBVxJ2yua+MymMEqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYDBhaxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYDBhaxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AFFC19421;
	Wed,  8 Apr 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671827;
	bh=Zv0XoKmJ+ctr6mSdXhQcR5zOhrKqglvg9ZIGkzUVDRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYDBhaxuwwD86W6LYKbSQqA94Wd/oFHTJKpH9nWHNasuHh2CstQkBE1mF1BsbSS3S
	 5tyYULs8oJ7TBxTpOvN6VNp1AYqCDuIAeXfWeSlbsgP+C8NHlLTL5XH3PLNjXfz2Tz
	 PX8rTqi1OwifnY8jido1424PYYB3UJ9NrUGJFV4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/312] ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()
Date: Wed,  8 Apr 2026 19:59:59 +0200
Message-ID: <20260408175936.807683872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3583ce4980c32..230fe6463cc1f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1634,6 +1634,8 @@ static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device, bool ca
 
 	ret = ec_install_handlers(ec, device, call_reg);
 	if (ret) {
+		ec_remove_handlers(ec);
+
 		if (ec == first_ec)
 			first_ec = NULL;
 
-- 
2.53.0



