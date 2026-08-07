Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEF0404BC8;
	Fri,  7 Aug 2026 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117240; cv=none; b=OyzMknRXoD8Q6Ge28r5iM/E0r7ScwT/WrAGAJNiAtihcIgvg5MPAmeiHaGE8e3P5cNsyf1ica4ZMmjMsCXrit3bj4kx9WP96ExfHx06TancLIsTvP1fJpfOUb+VRBfLxf4dfzUCPZrSoORpWmXvT6GL7IKSjF/20e5CrRaCr/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117240; c=relaxed/simple;
	bh=7dNO30rZ5jas83Oqbf4bSFYayyp7VCPpty3LcNSwbTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re9Niv2w9yBaLZAHgwP0R0Tyja07h18zMdsM51x5htHwC41IRCMstz4Y1aVPZmGF5Qlgu2O9FrKeVWQIOpC3bW2ytNp80NLA9ZP5qy7LH/emO5ZJubM/Hstm+SYiP6eO41XrMmy/0prQQP8gERku6qWxCXZdnPiArO+SIAMkKc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W605wQ0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W605wQ0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7891F000E9;
	Fri,  7 Aug 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117239;
	bh=zp7nT7JgjlxA7lmNozhK52vW/FQCl6VChT1PegDYLkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W605wQ0h6ce1SvzCKuSwm/Sf/hHF1YyMtAvfL4au03azedW83g5GBLa7AUF8d+3vz
	 XZ4LJs96sdQjO5T6I+GqMhpe+L1fKzQOLblzC7mqb5A0Hg3ege6P39V29UQ1Mza66h
	 oDbez+wXmKCCK3q5YXzaswPk0XFkdZwmke8unFpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 248/438] bpf: lwt: Fix dst reference leak on reroute failure
Date: Fri,  7 Aug 2026 16:37:24 +0200
Message-ID: <20260807143433.285361891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 88c17de85ddb459c3fe1e3c65d61fa366b1cf0a8 upstream.

bpf_lwt_xmit_reroute() obtains a referenced dst from the route
lookup. When skb_cow_head() fails before that dst is installed on the
skb, the error path only frees the skb. The skb still owns its previous
dst, so the newly looked up dst reference is leaked.

Release the new dst reference before freeing the skb on this error
path.

Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260723060445.21926-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/lwt_bpf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -255,8 +255,10 @@ static int bpf_lwt_xmit_reroute(struct s
 	 * if there is enough header space in skb.
 	 */
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto err;
+	}
 
 	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);


