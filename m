Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4CF155389;
	Tue,  9 Jul 2024 11:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523689; cv=none; b=C7siNIHzNS5v6CcwpEzwcF8cazUf0dGTh5KzHlrYwwF2OuQecZBPNWEeUHiRJmWGNig27U1Zqee4mQ+rRfnQtAUa5ovhEA+0l0zwP+e68EWnx3dZgyyTQGXSFDg0cSRl3yIk+ybdb+M761UlMwr6FqagQRf2jk5WcFwBxKYybcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523689; c=relaxed/simple;
	bh=8WMCBkAuhYVKoxfvQsqp0VcWROA0oTxrKKA2JuBNa6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAgv3Kf0IT7O+z/33gA6+hjaIbugY7jCUPeDlBNlE1keh/F8DarjLbu++antNCw7UMO5TUcvEv0nhU7OgTEaLpIJT7YIgiOLZktRYkYjdmgRseiQ5XXq3AmxmKAG5YHQX0Ld5UZ6OeSGhc9TqMqbltxTZdzK9u0PPZOX7SX26as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3q8ABoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3q8ABoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F1BC3277B;
	Tue,  9 Jul 2024 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523689;
	bh=8WMCBkAuhYVKoxfvQsqp0VcWROA0oTxrKKA2JuBNa6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3q8ABozilI40uD30YWQ/iPvrDEMzKFP47elLmn1niFl7xH1nM/o9YKKFnAfLhlWp
	 gBPT0ZIdbD6iX2A5gcbhBVDfSIGdcMTF2XhKv0+f8uPmubmtnqsqr60cApJ2aW/OlW
	 wQtpp60OkzEKhQK5f5iqJVZPI0o/FGvSqldrm+nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/139] bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD
Date: Tue,  9 Jul 2024 13:09:08 +0200
Message-ID: <20240709110700.025822670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ac57bb7ac55f..e2b9e8415c044 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -102,6 +102,7 @@ enum bpf_enum_value_kind {
 	case 2: val = *(const unsigned short *)p; break;		      \
 	case 4: val = *(const unsigned int *)p; break;			      \
 	case 8: val = *(const unsigned long long *)p; break;		      \
+	default: val = 0; break;					      \
 	}								      \
 	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
 	if (__CORE_RELO(s, field, SIGNED))				      \
-- 
2.43.0



