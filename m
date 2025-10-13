Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BC630C628;
	Mon, 13 Oct 2025 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368286; cv=none; b=lxKmu8kkCpF3Bm8R/TPFtg7q6bm8jrn0FRm4q4ZxOW7vq9XMC9yPyEjYkEvfaTiOSMqGFhH3fO8ZjN0ilkzZQTHuZ7FER6ljPB+xDKFQookHqdmifgu0+TKebGwVEUawNxAlPdKiCDnnD3MPTHQ9F5ts4CdmBVfXnhO1Qa+iZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368286; c=relaxed/simple;
	bh=E1FOUgV0zOlv/LiiaT3B0XVBIbVL/2DTrzs+D1xZ4vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjnTb2qBouYu/kBQZ4gZ4rrLkwYfFeqL1bXPM/mtb1SaV3o7VFtPsw4CwRfC9SrihdMLCHsY+jigC6dVsAUxQu/uh3PQZs48OvV6TAq7yFQgK/p3UObvo0FH0TqcFaC7a2wSjJCqVrg0YfbibN7UYkohTYCxkMVGpP+Gl4MUYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHJ/Nf4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHJ/Nf4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D47C4CEE7;
	Mon, 13 Oct 2025 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368285;
	bh=E1FOUgV0zOlv/LiiaT3B0XVBIbVL/2DTrzs+D1xZ4vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHJ/Nf4KHVF+/pQqd8EC4nVTBGHHDBGdo+n+NjaNvwDxCvSZ731zjRh5fwHP2sacw
	 jNo/pNac2yNM518ZegtVFeuoc9NehSCRXG/ZWOH0uzSpMZa4jN/oNyZ7uowyiGPsEj
	 U3hw1Be5V49ofJPyEcmweM16skfA8GjoeEU0S0PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+136ca59d411f92e821b7@syzkaller.appspotmail.com,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/262] bpf: Explicitly check accesses to bpf_sock_addr
Date: Mon, 13 Oct 2025 16:43:37 +0200
Message-ID: <20251013144328.826677533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 6fabca2fc94d33cdf7ec102058983b086293395f ]

Syzkaller found a kernel warning on the following sock_addr program:

    0: r0 = 0
    1: r2 = *(u32 *)(r1 +60)
    2: exit

which triggers:

    verifier bug: error during ctx access conversion (0)

This is happening because offset 60 in bpf_sock_addr corresponds to an
implicit padding of 4 bytes, right after msg_src_ip4. Access to this
padding isn't rejected in sock_addr_is_valid_access and it thus later
fails to convert the access.

This patch fixes it by explicitly checking the various fields of
bpf_sock_addr in sock_addr_is_valid_access.

I checked the other ctx structures and is_valid_access functions and
didn't find any other similar cases. Other cases of (properly handled)
padding are covered in new tests in a subsequent patch.

Fixes: 1cedee13d25a ("bpf: Hooks for sys_sendmsg")
Reported-by: syzbot+136ca59d411f92e821b7@syzkaller.appspotmail.com
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://syzkaller.appspot.com/bug?extid=136ca59d411f92e821b7
Link: https://lore.kernel.org/bpf/b58609d9490649e76e584b0361da0abd3c2c1779.1758094761.git.paul.chaignon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 02fedc404d7f7..c850e5d6cbd87 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9233,13 +9233,17 @@ static bool sock_addr_is_valid_access(int off, int size,
 			return false;
 		info->reg_type = PTR_TO_SOCKET;
 		break;
-	default:
-		if (type == BPF_READ) {
-			if (size != size_default)
-				return false;
-		} else {
+	case bpf_ctx_range(struct bpf_sock_addr, user_family):
+	case bpf_ctx_range(struct bpf_sock_addr, family):
+	case bpf_ctx_range(struct bpf_sock_addr, type):
+	case bpf_ctx_range(struct bpf_sock_addr, protocol):
+		if (type != BPF_READ)
 			return false;
-		}
+		if (size != size_default)
+			return false;
+		break;
+	default:
+		return false;
 	}
 
 	return true;
-- 
2.51.0



