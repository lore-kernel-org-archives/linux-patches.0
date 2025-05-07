Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DA421146F;
	Wed,  7 May 2025 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644467; cv=none; b=kZrnkMBwRv847qRW1R+zlhkD15gI/0t2MzECDRqQbtiyvlSfLo2TCV2RMtfI64nMR8lBucOFD/agIsKzDdPLHQAFhEZBzEmGCx6dcGUColMTLQcNdiFpZDAKwVuePeNebtNpNIo/yrFk6HJc9Xw05xkoXqCTMEElRYbigRpX2vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644467; c=relaxed/simple;
	bh=uAWDI7ETt4w36o80ZongQMMMDe1SQLz3vjcvBD+c754=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dExIUAlwogOAnR1bEVGRCUb0mTKdIcJija6YXE4r+FRsAR8xbfCcv5TbzcGw46SUhbTUKhzvWHbqnIehnDi1SZ002+80X7ybU1wqFFX9pWgjPVcK+UWufmRkqkl4qPj0cLC2LPhq+rhdxN62ZM2CEx2Wkk0g6AKD+OVBwPm8sa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQkntTYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQkntTYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C8FC4CEE2;
	Wed,  7 May 2025 19:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644466;
	bh=uAWDI7ETt4w36o80ZongQMMMDe1SQLz3vjcvBD+c754=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQkntTYFh5CGzqY3vCy14FmQBizQqnSMcLRmtssMvTldE9N97bMrXejJTTpjvulir
	 wSkOFXTEKH8dwPHc1ccv8MkiA+AwKomVS5i2D9/mZiJf3Yu+Af2fh5Eo0c9HfGBuhL
	 fjj8wf1KXMPXDl63x0eBzlBG8caWbg+HLExRqeXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Yajun Deng <yajun.deng@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH 6.12 025/164] mm/memblock: pass size instead of end to memblock_set_node()
Date: Wed,  7 May 2025 20:38:30 +0200
Message-ID: <20250507183821.887915880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 06eaa824fd239edd1eab2754f29b2d03da313003 upstream.

The second parameter of memblock_set_node() is size instead of end.

Since it iterates from lower address to higher address, finally the node
id is correct. But during the process, some of them are wrong.

Pass size instead of end.

Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Mike Rapoport <rppt@kernel.org>
CC: Yajun Deng <yajun.deng@linux.dev>
CC: stable@vger.kernel.org
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250318071948.23854-2-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2173,7 +2173,7 @@ static void __init memmap_init_reserved_
 		if (memblock_is_nomap(region))
 			reserve_bootmem_region(start, end, nid);
 
-		memblock_set_node(start, end, &memblock.reserved, nid);
+		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
 
 	/*


