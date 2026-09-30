Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CF5361DA8;
	Wed, 30 Sep 2026 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785179; cv=none; b=gAUfLrkuLjCd47FpFQa+ec5Z1JM5O+DJtJr5VvcqfywnheIvTpjd2vZHUvxzFsQLSvKzoNZ9MLDvu00sjdkTUX3+mMpORsbYjv45QA7DVhfA6r7O+voCbjgEQikWbZPcPtNDan6z8Yh5xmj19xqeoGsh2UM2AN36c9kxMFQ8I0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785179; c=relaxed/simple;
	bh=7tUOCL7lzLBjUi3AlADos2kVkuak5Y79q/iy+Vv+zbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJw/Pl6yQ/KrUz8XKOvxLNjJUgXB8hbZPIxW9c7KehhTmvYdTK+1SsgrxWxC0YHceCdrn7O/gkKwGNHatp2Cd1tiYnyArf3xYdfs14jqJJKIEqDxICyVePwPAgIL5H8FSoNq6qyRDmtbw7dLDARu4tv57u3Adlehf8ORTcclUvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jGpi1Te; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jGpi1Te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B293D1F00893;
	Wed, 30 Sep 2026 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785175;
	bh=0SHqwcYVwuecGkowOIB8sxm4zevauXl/HXHDmbEyB5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jGpi1Te9sDt6LWntlVCtriYzhhh3fKReC7TjAmjFjEg9bCby76QmHs3PCEYML9vS
	 VCR+KuyxymB1YOCGiO8tOhYRvhFYWyrXmB6pwlGtESRn5WeArUmPWda/rw6AN2KsaS
	 /AdjiBuWaHLpeFliFfPA/rLtIsl+tkg6lKJ6oXAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/982] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Wed, 30 Sep 2026 17:19:12 +0200
Message-ID: <20260930152425.739166557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e3382e824311..d2a54bdc48468 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -479,7 +479,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
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



