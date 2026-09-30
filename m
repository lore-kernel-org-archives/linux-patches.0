Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A62D9484;
	Wed, 30 Sep 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791464; cv=none; b=lSdgPgp1mH05/8isgwSbK13H9UCZdvrYFHIdFHLA5R9B2IW3ZvOyjOnJEbTJloiRmENgom+2/MJQpCtn1XGrwVMAGxDphEq7QzdPFYCPMfT9cmkgRELhb3oNtfOsy3BAR9VpX4TVeZeq0i0YsY+y/2ZG/skUDG3gmcj6Q5AhIk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791464; c=relaxed/simple;
	bh=4lJewGr7xdFJ8HMQlT2acYnFw9Gk+f+b2luy03nQaCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCUcNrjqfVp4zViCOToeLrRDdhU7hDYexnGBT7HrQM13Dw3wQiHdy09P2/HEFcEZQJg3TjC8MhGn8RZzzGQjnvmAmQS0j/Biq0CkpkPREFTcEMduJcMHrIrB95galvIuajcdEBYQtqkMxX2R79mi+xaaP75SH1b+5QNjUWgGYZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvCcocxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvCcocxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E011F000FF;
	Wed, 30 Sep 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791463;
	bh=7Zpmo+kHh/gw1s+d7RG/md8aaqW6UA5k9/Fs6+MIlEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvCcocxAgbiCyGzf97MiBy7BYtzDPYjC9LK1aGOm7IDXTqT7vxGCctfS/hGxP2/Iu
	 Grib5nTAssCJUtnmxMj6+5PIn+aAoxYJ/AJwIdx9yNQft9asBDjo8dTqA2ByafZ71Y
	 DBqewtLjI+Pdty6KJQ0LPyJLwhM45OcOt0c1HD00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/752] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Wed, 30 Sep 2026 17:22:59 +0200
Message-ID: <20260930152404.981509899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c6755be4838d6ccd641effbcdc3d917b82631ff9 ]

add_usable_mem() adds usable memory ranges for the kdump kernel.

The ranges are inclusive, but the partial overlap check uses exclusive
comparisons. This skips ranges with base == loc_end or end == loc_base.
Use inclusive comparisons instead.

Fixes: 7c64e21a1c5a ("powerpc/kexec_file: Restrict memory usage of kdump kernel")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260809162403.18142-2-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index ac8160cbcf673..e1af6f2073829 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -478,7 +478,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
 		loc_end = um_info->ranges[i].end;
 		if (loc_base >= base && loc_end <= end)
 			add = true;
-		else if (base < loc_end && end > loc_base) {
+		else if (base <= loc_end && end >= loc_base) {
 			if (loc_base < base)
 				loc_base = base;
 			if (loc_end > end)
-- 
2.53.0



