Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CCB2E11BF;
	Tue, 12 Aug 2025 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026508; cv=none; b=kbuzJ72OMdLTuFogfCsCqBx0Jqwm9zSWOiKMYC93eTLCxJgLxCofnNynXsh3gKe50trVsp8sAaGFtceS2dgVS9jI9KI0JJbB55qZV2kdu6LpSczw+dpOJixcRWqiU/aml9IXlYRmRQyKTDYI95IzFoqNwGUaVeiP/giLj62Hezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026508; c=relaxed/simple;
	bh=rwz6XV/ugUpFBWoXMAApgztZVhvTmAx+kxvoXdLTfnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV7D1ZXVXbcx8bIallVqrp4Zwgq7Rr5eSi2HEQeomAFT+dy61BRuIHYQXDpMUjr8VmXOok591r5YLsXuDjl8O5k7Wd2dxqWVOobJcfI9/abinYweQ0KfwRRaHGGkTG51TytanjF4wgHgov0gK8YmfMf8zHHPI+8uliNeT+DAVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZBxR4DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZBxR4DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6776C4CEF0;
	Tue, 12 Aug 2025 19:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026508;
	bh=rwz6XV/ugUpFBWoXMAApgztZVhvTmAx+kxvoXdLTfnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZBxR4DIOFpwntlNBg487Oq+YU+pDE6B5/YqPg/ISVrLBFU14r71EV7CxigmJcWQe
	 wlgFvx59i5iXHKywrAGi2UfdoEgkFEJKlOzwB+jfkE7ym0Q0iOh38pvNoifRSmCHKd
	 uR4Y1xO232E0dqrsL25TUWma+SvZJcq9RTebbGBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 331/480] bpf: Check netfilter ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:48:59 +0200
Message-ID: <20250812174411.095534857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 25bbac8986c2..c12250e50a8b 100644
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



