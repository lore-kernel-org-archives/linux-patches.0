Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7A93D091A;
	Tue, 16 Jun 2026 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633352; cv=none; b=jumku8KKEHztFYR55uotfgzsWmADGHBZgN+GoF8mk9JTThrGW2G/o2Q51ZsETGU1fe0VeO90F8Dlkme+zNxDcXKxQToBYG823m2NznuQQ5Wjvdn4ltEV4pbbUCtaFdgBPyO+uuWKr4VUMNh+27crLNg+cP8/rSjuKGmEAOXslGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633352; c=relaxed/simple;
	bh=G5PNLTErvve6dsB3ovVgyOTFITsn9ska+io9FNKGuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blxgus66CLJTSAbLCiOWcNJbDZ7q9xhULbHU+yNjJ+8MLWkaGaDlkCEa8y4HMfhVPFPMu2vdwZsfOGm72/8H2wfhRjJ2A4GPPD46trViS1BX9TLrcVaC3WfFipKn7XmLzyHUwUuvDZgijFJH8pCKB1Ne8UL6ho1IL4uRqu81vDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3MYXWdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3MYXWdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048BC1F000E9;
	Tue, 16 Jun 2026 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633350;
	bh=yA/JdRNbu1EnE/nIO4LtNag8sY+9NtDTg9F/GaCBFWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3MYXWdnPMdgJwAqWEPtlF5hnZNdtHyoN1UiSvcVhvV54y2U2d4tVw+oZErFRT1Uq
	 3a/gNknyIOJO2kBNYDsjUCiWXYfW7/HndVoWVmO7HJPKpJQevs6iNbE5unos8Q58P5
	 hjrP5PJJghuTIf9BxaCFF4GZ+FOhqiJ8FDVrOCYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 5.15 063/411] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Tue, 16 Jun 2026 20:25:01 +0530
Message-ID: <20260616145103.627915895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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


