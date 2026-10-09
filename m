Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E294F4BE43B;
	Fri,  9 Oct 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555594; cv=none; b=UwfS89bBgMWZa8/tMgbjRcs0/ngsEqsRs2FKFMczUwwyd00Y/386mtN3wHDRvFMy3fHCaZI1NVefuDKbKya6f6iN0Dy6R4bmvd9LOk66oWdqVNR1sy2LPf9gJ9Z1AuiDk+CiO5rPNb5Xj76sXxiO61p/waurSWt5mgBBntih198=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555594; c=relaxed/simple;
	bh=GAy9cDGNF+VLGe3xHFrGXWoHEbqK6zKAn0f/vqGat2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5X912rucJamwNzDddY0RTNZJMfKk8vptY1GsH7V5eXWlTRo6owjy4qkzzE5cXg6hEpw3q0KsP96vV360ikIHi1I2/Fw7tNUOmr0um2Xn9gdPs5MAR99jJz1PpavtJFLlsNR1bVtmk24inzXrb5Zr2mUeAGuYJV3QLP/zRvxiew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3T/6INg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3T/6INg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9521F000FF;
	Fri,  9 Oct 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555588;
	bh=vAYfZE+yXdqaPgEOJasJCgh+8eIrQYR/kxvuhaOWjjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3T/6INgyKTDXoxUt4QshzqZiIgctQT3hE61UyA6BjYoElIx+0WZpMvjpLOUHLEl9
	 TfDB6AzAKmYkxcX/C5xE0+xbsM21alUaCe+u1cdoJXjemRtJdxk7Y/owO2swrsVNaS
	 w5PGjBvg5BS1i4t4yp6Nt5Av1oJkutWSF2nMtpSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 033/428] of/overlay: only treat a positive changeset id as registered
Date: Fri,  9 Oct 2026 16:06:10 +0200
Message-ID: <20261009140946.811952991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 44081d708b5b885487bac792db78324b7b4c267d upstream.

of_overlay_fdt_apply() stores the idr_alloc() return value in
ovcs->id before checking it. On failure the stored id is negative,
free_overlay_changeset()'s "if (ovcs->id)" check passes, idr_remove()
is called with a negative id and list_del() runs on ovcs->ovcs_list,
which is not initialized until after the id allocation. An allocation
failure at that point dereferences NULL.

Make free_overlay_changeset() treat only a strict-positive id as
registered. The rest of the function already copes with a
partially-initialized ovcs, so the error path stays a plain
goto err_free_ovcs.

Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Cc: stable@vger.kernel.org
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-5-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/overlay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -864,7 +864,8 @@ static void free_overlay_changeset(struc
 	if (ovcs->cset.entries.next)
 		of_changeset_destroy(&ovcs->cset);
 
-	if (ovcs->id) {
+	/* a failed idr_alloc() leaves its negative error in ovcs->id */
+	if (ovcs->id > 0) {
 		idr_remove(&ovcs_idr, ovcs->id);
 		list_del(&ovcs->ovcs_list);
 		ovcs->id = 0;


