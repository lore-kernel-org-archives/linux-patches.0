Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1BB140E3C;
	Thu, 11 Apr 2024 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832038; cv=none; b=eRas0434hcjP8ARVDDd6CCkiaKs6iyAFU5t0JjHOQlcRP+2VPu41GUtfUkTtU0pp5Fl5Ne1Ia7oOENEJ3kPVyKrIqW0cCyfDV/oWPrnlnDtxNa7h7JcMUSlqWQjcHkehSzoHV2x2BVI8QCMuffs56PhV/+/53yGb0ob059W9jY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832038; c=relaxed/simple;
	bh=BF7Q4n4Hic6C+DKjfpyyuM+q39+cIDfDiZB50tOIMvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhTRiR3/jZpV4NwNehybKnEqGogZ51hF6aLM+HocWxsqO9Hq4Xm9mqb5ixu8pte81lTXjZerxEORfhEv5YDvk85LUjdwIEnMzXbSAK7KdeVmDFIAq29ax96Ui/m6IrrHfjtxmmPCM34UGgCeCpL2o762ui+CmXlbBHJXnaygNDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyuk+URF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyuk+URF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5154CC433C7;
	Thu, 11 Apr 2024 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832038;
	bh=BF7Q4n4Hic6C+DKjfpyyuM+q39+cIDfDiZB50tOIMvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyuk+URF5bTB+ldBeoygV+q/KZ6fXdan4K3ZAifOL33iK/aWlPVqhbXZ173ByWvzJ
	 +GRuhSIuhsYM//chHvUxOl4o1swDx06UbZxnMHzsvIB2aS6q0q5R2H4EP76FdyK8W1
	 JmWKURXj8DiYlzicbb1CLCyC7gFfrw+EyyPQd7eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 210/294] vboxsf: Avoid an spurious warning if load_nls_xxx() fails
Date: Thu, 11 Apr 2024 11:56:13 +0200
Message-ID: <20240411095441.920222419@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit de3f64b738af57e2732b91a0774facc675b75b54 upstream.

If an load_nls_xxx() function fails a few lines above, the 'sbi->bdi_id' is
still 0.
So, in the error handling path, we will call ida_simple_remove(..., 0)
which is not allocated yet.

In order to prevent a spurious "ida_free called for id=0 which is not
allocated." message, tweak the error handling path and add a new label.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d09eaaa4e2e08206c58a1a27ca9b3e81dc168773.1698835730.git.christophe.jaillet@wanadoo.fr
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -151,7 +151,7 @@ static int vboxsf_fill_super(struct supe
 		if (!sbi->nls) {
 			vbg_err("vboxsf: Count not load '%s' nls\n", nls_name);
 			err = -EINVAL;
-			goto fail_free;
+			goto fail_destroy_idr;
 		}
 	}
 
@@ -224,6 +224,7 @@ fail_free:
 		ida_simple_remove(&vboxsf_bdi_ida, sbi->bdi_id);
 	if (sbi->nls)
 		unload_nls(sbi->nls);
+fail_destroy_idr:
 	idr_destroy(&sbi->ino_idr);
 	kfree(sbi);
 	return err;


