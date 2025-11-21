Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551C334C81E;
	Fri, 21 Nov 2025 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732339; cv=none; b=QVyoxbbTQsjVtTOQNoYPEq/pZXd1tCy97bn72AE4QjOIAC2k+r472+YwOcJplm7gVyYA1keFsGW0MLjX8SRhHG8pSYXeMssWI328l0Y/48nUuFGOVol/0waZvfEY9fUelZFG9R3Xm5DjuMxcd5K1SmEJNC3w5XyRy7gGIHADXgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732339; c=relaxed/simple;
	bh=kTss9etsvntzflaeI+nh+jkgngEifPGS8/ByzebRVpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4wLr/KmHkhznWsEfVFzz8/Urh9gaU49uWNQtUFygwffVewqlMD8Tk49HFn+BZ30fn0IjzSjurcEXMrPqbNWgmWJs+DEPDmDfQ10q0lBzTDj6UpB6arEt7sxVpIaoYpoKmcrIp457VjfVpleU8sj2cJR1w0RHjvp6WkWPcJZ5gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amSXeXMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amSXeXMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A776C4CEF1;
	Fri, 21 Nov 2025 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732338;
	bh=kTss9etsvntzflaeI+nh+jkgngEifPGS8/ByzebRVpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amSXeXMWxckI8hrf6+8VUGz1rakMhCSMcWeOdxFXnqLf2MgvIbbHn/XAbTAjl+kgA
	 K/1bViYVJRLlPyiDiaZnUO/TsfVCDGnFhN3lOFW0OLgb8VfB18sjgRC53pzG5ibsB7
	 wkZ5nDCiJ84PJBAyNPbh9QTYSl4KV9u0Mi4yYv/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/529] ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()
Date: Fri, 21 Nov 2025 14:06:25 +0100
Message-ID: <20251121130234.090295876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a232746d150a7..dc53a5d700671 100644
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



