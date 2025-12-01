Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAA2F25F7;
	Mon,  1 Dec 2025 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588404; cv=none; b=AjVFJ68m4t5fT/0b2RmQbCWTUED8rW9I3oNUWlc06zUc55uFKtU6t/1mw8mzEJot63Yoopa5OPezz/gLzdyXlNKYryEMVq7ArLPs45xWo2ru18MD5SJWamgq0UjviErwIQrivH1WFj/gIQ6aTwPVyW1fCVmdYMEOEwKUC9ek/zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588404; c=relaxed/simple;
	bh=02bOw9rNnGtAVP3aNwNdl4Nu7cI3Rh8LgouHKGaY+08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kmw4loX0UJlY+xuDWN+z3vp9mpwgG2OVn3Ie1gkh8CQkzf4rMG7aFCRLRFA90vgjrPynuHQeDF70pyiZoeA8TrSOn34bR9DLYIXftkywpnzkq6/zRwhP9yzKxRwijjUZ+yDCKfexJBZh2vp7weUOvc191RussTSv1GhK8JDdeBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVXupTtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVXupTtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66217C116D0;
	Mon,  1 Dec 2025 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588403;
	bh=02bOw9rNnGtAVP3aNwNdl4Nu7cI3Rh8LgouHKGaY+08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVXupTtnkL1X4X3LyyavuM61smsOP4qaBRIgOEgQICl0TpUGAIzzLw8kQLnmMCpfi
	 cABLVE467EuNYA+GbmdVUpFLkMMk3KLcPxwcYSYSCdzMFzFxzOUHp/tk97MPyEzC/Q
	 yZGYuvXSX3roNYG/1VOLjDDwVDFTyg3anaXtNlQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/187] ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()
Date: Mon,  1 Dec 2025 12:22:24 +0100
Message-ID: <20251201112242.554572198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit e9dff11a7a50fcef23fe3e8314fafae6d5641826 ]

When deleting the previous walkstate operand stack
acpi_ds_call_control_method() was deleting obj_desc->Method.param_count
operands. But Method.param_count does not necessarily match
this_walk_state->num_operands, it may be either less or more.

After correcting the for loop to check `i < this_walk_state->num_operands`
the code is identical to acpi_ds_clear_operands(), so just outright
replace the code with acpi_ds_clear_operands() to fix this.

Link: https://github.com/acpica/acpica/commit/53fc0220
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 203e9ee47fdb8..998bed6e54066 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -546,14 +546,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	 * Delete the operands on the previous walkstate operand stack
 	 * (they were copied to new objects)
 	 */
-	for (i = 0; i < obj_desc->method.param_count; i++) {
-		acpi_ut_remove_reference(this_walk_state->operands[i]);
-		this_walk_state->operands[i] = NULL;
-	}
-
-	/* Clear the operand stack */
-
-	this_walk_state->num_operands = 0;
+	acpi_ds_clear_operands(this_walk_state);
 
 	ACPI_DEBUG_PRINT((ACPI_DB_DISPATCH,
 			  "**** Begin nested execution of [%4.4s] **** WalkState=%p\n",
-- 
2.51.0



