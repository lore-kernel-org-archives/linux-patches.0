Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9712D32C94F;
	Fri, 17 Oct 2025 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715904; cv=none; b=gUpicvM9mwuOO+ykj2CIElsiLsPIujhwFEx4E3C4cyULaO4+4ZZgnHYX9ydYYWqHUZI3puFNqNooEEtC5WNJVAZDuCM9bYg1wYveIB7Ji+lO6oeXg0cNZBR+XPA+9QOKYkEDwoWhwJsxM8BGFS/49RVQN3mD4FzS1lxOKHGAOSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715904; c=relaxed/simple;
	bh=HHQEaKYHpKTAYg1y8c7eZNEdauq/GLGvLWXiYbuy/mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHOcracitYftbNEyifrNYcltCoJa3OZCr1nKHC5nnXSnvpqNOb2ZF9XGK8jsCvnUumsuvkBmIFFltozkjpwC+ZpVi65tiLoKfkXwcqcCyYWQnMT90KCLWVJsgYeiwhdEez9vhOwLVwTN52xFox8f4fRAFl7y7CFW63fzuU/D/rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6PCBqfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6PCBqfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AC5C4CEE7;
	Fri, 17 Oct 2025 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715904;
	bh=HHQEaKYHpKTAYg1y8c7eZNEdauq/GLGvLWXiYbuy/mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6PCBqfMsH3fK2basBh4Yty9yOF96BhVzp8N5kfMFDVMhpqTNuwopu26euDr3Suwe
	 8vp4L8y4ujxOE18iBbxwaPVrkjWUqvihgXH7I6G0hi0hTVLlnSz3zkhM+JWQZ5YPqQ
	 24g674be338N3dUttsVwD/DVehEHb7v8KXjoxl6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH 6.17 347/371] ACPICA: Allow to skip Global Lock initialization
Date: Fri, 17 Oct 2025 16:55:22 +0200
Message-ID: <20251017145214.634151041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit feb8ae81b2378b75a99c81d315602ac8918ed382 upstream.

Introduce acpi_gbl_use_global_lock, which allows to skip the Global Lock
initialization. This is useful for systems without Global Lock (such as
loong_arch), so as to avoid error messages during boot phase:

 ACPI Error: Could not enable global_lock event (20240827/evxfevnt-182)
 ACPI Error: No response from Global Lock hardware, disabling lock (20240827/evglock-59)

Link: https://github.com/acpica/acpica/commit/463cb0fe
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/evglock.c |    4 ++++
 include/acpi/acpixf.h         |    6 ++++++
 2 files changed, 10 insertions(+)

--- a/drivers/acpi/acpica/evglock.c
+++ b/drivers/acpi/acpica/evglock.c
@@ -42,6 +42,10 @@ acpi_status acpi_ev_init_global_lock_han
 		return_ACPI_STATUS(AE_OK);
 	}
 
+	if (!acpi_gbl_use_global_lock) {
+		return_ACPI_STATUS(AE_OK);
+	}
+
 	/* Attempt installation of the global lock handler */
 
 	status = acpi_install_fixed_event_handler(ACPI_EVENT_GLOBAL,
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -214,6 +214,12 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data,
 ACPI_INIT_GLOBAL(u8, acpi_gbl_reduced_hardware, FALSE);
 
 /*
+ * ACPI Global Lock is mainly used for systems with SMM, so no-SMM systems
+ * (such as loong_arch) may not have and not use Global Lock.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use_global_lock, TRUE);
+
+/*
  * Maximum timeout for While() loop iterations before forced method abort.
  * This mechanism is intended to prevent infinite loops during interpreter
  * execution within a host kernel.


