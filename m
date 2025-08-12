Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A523F9D2;
	Tue, 12 Aug 2025 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022716; cv=none; b=Q1lUAwTmpGR9U3531kMDkzf973cYMpoLbLA0VHlgOX7IVNclvY1Gx655O37UA6cPxU598c7lvLeF8HSk5qDGlHJkgFd6xH7N8yQhD8QtEshpQQt8+ZYwnQAXMzw65EtQ9T5nrHvq2Sk4J4CAhgBPFcjwskfwBL2p58F/XAhhywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022716; c=relaxed/simple;
	bh=8kVS8gbrxBGDcpIdyUmfWi2teCfZq+M7jNLmrJUMJmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i27UXfSPlfimElMBh34sF+f/+JV3we8vtHStjzpKSZQfPZmhGy3DVeQkJEWt/feaWTmVCId1dipfqr0uUq1b86me2sVqK3kSlCbHoSUj3dkUPMD2bonk6utDYGz3i8E5LJOusmfDxm5VsxMyTUjOXS2wQmBd4itfSgGJZZsOAV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxVioBt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxVioBt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7BCC4CEF1;
	Tue, 12 Aug 2025 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022715;
	bh=8kVS8gbrxBGDcpIdyUmfWi2teCfZq+M7jNLmrJUMJmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxVioBt5kjDsCQSZCWN+7z11kLzEUbfjcZyul/0P8gJOlgtr3t2C9RbGe/J+tS827
	 euoUr70EV8Q1YSKrpEPUQtd1xKe3a5o/+DjzEnS5FsV00jGQd8J6ACqYeePmPqtTfg
	 jDtdb2Ca5mcy67nK1KVib4GhuM8GL5X0tOdpCNzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/369] bpf: Check netfilter ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:28:54 +0200
Message-ID: <20250812173023.688358775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 9e6448f7b1efb27f8d508b067ecd33ed664a4246 ]

Similarly to the previous patch fixing the flow_dissector ctx accesses,
nf_is_valid_access also doesn't check that ctx accesses are aligned.
Contrary to flow_dissector programs, netfilter programs don't have
context conversion. The unaligned ctx accesses are therefore allowed by
the verifier.

Fixes: fd9c663b9ad6 ("bpf: minimal support for programs hooked into netfilter framework")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/853ae9ed5edaa5196e8472ff0f1bb1cc24059214.1754039605.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index be3f72fcc678..b5e4ca9026a8 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -295,6 +295,9 @@ static bool nf_is_valid_access(int off, int size, enum bpf_access_type type,
 	if (off < 0 || off >= sizeof(struct bpf_nf_ctx))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



