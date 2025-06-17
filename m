Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9202ECEAD;
	Tue, 17 Jun 2025 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175432; cv=none; b=beIBaByKvL5YtODy/pQ3LAA6d0RZ90AmnY4+BGraqOGnvv4xIujidsxqGMZVbjx/wWdvC9qd5gQuIsIRYBLwxO8TFBR84kBJQ28Sjc7MfYN83nSdAHP9/IWnNjE9LicfH5gdkfwR84b+/PBklXmMehowxbsajQfneeOTU9S7O34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175432; c=relaxed/simple;
	bh=UkjrNNGXWMBvmGVTO1NjnHho/182TmYx9KFTYQJvPys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehs3v0xBa4U6jBpXBoN3wiBka4KPT1t+i785GwuMqzCqOxALkB3BE8fBej1SU/wlGIbkobDZwho8+XVN8/X/ZqJm1u9WLZxg2duSm1j8JPrrs7P47ikOZg5Hg5+6nT36ZnN5HZLTV/D3cU5fbmNVi8p5xPvYCsPKQVbM+vBt+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9g7U280; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9g7U280"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D0BC4CEE3;
	Tue, 17 Jun 2025 15:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175432;
	bh=UkjrNNGXWMBvmGVTO1NjnHho/182TmYx9KFTYQJvPys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9g7U280RBvOkD/UR5F7aSaal0/fJXR8+4Tbu7qJcU7/NNWMsIe8mNvhd/oENqYs1
	 ApvaWlU6giRbWBO2Dhv/Vqqi/vF5XDNjMdNsvJCu3e+4inZQclNJBvfLQXXr+OEdVp
	 40d2Mt9BJ3y3BbIwMSOb4zhif0AA3xbS+cw+YDzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 087/780] ACPI: platform_profile: Avoid initializing on non-ACPI platforms
Date: Tue, 17 Jun 2025 17:16:35 +0200
Message-ID: <20250617152455.057654696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit dd133162c9cff5951a692fab9811fadf46a46457 ]

The platform profile driver is loaded even on platforms that do not have
ACPI enabled. The initialization of the sysfs entries was recently moved
from platform_profile_register() to the module init call, and those
entries need acpi_kobj to be initialized which is not the case when ACPI
is disabled.

This results in the following warning:

 WARNING: CPU: 5 PID: 1 at fs/sysfs/group.c:131 internal_create_group+0xa22/0xdd8
 Modules linked in:
 CPU: 5 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.15.0-rc7-dirty #6 PREEMPT
 Tainted: [W]=WARN
 Hardware name: riscv-virtio,qemu (DT)
 epc : internal_create_group+0xa22/0xdd8
  ra : internal_create_group+0xa22/0xdd8

 Call Trace:

 internal_create_group+0xa22/0xdd8
 sysfs_create_group+0x22/0x2e
 platform_profile_init+0x74/0xb2
 do_one_initcall+0x198/0xa9e
 kernel_init_freeable+0x6d8/0x780
 kernel_init+0x28/0x24c
 ret_from_fork+0xe/0x18

Fix this by checking if ACPI is enabled before trying to create sysfs
entries.

Fixes: 77be5cacb2c2 ("ACPI: platform_profile: Create class for ACPI platform profile")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20250522141410.31315-1-alexghiti@rivosinc.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/platform_profile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/platform_profile.c b/drivers/acpi/platform_profile.c
index ffbfd32f4cf1b..b43f4459a4f61 100644
--- a/drivers/acpi/platform_profile.c
+++ b/drivers/acpi/platform_profile.c
@@ -688,6 +688,9 @@ static int __init platform_profile_init(void)
 {
 	int err;
 
+	if (acpi_disabled)
+		return -EOPNOTSUPP;
+
 	err = class_register(&platform_profile_class);
 	if (err)
 		return err;
-- 
2.39.5



