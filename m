Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0F818658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9C1C433C9;
	Wed, 20 Sep 2023 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210246;
	bh=5UQadOcwbMrJ/Y658I907Ti6q4EzT06kqDw6rywS0m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/XmvXHTSbR1H7NLqM9vKGH0VXXMqECicc0I6TdKnMJW3nd/zYA9cG1eEmwA2QH0g
	 wYjQA3tiNt/YFnUgXSFd4MnEphacOUeC3xj/KuF6vYP4uYe0ebt6+Yg6mteqSzvAuz
	 P/hYXoA6VJNforn4sbLX/17FnE3CC+mvYUaWQn7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 019/211] ACPI: x86: s2idle: Catch multiple ACPI_TYPE_PACKAGE objects
Date: Wed, 20 Sep 2023 13:27:43 +0200
Message-ID: <20230920112846.405524189@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 60cc4605169c5..60835953ebfc4 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -113,6 +113,12 @@ static void lpi_device_get_constraints_amd(void)
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



