Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544FF13DBA0;
	Sun,  7 Jun 2026 10:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828008; cv=none; b=Yk5VDttJyeg+jcb+RDK/2vFmn2tcX158WI6TOE8Y/j2CoOQKA82+2brTK2SOXa4Me3etSWNGYMqIvwYAbXTieFBsX3OnjuSaE9zDD/oG+2t/zpRQfS5sjSUnjrMQkL2JJ4M0LT81QeT45clxu3dw/DlG6k3DVCblvkNks18pUrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828008; c=relaxed/simple;
	bh=H/cGQHagusrPBRF0aetmT0GJXmdM0DWWATRpv+WoGhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2J7AWcXwA95siH0hQ9dRoGSY1xrsPA5Q/mZEWFHpS2DsF8suepef4DA9o3zgLbgv/8BoYlK5oWK0soXxjXa0wiLfFvxRKwASSyd06PhECYcGsYqKZY7UviECyz73PK2RdvT83iAT6NAxfNEN6y2Tq/JFj3vS/NO9y8ZgSLHROA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JItTJjLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JItTJjLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBA31F00893;
	Sun,  7 Jun 2026 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828007;
	bh=isPEEy4azO3imo5nTrMEhrGIl3WWqcynAJ2Q5gEeKHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JItTJjLRHPqhnD0ti+5/Pdu1//R0/iOAolOIfUIUcCObgajmiFJgImDrkLzj/0auZ
	 cxtcO1iBgu0vBK9JQ8QSoefhvmvlUQL9K53FEFCXEOPXoh2wW87FGvHtV2iyM61e+g
	 eegLTuTZlcI/k7DapASAhNREod8TmNfeDTZtpvIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 6.18 120/315] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Sun,  7 Jun 2026 11:58:27 +0200
Message-ID: <20260607095732.033568062@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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


