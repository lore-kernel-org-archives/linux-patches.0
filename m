Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023A212564;
	Sun,  7 Jun 2026 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828759; cv=none; b=o3bOpiWNH4q/ElKif27UmIT+5A9WFW/KZO4D5aAii3nZY7jz5ha3XYyWWQntXpUFuA7jRI0f/0pNl5glYKPJ4txZGiwFaf19Ad/eMeQamF4/JREKQkEqN2MhVtA+tKMMdlZrRgHzvRu8V6VscF9PYpaHOBjWAfl5x4jI/qkj/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828759; c=relaxed/simple;
	bh=F2PQ7SRML4egY9v1teQGMsaipWQ8lIC5M0guJ7Jmseg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYJvRHWUi588uCK2F7SoDsAaegKMJvVLR+CpBMbxwEogWtYb1jwXsR46YsbAmTePGvcmrU5NH3b7x5oRlJ617KDSpCnrnN827dytjLixd9tnROtfBnLPdOyzvEgnvkSNE/bC562aSDD2TiX78BaZGyLHTKLbRfYnLBRxb1PMvSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuhELuvp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuhELuvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20751F00893;
	Sun,  7 Jun 2026 10:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828758;
	bh=i2fQr/RuZBgGOlvHIrAsBb8Npkv1bG/lxiPWZRhzfs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuhELuvp2TM2lfbzYPhyi8jAOIfVuFKHzdHDJv+wE5mKL5RjWrvcvF3oeBXehPMLP
	 eZZeW7hlrQkD2vPwRhYRBbCL4npOtlldI7AS56FkUUWY+ao/20sEmLln7Lm3nhm7bc
	 6sO4rtG2k7cm/oNM2raJ4QcFjeg/6tPzPD4HABvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 6.12 140/307] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Sun,  7 Jun 2026 11:58:57 +0200
Message-ID: <20260607095732.872941711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 974820a59efde7c1a7e1260bcfe9bb81f833cc9f upstream.

If hpfs_map_dnode_bitmap fails, the code would call hpfs_brelse4 on
uninitialized quad buffer head, causing a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hpfs/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -372,8 +372,8 @@ int hpfs_check_free_dnodes(struct super_
 				return 0;
 			}
 		}
+		hpfs_brelse4(&qbh);
 	}
-	hpfs_brelse4(&qbh);
 	i = 0;
 	if (hpfs_sb(s)->sb_c_bitmap != -1) {
 		bmp = hpfs_map_bitmap(s, b, &qbh, "chkdn1");


