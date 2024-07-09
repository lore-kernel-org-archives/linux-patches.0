Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3F915885E;
	Tue,  9 Jul 2024 11:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524184; cv=none; b=oijIW3+SNFoh/XHgV1vs5b0j2KwFgcsvRS9XP+5deZAbPGVxxVFHy055d6eVbUECsHJXkqWJ4Y4+HF1Zjn1NF0cL5K09Md3SsBr7nAtGQzZXdRBZwkxWNxz0Qt0/RfBNm5IE4Voh/jIotxQuQqJ15K/1NiZgXK7/uNmdZVesL8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524184; c=relaxed/simple;
	bh=TcEwv1Y7rSGe60z2qnNaYn5jPR2hkOzhKS27bJKwpSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXtYgvMS+oA4uXiHNljtwNLP6xZCo2VGAsKDNS7vXJaL0OQLctxBTuSEFZG2sSV/u3yb5731KwSOG4oee6NHTezAxA+UeZstc2ITIxOsKlXF2LdFVziJ3WFT0S1UInPvnLgPOhQaHgpWQ1BLATGaKKGXNtQg8wa/DT/aGPr6dis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Psd5Bevp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Psd5Bevp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA75C3277B;
	Tue,  9 Jul 2024 11:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524184;
	bh=TcEwv1Y7rSGe60z2qnNaYn5jPR2hkOzhKS27bJKwpSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Psd5Bevpw/TlzYqMITQZN9A2JHgu5PZvrLPcDz7gT80zmKqgFLa+gYAseXdrewq8G
	 6TgpDcu6NCrS08PqO98qk/8yaznZx3EfG+cPcRACaT897DWBOpjg0S/GUoRWDxbGBx
	 W2C34c+3ajbMUQ+cK8sa4WvNk7nVb8Z2t7BE3KZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 067/197] bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD
Date: Tue,  9 Jul 2024 13:08:41 +0200
Message-ID: <20240709110711.554745244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose E. Marchesi <jose.marchesi@oracle.com>

[ Upstream commit 009367099eb61a4fc2af44d4eb06b6b4de7de6db ]

[Changes from V1:
 - Use a default branch in the switch statement to initialize `val'.]

GCC warns that `val' may be used uninitialized in the
BPF_CRE_READ_BITFIELD macro, defined in bpf_core_read.h as:

	[...]
	unsigned long long val;						      \
	[...]								      \
	switch (__CORE_RELO(s, field, BYTE_SIZE)) {			      \
	case 1: val = *(const unsigned char *)p; break;			      \
	case 2: val = *(const unsigned short *)p; break;		      \
	case 4: val = *(const unsigned int *)p; break;			      \
	case 8: val = *(const unsigned long long *)p; break;		      \
        }       							      \
	[...]
	val;								      \
	}								      \

This patch adds a default entry in the switch statement that sets
`val' to zero in order to avoid the warning, and random values to be
used in case __builtin_preserve_field_info returns unexpected values
for BPF_FIELD_BYTE_SIZE.

Tested in bpf-next master.
No regressions.

Signed-off-by: Jose E. Marchesi <jose.marchesi@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240508101313.16662-1-jose.marchesi@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 1ce738d91685a..670726353aa50 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -104,6 +104,7 @@ enum bpf_enum_value_kind {
 	case 2: val = *(const unsigned short *)p; break;		      \
 	case 4: val = *(const unsigned int *)p; break;			      \
 	case 8: val = *(const unsigned long long *)p; break;		      \
+	default: val = 0; break;					      \
 	}								      \
 	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
 	if (__CORE_RELO(s, field, SIGNED))				      \
-- 
2.43.0



