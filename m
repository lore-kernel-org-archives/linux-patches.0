Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1639013D516;
	Tue, 14 May 2024 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686883; cv=none; b=A+cOMYE3o0fW7S1vVAdK31n5+aUPuVVfrYuqinh5Xvz35jdLr3c3Hofs4Oz8yo2VCGfUqEnrK4LD0SiYupk/UNuFVRi1kQEFkC09LQcneTsGfHFG2BHWzYOwKgU6f/0YmVv2P2MxOEnAzTz22666CxHUE0Srec3GLNv54vaNk7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686883; c=relaxed/simple;
	bh=HxIUsJFO4us/CbkHhbsCVmSmMz6PyVf7Pqetxa2gc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reGyuY7m+vPIeC8Ot2bXubEfnzKbUXZbEDY6dr90DqzCMisU0KFjFk14rJ7Elctvpo9NouRdiFXsRO2apZgSFTpVSGd2i3jA1j/ICgWqHqFbWD2rVfl8l93Nl/s9QtfK6scUJiI1sjEbDoHmqt79DS/hRs74U5ITukgjwmWCtAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmfMaeoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmfMaeoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909D1C2BD10;
	Tue, 14 May 2024 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686883;
	bh=HxIUsJFO4us/CbkHhbsCVmSmMz6PyVf7Pqetxa2gc6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmfMaeojgM3elJHSWfiKy09JWjtTW47fsh7yhK8hpkbET37xUW4k+Nu7OJ2xb3xLm
	 7QIbtO3s2CgKCfZW7WWckcbHWQTInHUoFr0qZICRmVfVm/r6Z7JtZN4CJpdZ1x7ZN9
	 oDx82iW1LlV5fGqkZvkZsQNiSn5+CaQVFecDhFdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/63] gfs2: Fix invalid metadata access in punch_hole
Date: Tue, 14 May 2024 12:19:44 +0200
Message-ID: <20240514100948.891878002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Price <anprice@redhat.com>

[ Upstream commit c95346ac918c5badf51b9a7ac58a26d3bd5bb224 ]

In punch_hole(), when the offset lies in the final block for a given
height, there is no hole to punch, but the maximum size check fails to
detect that.  Consequently, punch_hole() will try to punch a hole beyond
the end of the metadata and fail.  Fix the maximum size check.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 729f36fdced1f..b365828328df0 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1751,7 +1751,8 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	struct buffer_head *dibh, *bh;
 	struct gfs2_holder rd_gh;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
-	u64 lblock = (offset + (1 << bsize_shift) - 1) >> bsize_shift;
+	unsigned int bsize = 1 << bsize_shift;
+	u64 lblock = (offset + bsize - 1) >> bsize_shift;
 	__u16 start_list[GFS2_MAX_META_HEIGHT];
 	__u16 __end_list[GFS2_MAX_META_HEIGHT], *end_list = NULL;
 	unsigned int start_aligned, end_aligned;
@@ -1762,7 +1763,7 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	u64 prev_bnr = 0;
 	__be64 *start, *end;
 
-	if (offset >= maxsize) {
+	if (offset + bsize - 1 >= maxsize) {
 		/*
 		 * The starting point lies beyond the allocated meta-data;
 		 * there are no blocks do deallocate.
-- 
2.43.0



