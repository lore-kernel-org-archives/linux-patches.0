Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D891D078B;
	Wed,  2 Oct 2024 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876808; cv=none; b=iBksQmZAC+w9qbmKXLQW81xtkcKR1tB5rR9K0Pz2yq93U12IxgUxy1Q+HrvWixo7JPJENC0Mn2jH9g+MieUmwVY+5MxKG/oFjeJHunfp2sgwUahgykCk9r6Jw/m54vQtG2cgB8ypfvFyPXQ25uivAXelQZlnI/7TJM3xP9Fn5lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876808; c=relaxed/simple;
	bh=WQ2Z4uHIxY3AVOz5fGGx8wrC+42DVb1fFlzEyKEaBmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVXWNm24XHUY01J7xv32YVOtcE4YHtQsgNsRpo7U9VrmgggAhW37nOKKiS/k7L3XKcFOG577sZak4cYgXi3HZWvjZ206WLJogtz0E6zEw0nt1K8/fqtkUnl/oMcwJLZM0gd5K9ZKYgvy21PSaWmHJHKbDnTgq+kBf5HPk1O1WgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln6aNQa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln6aNQa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D0C4CECD;
	Wed,  2 Oct 2024 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876808;
	bh=WQ2Z4uHIxY3AVOz5fGGx8wrC+42DVb1fFlzEyKEaBmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ln6aNQa1jJyJsZpSg+lpl0v4Y7+BW0muPsudsFe8Mk5dcY9ZHT5BX+d6w7iP5aHX+
	 i7WqLuyGUsdi0ak1Dz3uDBByTtTxxxj4UaZslvWuFgFgQinuN017peCLTy/x1chsIk
	 E8/bbJj6MOGeGEF5xNuLbqbbIxHZVXtuA3xKynBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.11 569/695] ata: libata-scsi: Fix ata_msense_control() CDL page reporting
Date: Wed,  2 Oct 2024 14:59:27 +0200
Message-ID: <20241002125845.221479104@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 0e9a2990a93f27daa643b6fa73cfa47b128947a7 upstream.

When the user requests the ALL_SUB_MPAGES mode sense page,
ata_msense_control() adds the CDL_T2A_SUB_MPAGE twice instead of adding
the CDL_T2A_SUB_MPAGE and CDL_T2B_SUB_MPAGE pages information. Correct
the second call to ata_msense_control_spgt2() to report the
CDL_T2B_SUB_MPAGE page.

Fixes: 673b2fe6ff1d ("scsi: ata: libata-scsi: Add support for CDL pages mode sense")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2356,7 +2356,7 @@ static unsigned int ata_msense_control(s
 	case ALL_SUB_MPAGES:
 		n = ata_msense_control_spg0(dev, buf, changeable);
 		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
-		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
+		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2B_SUB_MPAGE);
 		n += ata_msense_control_ata_feature(dev, buf + n);
 		return n;
 	default:


