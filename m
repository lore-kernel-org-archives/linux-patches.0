Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCC2EA178;
	Tue, 17 Jun 2025 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178975; cv=none; b=Fy3UQAsQn2ml3+2iSAv4Py4f8RN005BudrWzToTOGJ1rxgfeRpvzaWKYKSGvwZzjXVLHbqDrFtVga3Y46hIGLtifC7lJxQKuP14ZLU2kYpIEACDG9/ci4znOJDrPV6qXJcyIgLViiY++txgJuo9JaFwWPGBWGdGUNzzpWNAm7bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178975; c=relaxed/simple;
	bh=gURQXcYXp1krrGvWHg8xDAiBLwQvZRwA2WLsFwM3C8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV/w7eUaLTqNoatGnalpSzRm1KbSdzTWzY7lhSnnzak8SmaPpUF3vGkYqiouesbHOG/27xBEgIAFS3F1Qi0Ltsb9jPJqDDpmbOFZPh7yuX5gmKrQfptrbDtYcHrFxziPaLuKOFzIInTW3RT4A/6jYzhESr8tSnsDEd7GkrbXyLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn7lZVD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn7lZVD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62199C4CEE3;
	Tue, 17 Jun 2025 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178974;
	bh=gURQXcYXp1krrGvWHg8xDAiBLwQvZRwA2WLsFwM3C8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kn7lZVD25cXQy0268eXWfahWSibnONU03/QODWdNaoZerVYQnWvWR/nvryIsoFNDi
	 wOOnjsAlvozvg+pBitu4cTNwl+dzZm/s1x6kvMMe5rPW9pyWT2hqg2h3VBkhxK++8s
	 VvxC3C8rNWxyOvJM0/ZDP3Z1T378CdR0j5xAlNrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 580/780] bpf: Clarify the meaning of BPF_F_PSEUDO_HDR
Date: Tue, 17 Jun 2025 17:24:48 +0200
Message-ID: <20250617152515.104288189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

[ Upstream commit 5a15a050df714959f0d5a57ac3201bd1c6594984 ]

In the bpf_l4_csum_replace helper, the BPF_F_PSEUDO_HDR flag should only
be set if the modified header field is part of the pseudo-header.

If you modify for example the UDP ports and pass BPF_F_PSEUDO_HDR,
inet_proto_csum_replace4 will update skb->csum even though it shouldn't
(the port and the UDP checksum updates null each other).

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/5126ef84ba75425b689482cbc98bffe75e5d8ab0.1744102490.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: ead7f9b8de65 ("bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fd404729b1154..bceb1950ec204 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2051,7 +2051,7 @@ union bpf_attr {
  * 		untouched (unless **BPF_F_MARK_ENFORCE** is added as well), and
  * 		for updates resulting in a null checksum the value is set to
  * 		**CSUM_MANGLED_0** instead. Flag **BPF_F_PSEUDO_HDR** indicates
- * 		the checksum is to be computed against a pseudo-header.
+ * 		that the modified header field is part of the pseudo-header.
  *
  * 		This helper works in combination with **bpf_csum_diff**\ (),
  * 		which does not update the checksum in-place, but offers more
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fd404729b1154..bceb1950ec204 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2051,7 +2051,7 @@ union bpf_attr {
  * 		untouched (unless **BPF_F_MARK_ENFORCE** is added as well), and
  * 		for updates resulting in a null checksum the value is set to
  * 		**CSUM_MANGLED_0** instead. Flag **BPF_F_PSEUDO_HDR** indicates
- * 		the checksum is to be computed against a pseudo-header.
+ * 		that the modified header field is part of the pseudo-header.
  *
  * 		This helper works in combination with **bpf_csum_diff**\ (),
  * 		which does not update the checksum in-place, but offers more
-- 
2.39.5



