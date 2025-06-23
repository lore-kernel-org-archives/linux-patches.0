Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86770246BC9;
	Mon, 23 Jun 2025 13:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685544; cv=none; b=VqQ9RDrBQ7Jp8UesL518/uhpp9FY1oqHgGnqHEgsCquMxHgv5VUNp5CPe+BsdzPXEoWKQQRE9UlVfvP1dwDSX9JZptqgHPLWEeBILT1e2I2Y0HceF4C+Lrl0GjRbeqpo1obG8P2VNCxjEZTRx143dyYrnazuIVJ306vbXTKB2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685544; c=relaxed/simple;
	bh=e1gSudKc45POidW6q/BKG5eAIPrD1KUJj1Jyk9YliOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfBJSku2RGD+/eyIMMcxkBup7yQE6mPAM5msMM6A0+vqmWgoU6TfKKjoqtCXM1uKxdAmG3S6UU4DpV3a6RCCsQ3z1XuIdKFoD3kzaxYyqKbCXvVHSV6zqrysjiCe1mfEOT+TOf0NMUZ8mINClHxRfQRCSS9ZwnkIL/hlCperhKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxWDmpCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxWDmpCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A30C4CEEA;
	Mon, 23 Jun 2025 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685544;
	bh=e1gSudKc45POidW6q/BKG5eAIPrD1KUJj1Jyk9YliOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxWDmpCQ2nwJcaDXw8e0TZJsVp8Rk3YDJWkmYmwH//gDr+tvCiebH1RTsZkx/5FAe
	 Wwg4DhhAOhqXYh/IRu6yIFdp3miIeteX2hwlskIuwlcFPHe4rgolopwDD3HAMzmMUl
	 GyCvKEPRvpNl1oCvdeSO4CA5O7MjivcKhxP5wdf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Breno Leitao <leitao@debian.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 5.4 102/222] configfs: Do not override creating attribute file failure in populate_attrs()
Date: Mon, 23 Jun 2025 15:07:17 +0200
Message-ID: <20250623130615.183047038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit f830edbae247b89228c3e09294151b21e0dc849c upstream.

populate_attrs() may override failure for creating attribute files
by success for creating subsequent bin attribute files, and have
wrong return value.

Fix by creating bin attribute files under successfully creating
attribute files.

Fixes: 03607ace807b ("configfs: implement binary attributes")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250507-fix_configfs-v3-2-fe2d96de8dc4@quicinc.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -619,7 +619,7 @@ static int populate_attrs(struct config_
 				break;
 		}
 	}
-	if (t->ct_bin_attrs) {
+	if (!error && t->ct_bin_attrs) {
 		for (i = 0; (bin_attr = t->ct_bin_attrs[i]) != NULL; i++) {
 			error = configfs_create_bin_file(item, bin_attr);
 			if (error)


