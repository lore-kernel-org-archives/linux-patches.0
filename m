Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC2314B7F;
	Wed,  3 Dec 2025 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777543; cv=none; b=IaDKsXCZTtBf7Y8UEd7aho/KNFhvmC0z2JP3sn+op1k8z8r5V/lmLrGlyzCaCPUHgrzaQrKSHFvFACEpGEnIxQeYhYdnuyeRG7lVPz9g4NmuPPH7EkZEiLSqgJH/YPreSqTpJz6xZqT7M7rpDc0ZwDN+guAtU24MzlB0wdVgdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777543; c=relaxed/simple;
	bh=sJc5LvIfiOqHiqq0agY81wT0MOQpuvTiIYJ46SbEh34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqkTrEbZ2R7hqkYpjYLika84QLEnccCE5bdza6rSSfecXByoYB4z6RTEN4yh1AB6JFoN3YOXrzvvq+edpVyqTP94DeNuP6KtyjAirHvUAq9O4iIN/TxL2e9R7iDvFrbAkXminK4UkbwIktLh31NJ9i9/6R4D/di+O+ZkSTLydqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcglIb2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcglIb2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D0C4CEF5;
	Wed,  3 Dec 2025 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777542;
	bh=sJc5LvIfiOqHiqq0agY81wT0MOQpuvTiIYJ46SbEh34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcglIb2/cDpSnlFzZ8v/gIevhNHVP7MQkR/5oCSkzlxWCAPl8w203xNwSq3raWmFV
	 THH0/jBhW/dLP9yKNwQycywcpL8TgbbO3kqFIN5Fk0/FGl2wW7c4qymqiWxtGkeuqG
	 97o0i6/PXdOm5SqZKJDl5MMeL8qVmJ2gvZvL1am0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/392] ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()
Date: Wed,  3 Dec 2025 16:23:42 +0100
Message-ID: <20251203152416.756322058@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 132ab74935be8..9aa7a24777e95 100644
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



