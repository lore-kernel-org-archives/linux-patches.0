Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FF6221DAE;
	Mon, 23 Jun 2025 21:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713140; cv=none; b=gZNQ5xyrSP4rFHmr/52klL2VClSd8AgxMAf6RZu2O9c4IoCx7VuPlJ9k5eCaYg9YsWDFTEed7zIaOBEIlTsfnW30Kwc4oHbBuJ1GbCPck7FPFjv795/qITCLWCMRTJgwVFeIg8AWZvbxxaCfCcpw/S1EYsT/Nj86/PXkdBhsvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713140; c=relaxed/simple;
	bh=khV5Ry6jbBn/NsR//l57sq+VWajwtv0e908QzaLOnnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS1CHyNQ+Jc0aA3wTAZuSXtiDAWlHoDIjTptBzF9JUiuWqv5O5wdJzpxEWDTrIEigaLX2WXV0j+JNoGfWTRr2BnGIOsoyHVpscAOIND7YKF6zWHqNhNOK8g2otXkIQZl4kuiEqWBHuIZ+nZByMhSN7o19r6TUwXYFkF9t78NgTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kqj9yXar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kqj9yXar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60110C4CEEA;
	Mon, 23 Jun 2025 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713140;
	bh=khV5Ry6jbBn/NsR//l57sq+VWajwtv0e908QzaLOnnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqj9yXar6DlkPXpbVAvht3rfzpkuBmWPiaR+gk7mcSwCE9+KC0k/GZjMAEoPPQxT3
	 SbF1r30PXX1N0uonDD4emC5eImXFP8cL/gvvCvVwyoOp5zJWuH0VH+Wl+6z0kXf/A0
	 OMKKUsKLNnq107DdgzmboXzi1uDGGLh9RIReYvpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 330/592] libbpf/btf: Fix string handling to support multi-split BTF
Date: Mon, 23 Jun 2025 15:04:48 +0200
Message-ID: <20250623130708.306047124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 4e29128a9acec2a622734844bedee013e2901bdf ]

libbpf handling of split BTF has been written largely with the
assumption that multiple splits are possible, i.e. split BTF on top of
split BTF on top of base BTF.  One area where this does not quite work
is string handling in split BTF; the start string offset should be the
base BTF string section length + the base BTF string offset.  This
worked in the past because for a single split BTF with base the start
string offset was always 0.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250519165935.261614-2-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 38bc6b14b0666..8a7650e6480f9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -996,7 +996,7 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 	if (base_btf) {
 		btf->base_btf = base_btf;
 		btf->start_id = btf__type_cnt(base_btf);
-		btf->start_str_off = base_btf->hdr->str_len;
+		btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 		btf->swapped_endian = base_btf->swapped_endian;
 	}
 
-- 
2.39.5



