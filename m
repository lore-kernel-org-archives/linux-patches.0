Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14BD3B05BC;
	Sat, 17 Oct 2026 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256233; cv=none; b=Q8wK2C/Z/S3+FGKIlvOFb5HM1gtK/5b7GC8LGF44Pg1eGy3lP8RvbOu0rAzTLz9VfL9LQ9YZ5xEWWgLwjz+v5tYIshfD4Z0/+PbojtN5udxqWRlC8fFk5ysiKow7s/KZkFs6froj9ggszes35b6w/cvOAZXPLYibwj3C0sNskQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256233; c=relaxed/simple;
	bh=Dls0lHcYp7vTCGTauLmxCUGBFEJKsfTNhjmQuY1EcKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkF0LOroiOG6krHWVo9LRVo5+7UIo5HjpdRfCiO07WQIlcx1YLy58RyMZvQCZm/8OJVY0Wi54Wqk8uUi/JMafARbxZTf7sXQD3FWTigM1Es3d3c9uZsfQAwm4T5/e9l5ZJHJvCjtkRQfKTZS/4esKQH6h6q1CSZQsDbAUKqGRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmmnnkYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmmnnkYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530501F000C4;
	Sat, 17 Oct 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256231;
	bh=+dOqr8RyL8cPofezKqSPBlpbdikMiflcaKVbxzFQoGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmmnnkYiBQI+3wfmfipjpd96kPm7yCKE6nmrHXTl5HmSz45v3tMuwuiYZQY6YTIrV
	 UohHf/lh9E1eb0U26eWck/IbKNgUsDtlU3W5haSWLclYPCiamwgfZTyUHgBr81Xi+B
	 gdIFNsoS0y5eIBiUW3ljwLlsG1LqRKoR3SDzePvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 0169/1674] of/overlay: only treat a positive changeset id as registered
Date: Sat, 17 Oct 2026 17:40:41 +0200
Message-ID: <20261017160435.496356974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -861,7 +861,8 @@ static void free_overlay_changeset(struc
 	if (ovcs->cset.entries.next)
 		of_changeset_destroy(&ovcs->cset);
 
-	if (ovcs->id) {
+	/* a failed idr_alloc() leaves its negative error in ovcs->id */
+	if (ovcs->id > 0) {
 		idr_remove(&ovcs_idr, ovcs->id);
 		list_del(&ovcs->ovcs_list);
 		ovcs->id = 0;


