Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9761113A26F;
	Tue, 27 Feb 2024 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042986; cv=none; b=BI0xTQaV/jsUzD1Ma2eATY28ZRSubI5fZEKndTlZK+zinZh9X1Ky8s8hO0RGplH4pufkIL/YVPuIiMRFHWl+5mRdJudKKDAD2hpj8F1DbdGQvpzFZ5/1sjWuVySVuevZumQn0VjjZYdwpsJdfEzay7PBeWJs9G1J+C5B+wOj9BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042986; c=relaxed/simple;
	bh=tSbe6CMid/a1yUT7uylKTwt+kqVx4ujcdp6ai2ZBKkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUalz307FKgNX21R2hOwFTllHOQ7DDznL/CGVRVQil41HxSJvOF1OkIwDBJPSF3mzniuXdJva3xI49/7Ef3ROhfNQj9idI1tVyHwR7WrSR+V8IvaKdUJzKhqBsmLSxSXsdL/Zyn7y1Aoo/oAtJNs8pSESrlAn+rUc71wWfocT0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCvxANtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCvxANtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FBBC433C7;
	Tue, 27 Feb 2024 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042986;
	bh=tSbe6CMid/a1yUT7uylKTwt+kqVx4ujcdp6ai2ZBKkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCvxANtJyJiPMNa0kGPlkWlc3UZKNvWukaGdVd5OOiyzVRu75IkXUUpUFzFVBK8sa
	 gCGun1CU7iIQW/VKS/K0xmBxydsn4dllMbaMyumrQzmYrtFIoW0UipULUAel8nkoNg
	 J5I6riU2F/AY/jFw6FQN1vLGhsgfdCysGJh/vvqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/245] ACPI: resource: Skip IRQ override on ASUS ExpertBook B1502CBA
Date: Tue, 27 Feb 2024 14:26:21 +0100
Message-ID: <20240227131621.462050509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 05cda427126f30ce3fc8ffd82fd6f5196398d502 ]

Like the ASUS ExpertBook B2502CBA and various ASUS Vivobook laptops, the
ASUS ExpertBook B1502CBA has an ACPI DSDT table that describes IRQ 1 as
ActiveLow while the kernel overrides it to Edge_High.

    $ sudo dmesg | grep DMI
    DMI: ASUSTeK COMPUTER INC. ASUS EXPERTBOOK B1502CBA_B1502CBA/B1502CBA, BIOS B1502CBA.300 01/18/2023
    $ grep -A 40 PS2K dsdt.dsl | grep IRQ -A 1
                    IRQ (Level, ActiveLow, Exclusive, )
                        {1}

This prevents the keyboard from working. To fix this issue, add this laptop
to the skip_override_table so that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217323
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 6c5873f552e5e..a364cb07c5578 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -435,6 +435,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B1502CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B1502CBA"),
+		},
+	},
 	{
 		.ident = "Asus ExpertBook B2402CBA",
 		.matches = {
-- 
2.43.0



