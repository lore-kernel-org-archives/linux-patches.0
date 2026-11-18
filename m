Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056538;
	b=nEWHigCs7yUbnHQ8jDw3I50TFaTni1WtnSJShXmMmCsONKZ6+iomzuEUEvd+oGo92MXa
	 Tcm1h+VUPkSCLSeRJoUWphRl2ZWf0o8p0fSnoChqIWyzUf+4ubUYt3T/7n/6XrljpZ2+E
	 xvx1rPMLrC8QKRobcsLgtgmPFVgErUwnRqU4FQHl0Ob9nxcqz4SESBn9ojsxrHs7/4Mqz
	 Vp2GhgpXXcotquqDBocPQMZAcXmt/PCvaO4ZT3xnBvfLY4eer8RGDOizflSW3SNCDt6ML
	 AiE6F6ZULVfHS54bZBBOCrPzMcqVNFNocBEe3NWHFxaiAZXn4T83F003htwKDC8QZ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H9TSQ4KB5D4wKNjuzQthCPWWImoyN++WeSG0jBwyz/Y=;
	b=Uz9oWvf20IjnTsNW7Hrt1sHJXRUrjGUBwN48x8URrq8i7BLN0qjis/ZTNViUS95V20cm
	 R6EgV4HRnikiObUBpZrNuDuK2mGsIGAtuRekIv7l+D2k3L4Ywh0lbikekrWa43esjGNIH
	 rsc0NqsnPED2Ziw52iDoippCw/zk8cuxG7gqBaXVVv/ohQYZ/TYL49bRfXwSI6Cjyy5Hz
	 EV85+nBDMcwP+rv9q/WJ13QrLDiWOp75hzEQlG2zHKxkAu3kU48md4UyhmFFb3/6YzYcx
	 kC2gZrhWjLes5GBK5RlzjKYQjbMtAb+CRSpta901N1LGt3CFb2NouFtH0bjq1/Fa8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anOuikZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC63606A31C;
	Thu, 19 Nov 2026 02:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anOuikZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2F51F000C4;
	Thu, 19 Nov 2026 02:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056538;
	bh=H9TSQ4KB5D4wKNjuzQthCPWWImoyN++WeSG0jBwyz/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anOuikZ7xw/pMPqGvEENe/CvydTQHKwnU9xnZf2ozdAvIII1vNgnb+dX5KDFYdcZW
	 rpssXiw8UAlv38RWGMBrKuVLIq9ueiSlJsgpou2bX98AdBzX3pvFkVMDnFlZiD4sH8
	 KdbLLAXT/XmTNDLfIW/icTjKUFTUvt6id+kfBpHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2022/2214] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150131.638664312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 427e751a231aa781441d51c42e716905ee348099 ]

For SEG6_LOCAL_ACTION_END_B6 and END_B6_ENCAP bpf_lwt_seg6_action() looks
for the SRH again only if bpf_push_seg6_encap() has succeeded. That
function pushes the new header, for which the head of the skb is
reallocated if it has not got the room, and then looks up the route to the
first segment. If there is none, it returns an error, and the pointer to
the SRH in seg6_bpf_srh_states still points into the old head, which has
been freed.

The program goes on behind the error. bpf_lwt_seg6_store_bytes() and
bpf_lwt_seg6_adjust_srh() read the SRH through that pointer.

Look for the SRH whatever bpf_push_seg6_encap() says.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index a3712d4068e8f..e8bb5d9b9a2fa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6273,8 +6273,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -6282,8 +6282,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	default:
-- 
2.53.0



