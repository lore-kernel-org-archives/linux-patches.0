Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37F3E0C64;
	Mon,  4 May 2026 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904698; cv=none; b=c7Akqonn06IlReuNDMYhLg8uHqgWUCpmSLxnK8Ama1HGLbGoC2cgEFjtm4UvD3RSvqQ5FkTb6mFTLMDyOfPSytlLBchH53d5vdSsz6Z0Pnw+EpfVPL2iFzkZqGxEQHwCpH8iKz+tYoOAPc3IXzXlca9tHqMHsyer/a+nFZSQIOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904698; c=relaxed/simple;
	bh=JGN23IOLNH6Dwlhpx3bF4JaTaBnGtP5VB4CDxRtsGWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2AZfLkdvaYaL9H3YgsTyTFLuPkV8z2Ok1xncag/NlEzHCTgmaFSA3A/zaSjtCznxZ7LS9ISUdJG192noqzdJkkXXZKo1Ho0DFMmrKss52tNMrWHOsw7//PCHfSjQmGTuFL1Hi0ZJ+J+UjYOQjdQDau9pbcovh2d82KXw7GJWTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHB++M4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHB++M4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83747C2BCB8;
	Mon,  4 May 2026 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904697;
	bh=JGN23IOLNH6Dwlhpx3bF4JaTaBnGtP5VB4CDxRtsGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHB++M4RNxKBU0LyL0uULRT/Ko6EH3Fko3D1XrZaFdhglqXA5O2MID/B2OMfakEFf
	 11pC4NOofzQ3Ks2NNmtGT/LF/3QZZYV841QNIq87CWXhekzBL1GhZlRgiAin4J/CpP
	 8ulCeIb9uDwkVdW4A7lTAbuj1OPiGExrcJr19y/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 106/215] xfs: fix a resource leak in xfs_alloc_buftarg()
Date: Mon,  4 May 2026 15:52:05 +0200
Message-ID: <20260504135134.023957285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 29a7b2614357393b176ef06ba5bc3ff5afc8df69 upstream.

In the error path, call fs_put_dax() to drop the DAX
device reference.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2127,6 +2127,7 @@ xfs_alloc_buftarg(
 	return btp;
 
 error_free:
+	fs_put_dax(btp->bt_daxdev, mp);
 	kfree(btp);
 	return NULL;
 }


