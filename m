Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B19475;
	Wed,  2 Oct 2024 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880337; cv=none; b=Dryw8cmcTznP65bqYcUC+a3AaxXFCXG27lAU9X/NYufQFOfj9sZFAG3Npb2X5oN3Ru/0qAJ011U5TOvbTzV6wbbGojbBYnoBTCqaWABsRqewr5QVfyeGDgHypnoXGZp4aMXe8WPfeVZEF0Lk+mrZgAASfzEOfK+w86IAOl4LcZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880337; c=relaxed/simple;
	bh=2UkzB7+KEUTWd5SBLfQp8A4Yt1nrvGTecP6PMzNjrQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq68NCNL1VGBH+Xd+Y12jt0zOuEhJWbOyV+JGfCZaE0Kf664b1EgH+PFlbPPvCRKIhwoYgT9MG5nLn431tfnY7vvzwlNBUHVTfMnkssdIzAcOAomeH78BiNA1ZqhsRCVEn0nkRMcXxoA6kVfBNfnMeUR+y8PrQHH9ziiyb5Oqkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFUYVgN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFUYVgN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6837C4CEC2;
	Wed,  2 Oct 2024 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880337;
	bh=2UkzB7+KEUTWd5SBLfQp8A4Yt1nrvGTecP6PMzNjrQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFUYVgN4o/irsHRheHNBLP9e4zi1cGTHw4+sM2wMge9m3B87GPL0iTgYGxke0aMiM
	 dAGxkNkVMU/huZOJ1npGz1B+ZYzvoB8qDd+S7htqnWWk+zvfgwjliLqyS628qjSYtr
	 SxOwI+ulSR8LwDVAmRtQqWwXALCfDa6VcWlRTnNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.6 424/538] ata: libata-scsi: Fix ata_msense_control() CDL page reporting
Date: Wed,  2 Oct 2024 15:01:03 +0200
Message-ID: <20241002125809.173051587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2390,7 +2390,7 @@ static unsigned int ata_msense_control(s
 	case ALL_SUB_MPAGES:
 		n = ata_msense_control_spg0(dev, buf, changeable);
 		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
-		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2A_SUB_MPAGE);
+		n += ata_msense_control_spgt2(dev, buf + n, CDL_T2B_SUB_MPAGE);
 		n += ata_msense_control_ata_feature(dev, buf + n);
 		return n;
 	default:


