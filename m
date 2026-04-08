Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4049347517;
	Wed,  8 Apr 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671820; cv=none; b=g0mwNzqsgHw5hpIcj9aAo16AxymLmdOMaIjDsD/WFc4ohnzZQ4tnOmbOrm85LQQ98ONcisadKnWWi+MJyTUJyldzhWopNBMdvkPWsff8WS1CuuUqx5R67mWnWmsvyfckOTyvU5G1HJWpg/yvR7sBeJfDHaUwMpDzNptSFX13oUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671820; c=relaxed/simple;
	bh=YjtnsapL4pAlDElDfRO74DsDjHj2fm0ovoeEd0vpnNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gchds9pLQ9zFHqyNalcZbGyGuYB3Qyf7WZMO8RO5Ua9SArRC46Nf9f/wd3wyczSC+fqBDS5hrX6PC+p36C6w5oZPycm/6Qm6HjW5NkeGnYPTM6XlUTF0Xl+fJcKvhZtoVKMJu/8xbES2N4pCSxnXFJ7zdufmfkboe4aO+dteyKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUWRr2VI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUWRr2VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE58C19421;
	Wed,  8 Apr 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671819;
	bh=YjtnsapL4pAlDElDfRO74DsDjHj2fm0ovoeEd0vpnNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUWRr2VIG+ymfoB/PohIDruqN0me9BAPEE0R8IxJkcYqEi4nrYkwkOjwKZvbGNPsG
	 j7rfDy6Rumd15TQSaG/MCAdP3LKDFxE6l+yHAtW/r5T6qzRM46AQIzC4SjwVlgrTvM
	 dY35D0MEGdw4RumJBZZZoFS3fSERLN4Z8zCBgzw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/312] ACPI: EC: Fix EC address space handler unregistration
Date: Wed,  8 Apr 2026 19:59:56 +0200
Message-ID: <20260408175936.695176334@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a5072078dbfaa9d70130805766dfa34bbb7bf2a7 ]

When an ECDT table is present the EC address space handler gets registered
on the root node. So to unregister it properly the unregister call also
must be done on the root node.

Store the ACPI handle used for the acpi_install_address_space_handler()
call and use te same handle for the acpi_remove_address_space_handler()
call.

Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c       | 4 +++-
 drivers/acpi/internal.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 15148513b050d..cecc521e2d30f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1524,6 +1524,7 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 			return -ENODEV;
 		}
 		set_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
+		ec->address_space_handler_holder = ec->handle;
 	}
 
 	if (!device)
@@ -1575,7 +1576,8 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
 	if (test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
-		if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
+		if (ACPI_FAILURE(acpi_remove_address_space_handler(
+					ec->address_space_handler_holder,
 					ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 			pr_err("failed to remove space handler\n");
 		clear_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 219c02df9a08c..ec584442fb298 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -173,6 +173,7 @@ enum acpi_ec_event_state {
 
 struct acpi_ec {
 	acpi_handle handle;
+	acpi_handle address_space_handler_holder;
 	int gpe;
 	int irq;
 	unsigned long command_addr;
-- 
2.53.0



