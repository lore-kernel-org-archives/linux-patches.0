Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6D622ACDC;
	Mon, 10 Mar 2025 18:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629600; cv=none; b=scupSuAwndKi8ZsmjJk1UykKZy+YXUJwfUPED/X90gVRoXf3svkk23la+IcUUZdPf7L2BEaJBCtL///eA9fXzZaFCmAVeI+Kwwcd4VfrDYTtnahDt+fzlVUcbYT/RJwsAXoQLlTzkHHzxubd7HadqpcS1olFsMdDYORkfzOsqNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629600; c=relaxed/simple;
	bh=hAz7LGVUH2vIiPdTogzTKF1R95LHL/FcDSPa7jM/kxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPeERUQPEKnFWT+wKuZPCfxC3PwMkcUTMicha7jFQDb1geqrYB4RmNjcIyksXCH0IXoin5DsSs0+o1inQ9GXHh8306faCjX/fKNRpivFWXJ1s+CC9qBG1Dp8YTkTCNR8uU9p2KjcApW9tesgXrtMRWtqUGwRygHxG8BtGgW6YqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FreTDOre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FreTDOre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0704BC4CEE5;
	Mon, 10 Mar 2025 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629600;
	bh=hAz7LGVUH2vIiPdTogzTKF1R95LHL/FcDSPa7jM/kxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FreTDOresliOJzgKJC2/ez4Wuhfi6DtbY0gcTNE1XLoCn3RY5P9PzNX+JZC79kBZd
	 e7ARMRym7BW8NxnbhOlMms+ZH4sMwbHUEwE7T7BWolSFFw9dFP2mR/jT71nIRV50Rn
	 VV+mzgCSw5yX6ljfYh7Ix0p92yDus2JKvOvjVRBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 319/620] ocfs2: fix incorrect CPU endianness conversion causing mount failure
Date: Mon, 10 Mar 2025 18:02:45 +0100
Message-ID: <20250310170558.203156985@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

commit f921da2c34692dfec5f72b5ae347b1bea22bb369 upstream.

Commit 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
introduced a regression bug.  The blksz_bits value is already converted to
CPU endian in the previous code; therefore, the code shouldn't use
le32_to_cpu() anymore.

Link: https://lkml.kernel.org/r/20250121112204.12834-1-heming.zhao@suse.com
Fixes: 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2346,7 +2346,7 @@ static int ocfs2_verify_volume(struct oc
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size bits: found %u, should be 9, 10, 11, or 12\n",
 			     blksz_bits);
-		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+		} else if ((1 << blksz_bits) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=


