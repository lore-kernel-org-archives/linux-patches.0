Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C22773F1;
	Tue, 21 Oct 2025 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077361; cv=none; b=fHoko4tZlMk1U0SwFhf4HOW+KG3e8im0B/BCztbaj0uVgugzq+rk88ML3OQV9Lijqznh0bW5zA2R2WdczW6kaRzkVcKkK8kNhevocv5HZdqz8oChcKo7CjaYaVOJlvebwB2eScC2C2TLfFHMj9D6TXUTyndSt63mAIvXEqzHaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077361; c=relaxed/simple;
	bh=xogXHObruw5FGgFprr1rM6FTNT2FvKOtjKm04d3BbHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTdsrbnmfYfgQ06lKTaiA43JHc5M+f8mnBLXLFFzbbR5TjtvAbbzzyJNxDe0DIVhwJsR9tsqbnL6yWY2bThseb/f3YAoIDzAo6ce6/5HIb9+phAFx4t+7+v1TSAneg2IdB9F5DJ7+yFAtOQk63davLXJ0W3Vg9Pt/7pOe1A56mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGmwK7DW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGmwK7DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DC7C4CEF1;
	Tue, 21 Oct 2025 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077360;
	bh=xogXHObruw5FGgFprr1rM6FTNT2FvKOtjKm04d3BbHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGmwK7DWp3609HZdceW6jHTXqYszxQCRQANEIU0el3SM3NswWBe5ujNyNxwxeSVgd
	 zqQt5RWDndcIfLccb1/k5o7vvF/ZIG9Nb2yk8V99XC7yc/M80MP+KmsnphQSTOd9rp
	 szFjiTBnBPYvabglzfkAnW/NVcou54iZUp4XWRx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edd Barrett <edd@theunixzoo.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.17 044/159] perf/core: Fix address filter match with backing files
Date: Tue, 21 Oct 2025 21:50:21 +0200
Message-ID: <20251021195044.261503558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit ebfc8542ad62d066771e46c8aa30f5624b89cad8 upstream.

It was reported that Intel PT address filters do not work in Docker
containers.  That relates to the use of overlayfs.

overlayfs records the backing file in struct vm_area_struct vm_file,
instead of the user file that the user mmapped.  In order for an address
filter to match, it must compare to the user file inode.  There is an
existing helper file_user_inode() for that situation.

Use file_user_inode() instead of file_inode() to get the inode for address
filter matching.

Example:

  Setup:

    # cd /root
    # mkdir test ; cd test ; mkdir lower upper work merged
    # cp `which cat` lower
    # mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
    # perf record --buildid-mmap -e intel_pt//u --filter 'filter * @ /root/test/merged/cat' -- /root/test/merged/cat /proc/self/maps
    ...
    55d61d246000-55d61d2e1000 r-xp 00018000 00:1a 3418                       /root/test/merged/cat
    ...
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.015 MB perf.data ]
    # perf buildid-cache --add /root/test/merged/cat

  Before:

    Address filter does not match so there are no control flow packets

    # perf script --itrace=e
    # perf script --itrace=b | wc -l
    0
    # perf script -D | grep 'TIP.PGE' | wc -l
    0
    #

  After:

    Address filter does match so there are control flow packets

    # perf script --itrace=e
    # perf script --itrace=b | wc -l
    235
    # perf script -D | grep 'TIP.PGE' | wc -l
    57
    #

With respect to stable kernels, overlayfs mmap function ovl_mmap() was
added in v4.19 but file_user_inode() was not added until v6.8 and never
back-ported to stable kernels.  FMODE_BACKING that it depends on was added
in v6.5.  This issue has gone largely unnoticed, so back-porting before
v6.8 is probably not worth it, so put 6.8 as the stable kernel prerequisite
version, although in practice the next long term kernel is 6.12.

Closes: https://lore.kernel.org/linux-perf-users/aBCwoq7w8ohBRQCh@fremen.lan
Reported-by: Edd Barrett <edd@theunixzoo.co.uk>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9479,7 +9479,7 @@ static bool perf_addr_filter_match(struc
 	if (!filter->path.dentry)
 		return false;
 
-	if (d_inode(filter->path.dentry) != file_inode(file))
+	if (d_inode(filter->path.dentry) != file_user_inode(file))
 		return false;
 
 	if (filter->offset > offset + size)


