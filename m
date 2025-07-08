Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C08BE46;
	Tue,  8 Jul 2025 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993705; cv=none; b=DBnDv31Re1Z0EGSpvvFNz3nB2slC1n31gWfzWkziVYxz5U+QTvcE7rJnTscx2rtR0Czv2TavL6a8BU008H6QLOSJ+OZ31G36FK5HhzQUhIFdPuogINoAca6/gykys26joGZxSyBJ/MeBySpaM5BSXpb7OpnH9xbfxh2Lyz10sG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993705; c=relaxed/simple;
	bh=vYKU5/F3QcilwL5E0uxwh9As+pWoCuML8CYM8jjC70k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovD1r3LlB+zOdU5KCLsAEo0McB2q91xTpEqA6CQR9NAR8DHm14UHOLmoKvzJ4qG475Rt4CXFKIP7cN1157yRKgpDcjCvKL/x3hldqx5/2wsS6DPXyjKtdCZVIxH3V3/+Xx+H/Jc8RGKpc3pMNi/WloQc0xVHJjNLEU76TCMER5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKhg4ny/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKhg4ny/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C304C4CEED;
	Tue,  8 Jul 2025 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993704;
	bh=vYKU5/F3QcilwL5E0uxwh9As+pWoCuML8CYM8jjC70k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKhg4ny/kbouroqCccV0Jn8GheP8+AVH3sURfd938Za5H+YMOSQhgpRXgYB3QbAiv
	 rK1ARDd2EdlkngoV+cg1w9PLXNBI2huAkUSwWiqC7IfsTGdJJeg0EGcBv2Emlz55CK
	 ttkmmE4hxV1MZZ8JWydmgL1GnfRCjwTiYRHGZDOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Williams <peter@newton.cx>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/178] ACPICA: Refuse to evaluate a method if arguments are missing
Date: Tue,  8 Jul 2025 18:22:55 +0200
Message-ID: <20250708162240.156255931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6fcab2791543924d438e7fa49276d0998b0a069f ]

As reported in [1], a platform firmware update that increased the number
of method parameters and forgot to update a least one of its callers,
caused ACPICA to crash due to use-after-free.

Since this a result of a clear AML issue that arguably cannot be fixed
up by the interpreter (it cannot produce missing data out of thin air),
address it by making ACPICA refuse to evaluate a method if the caller
attempts to pass fewer arguments than expected to it.

Closes: https://github.com/acpica/acpica/issues/1027 [1]
Reported-by: Peter Williams <peter@newton.cx>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Tested-by: Hans de Goede <hansg@kernel.org> # Dell XPS 9640 with BIOS 1.12.0
Link: https://patch.msgid.link/5909446.DvuYhMxLoT@rjwysocki.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index e809c2aed78ae..a232746d150a7 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -483,6 +483,13 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 		return_ACPI_STATUS(AE_NULL_OBJECT);
 	}
 
+	if (this_walk_state->num_operands < obj_desc->method.param_count) {
+		ACPI_ERROR((AE_INFO, "Missing argument for method [%4.4s]",
+			    acpi_ut_get_node_name(method_node)));
+
+		return_ACPI_STATUS(AE_AML_UNINITIALIZED_ARG);
+	}
+
 	/* Init for new method, possibly wait on method mutex */
 
 	status =
-- 
2.39.5



