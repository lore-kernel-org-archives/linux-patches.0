Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C611DDCE;
	Tue, 16 Jul 2024 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146090; cv=none; b=SqZvgU98j26gnlwUv2WiCtuGnzCFd5TUI/wLrJZPC2svDNIF7Ug6bjl7+EeZuZ42oG1sbzIPQAXY0IjJrAD9Ge+6OGS6c9eIIwwN/XTRM8JzCW1LEcRH00TqdloyexiwMCqAbF9jIsX462zyl63ftr8q6x1CeAINUUJ0IH3eMIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146090; c=relaxed/simple;
	bh=wgk+j4U8P31Ia0nOCWu6kVu/ZbsZJDAdMZzhu0FKulM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE3680Hhi1E7bglHlHhs9OQZjQ8lQBL+Lx9soOl2BlqE8OPdFZ3TIgsl7k1Lcg4ZeQMXys+fyPUc1fZvYyf6EurhXFaPaIIsCEA2VGFonsoQLtPz5NuRUeA6UAyKu+JuutjY3fZyxH5XrK+k5b6FxyZ5x6B19ktXLXU3YVOoAGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFZI1FcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFZI1FcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD60CC116B1;
	Tue, 16 Jul 2024 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146090;
	bh=wgk+j4U8P31Ia0nOCWu6kVu/ZbsZJDAdMZzhu0FKulM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFZI1FcC4+0prd7Ohx4e/x0R8d2Z1+rKurlqhM+4ZXvbLU5OcIb/ur4LVOz6QEfXZ
	 6vbCio9UbQUkcc3TnFXmxwd26JmGCbYI85CQKEAvWebVmQTfn9dauQw4cGwOyCHxKn
	 YWAtpQ696OoJljJ77+DgwUWlXMU5LCtSIPHSYG+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/144] bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD
Date: Tue, 16 Jul 2024 17:31:36 +0200
Message-ID: <20240716152753.583666396@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e4aa9996a5501..b8e68a17f3f1b 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -101,6 +101,7 @@ enum bpf_enum_value_kind {
 	case 2: val = *(const unsigned short *)p; break;		      \
 	case 4: val = *(const unsigned int *)p; break;			      \
 	case 8: val = *(const unsigned long long *)p; break;		      \
+	default: val = 0; break;					      \
 	}								      \
 	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
 	if (__CORE_RELO(s, field, SIGNED))				      \
-- 
2.43.0



