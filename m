Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129251C689C;
	Tue, 27 Aug 2024 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769845; cv=none; b=uljJtfALP8HKpUMwMynlsDZy60SRWqNtDDlYYZyI9Ipj8r4VqdsdRvx1fDFWXmSyIgey/UghK8OGQ5S2LRaD4cbWzjesINn2v3Hog7bmLcGR5bDQQJXcyPTekBXhn6LXWto5i2I1cMMjUUKA4bI93eWwPpQFn2p2VJADI2/2GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769845; c=relaxed/simple;
	bh=o48f36JCUgH2CPvdWWUST2lPpjMUQD854P0NvV7zfKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxZn66L/yhbIE5PWGAp9frtPRmuYSTfusP69LcUtO/6FKiNN+ALOaHNKSY8rAQLN+dN33AT8hwTmUuDuJF72OFKi27T4Or8Uz8BRrA9pjk3dLpLYpwbejYqrE+UQnrHA1F7Sxguh5U2gIgKngZTMbvBrf42SL0cXdnZ+5FCrU48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxwRTPvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxwRTPvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C04C61053;
	Tue, 27 Aug 2024 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769844;
	bh=o48f36JCUgH2CPvdWWUST2lPpjMUQD854P0NvV7zfKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxwRTPvduCScsJ6r2ga1YFZAAe0N8XGtg2sNXDZJF1YpIjyO/SkcPm5KtRQXCMMRA
	 k42mXR5FO0KilIph2XfpF4PYe6f5lSEr+mITJRhgPDuoJ7x79lLV3siAMhOseX3P2Q
	 9RLZyBpsNxsRckeQdelbRsnLZh7whKFRedKUpAO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 021/341] ACPI: EC: Evaluate _REG outside the EC scope more carefully
Date: Tue, 27 Aug 2024 16:34:12 +0200
Message-ID: <20240827143844.212712516@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 71bf41b8e913ec9fc91f0d39ab8fb320229ec604 upstream.

Commit 60fa6ae6e6d0 ("ACPI: EC: Install address space handler at the
namespace root") caused _REG methods for EC operation regions outside
the EC device scope to be evaluated which on some systems leads to the
evaluation of _REG methods in the scopes of device objects representing
devices that are not present and not functional according to the _STA
return values. Some of those device objects represent EC "alternatives"
and if _REG is evaluated for their operation regions, the platform
firmware may be confused and the platform may start to behave
incorrectly.

To avoid this problem, only evaluate _REG for EC operation regions
located in the scopes of device objects representing known-to-be-present
devices.

For this purpose, partially revert commit 60fa6ae6e6d0 and trigger the
evaluation of _REG for EC operation regions from acpi_bus_attach() for
the known-valid devices.

Fixes: 60fa6ae6e6d0 ("ACPI: EC: Install address space handler at the namespace root")
Link: https://lore.kernel.org/linux-acpi/1f76b7e2-1928-4598-8037-28a1785c2d13@redhat.com
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2298938
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2302253
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/23612351.6Emhk5qWAg@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c       |   11 +++++++++--
 drivers/acpi/internal.h |    1 +
 drivers/acpi/scan.c     |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1487,12 +1487,13 @@ static bool install_gpio_irq_event_handl
 static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 			       bool call_reg)
 {
-	acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
 	acpi_status status;
 
 	acpi_ec_start(ec, false);
 
 	if (!test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
+		acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
+
 		acpi_ec_enter_noirq(ec);
 		status = acpi_install_address_space_handler_no_reg(scope_handle,
 								   ACPI_ADR_SPACE_EC,
@@ -1506,7 +1507,7 @@ static int ec_install_handlers(struct ac
 	}
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
-		acpi_execute_reg_methods(scope_handle, ACPI_UINT32_MAX, ACPI_ADR_SPACE_EC);
+		acpi_execute_reg_methods(ec->handle, ACPI_UINT32_MAX, ACPI_ADR_SPACE_EC);
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
@@ -1721,6 +1722,12 @@ static void acpi_ec_remove(struct acpi_d
 	}
 }
 
+void acpi_ec_register_opregions(struct acpi_device *adev)
+{
+	if (first_ec && first_ec->handle != adev->handle)
+		acpi_execute_reg_methods(adev->handle, 1, ACPI_ADR_SPACE_EC);
+}
+
 static acpi_status
 ec_parse_io_ports(struct acpi_resource *resource, void *context)
 {
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -204,6 +204,7 @@ int acpi_ec_add_query_handler(struct acp
 			      acpi_handle handle, acpi_ec_query_func func,
 			      void *data);
 void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
+void acpi_ec_register_opregions(struct acpi_device *adev);
 
 #ifdef CONFIG_PM_SLEEP
 void acpi_ec_flush_work(void);
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2198,6 +2198,8 @@ static int acpi_bus_attach(struct acpi_d
 	if (device->handler)
 		goto ok;
 
+	acpi_ec_register_opregions(device);
+
 	if (!device->flags.initialized) {
 		device->flags.power_manageable =
 			device->power.states[ACPI_STATE_D0].flags.valid;


