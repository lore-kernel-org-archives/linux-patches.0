Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579B13612C3;
	Tue, 16 Dec 2025 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887351; cv=none; b=jai3yRA4zngqqOIq/KT2zC5514SSTYYb44T0Hz92xhuxrIuBKGMGSm1N6zDlgzHhQjgIIQdcmtp2ABzdQu+7CpLMdAiFyD5V5gHoIAOLK08bsWMJw9UngcYTyvRGKyyRJMTrhQ0B//l+IgL8GzHNMDqjbgnhIBgMpac8+Ll91ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887351; c=relaxed/simple;
	bh=W9daYxmC5ZnB3zk7zQ8V5IvG70Kut7maljihI3ZpPvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2VKqCqBEJGtLfcV0CjtDRiuv6ZVh/WY9Z/eEU5UXf9fcSnAWCWMo4IVQa9q9oiwVwuwwt/TRUFH22iXcNGFGRzn91uMCqc/f97xzWmbID9vNQS+NMexBFawd262pHg8Kf30VywyUUyO4duzk7wCaZKA5Er6PFptjtFABVqiiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWHLFRIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWHLFRIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8975BC4CEF1;
	Tue, 16 Dec 2025 12:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887351;
	bh=W9daYxmC5ZnB3zk7zQ8V5IvG70Kut7maljihI3ZpPvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWHLFRIYD3bo73u/s5KCuDVZxM5PlGrvdkAOKTsjRArehySBGak/NwS8mg4xTuQCv
	 I8Z+BkI7NlFK3bvXii83AG/Yj0+d5GsWzN+OHYq1H5Max/JE0K6h9cocOKesTE8Qtb
	 8okIWWhlpnKbjRr9MBKTks8pTCePLs7c3f3G3Ud4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/614] libbpf: Fix parsing of multi-split BTF
Date: Tue, 16 Dec 2025 12:09:29 +0100
Message-ID: <20251216111408.697435313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 4f596acc260e691a2e348f64230392f3472feea3 ]

When creating multi-split BTF we correctly set the start string offset
to be the size of the base string section plus the base BTF start
string offset; the latter is needed for multi-split BTF since the
offset is non-zero there.

Unfortunately the BTF parsing case needed that logic and it was
missed.

Fixes: 4e29128a9ace ("libbpf/btf: Fix string handling to support multi-split BTF")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20251104203309.318429-2-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 18907f0fcf9f0..9f141395c074e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1061,7 +1061,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf, b
 	if (base_btf) {
 		btf->base_btf = base_btf;
 		btf->start_id = btf__type_cnt(base_btf);
-		btf->start_str_off = base_btf->hdr->str_len;
+		btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 	}
 
 	if (is_mmap) {
@@ -5818,7 +5818,7 @@ void btf_set_base_btf(struct btf *btf, const struct btf *base_btf)
 {
 	btf->base_btf = (struct btf *)base_btf;
 	btf->start_id = btf__type_cnt(base_btf);
-	btf->start_str_off = base_btf->hdr->str_len;
+	btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 }
 
 int btf__relocate(struct btf *btf, const struct btf *base_btf)
-- 
2.51.0



