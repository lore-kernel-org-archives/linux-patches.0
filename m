Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7AF4D597B;
	Fri,  9 Oct 2026 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555364; cv=none; b=BdY1hTHPNeEh19yXVbWXiO5rtgBn+uo4m8f+UX9hD5DYIKt4q4o9Whviebo5YRYYzGvWAdwXUVjMH9ifISvDp2qG6FFTXbHe/gv7OajTYIN+BKGPvVxj5OemECr3ldZWo10kMf4QStq505Qks7KjyIPL+pCa+rWSIp+jAsTQmp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555364; c=relaxed/simple;
	bh=eVB1KXh3O02aaa9WpSx9CAyPBL6NrTd3kD7ZXHXOQLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLjDAk8o2YKdGtTCg/aAB0mrRYW7AN8vNuPQSGsgHHvGbbN3Of691Io4ooko/uP5BeOYDxf/W/9B4ygqXsgeS6R0lQu1BVCXlqtXA7KMPL7arCdhq5oYuHzR9DIan0wLwv6xnUXJf788BaJhmXDjwwZiEo144h21hi+5AL+SkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCC3GBBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCC3GBBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F94A1F00893;
	Fri,  9 Oct 2026 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555359;
	bh=53Lp0TxrdrdR7S5mPwKKcPEiH8OpqYu4SrWGSTW6cHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCC3GBBZbWTpOdmJO7/L7XIQOGl0OPCy982YszEEInmFUpTABxlm2Q1kKV6ojSu7U
	 fz/5yI8t9YbuxhRcWr2uIxezIEXdVRXT+g77eVyF2vdxBwfB+wuazTHxyczjVBoyLL
	 /ymtQJSY1YFrw3YA0RJXhZO5IvTp73TxGBdJCwns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 031/403] of/overlay: only treat a positive changeset id as registered
Date: Fri,  9 Oct 2026 16:06:32 +0200
Message-ID: <20261009140952.841453714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


