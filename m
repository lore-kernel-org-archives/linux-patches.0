Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF028E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B3DC433C8;
	Wed, 20 Sep 2023 11:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210839;
	bh=jPbofMs0LhrIdZ3RA57aronp9wGC+XBogwFrCwDEkUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/4BvG8j5BEXZRlOu7rVcpzaXZn4QQu5ziQBYlZ86IIG0zvOxwa0XnqTQa2R7RLAk
	 z9xikI6gnubacO8ZInWHUeiQ0M1Vq/6JsYXLbVEcPpJSdFl9oJlmGsHNECyy9epCSa
	 iTOXqPxsrSnHHW0GFZpr/i7IsKfou7XFzRUTrwDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/139] ACPI: x86: s2idle: Catch multiple ACPI_TYPE_PACKAGE objects
Date: Wed, 20 Sep 2023 13:29:06 +0200
Message-ID: <20230920112836.054832710@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 883cf0d4cf288313b71146ddebdf5d647b76c78b ]

If a badly constructed firmware includes multiple `ACPI_TYPE_PACKAGE`
objects while evaluating the AMD LPS0 _DSM, there will be a memory
leak.  Explicitly guard against this.

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index ec84da6cc1bff..5510657d4be81 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -112,6 +112,12 @@ static void lpi_device_get_constraints_amd(void)
 		union acpi_object *package = &out_obj->package.elements[i];
 
 		if (package->type == ACPI_TYPE_PACKAGE) {
+			if (lpi_constraints_table) {
+				acpi_handle_err(lps0_device_handle,
+						"Duplicate constraints list\n");
+				goto free_acpi_buffer;
+			}
+
 			lpi_constraints_table = kcalloc(package->package.count,
 							sizeof(*lpi_constraints_table),
 							GFP_KERNEL);
-- 
2.40.1



