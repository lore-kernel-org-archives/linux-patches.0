Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD41350A2A;
	Tue, 21 Oct 2025 19:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076741; cv=none; b=CK2xYdzsDA9L31Eo9LL4A3BEzq8yVjINAN1OISdkonmFajlfTcK4KGaW2Ky/WOgVotNiOV2Er86+SZEQRLA3vc8+4Yo9bSU/AA2bCHuezn7Q7fSz3lZTOVi4H9PvUmLntDatlE5b0tG+sOXQCCXoYq/EHAtEDPTZvg2k3Fg20lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076741; c=relaxed/simple;
	bh=yDL0ml7fYKl8ejGi5VnOSUhsuFiVWkabnsNpykNEjeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW6ffN0BlLX+QiwE4+m9LfEy3GgKq62bjthteSiIiutt5BrL54/eU7Undp7vZjsZNCCBikItv7QQyDdtW3b0GR7cdJPy7AvbSiiSk9VesqbNYbZsopC3mUCsBvyofBQlNsGZBzy3KWDIkIFOWemaEhK+v4Xhz+oCZSDjtYPHI7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfwosIFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfwosIFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D30DC4CEF7;
	Tue, 21 Oct 2025 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076741;
	bh=yDL0ml7fYKl8ejGi5VnOSUhsuFiVWkabnsNpykNEjeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfwosIFCtz9AuxTg5dDcz/P7cSZguNIUFg+M4hjDARRRecYXDJppPyt5vuxcFU4Cj
	 +zNCTFX7r6kE4tICkIlC8TfiR/vszuYkTbnz8oh+ilT2KIBU4UWSVISptmQTixclmC
	 FIoItHr/v3gnrEZaUZGaIyJFsDt9+HbrRVlLwM1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edd Barrett <edd@theunixzoo.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 023/136] perf/core: Fix address filter match with backing files
Date: Tue, 21 Oct 2025 21:50:11 +0200
Message-ID: <20251021195036.531546029@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
@@ -9086,7 +9086,7 @@ static bool perf_addr_filter_match(struc
 	if (!filter->path.dentry)
 		return false;
 
-	if (d_inode(filter->path.dentry) != file_inode(file))
+	if (d_inode(filter->path.dentry) != file_user_inode(file))
 		return false;
 
 	if (filter->offset > offset + size)


