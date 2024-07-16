Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6A019FA6C;
	Tue, 16 Jul 2024 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144532; cv=none; b=mm8KIXHvsdSJhS8vgtTTjwAoa9tHfl00kSruILAS1Zeibpg4ZxwrleBsGlgtdrS79ByUAc/CGTTV+WEf+5F0mi5a/pWklSpKEDoLEmtB46zt6Bcyz8sSjWJaX+FkicIeuPaVKbhvWjXuSSaDu/TfKVYqSBwIfAAm3UQVfb2h0yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144532; c=relaxed/simple;
	bh=lxlqlOfrI8DPPAGMpDE3VD9AM6iyTSKPEjVOXBa2V+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyFsTPK2f+StfUpbVFzxJYh2ihzzdxjLj/Y4OUE9v0P0rgk5d5B37L0x+AKW5mDheGC9aMnqERM0jU+1IMatKgDCtFmOQAVPhLNo3Qjq8l8gItOQ6H6KhcfKJ7vpw0+tGY2j9Un9xrNADxDSe/w6dsv/ds8jUC3LfxhYaU5eFuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+igSQv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+igSQv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BEBC4AF0D;
	Tue, 16 Jul 2024 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144532;
	bh=lxlqlOfrI8DPPAGMpDE3VD9AM6iyTSKPEjVOXBa2V+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+igSQv03UbJXujevzAHpEpQaQw7F12CvxGhCMsPDHoYogCviaLRyeGd+3LxzF3A+
	 GyQZ4yb7D+CJdfzn6L4kmc9saPbFfmwbWe+5YzmlkJFzd8h+gPUIBmZwtaYO7uuWXY
	 QWAgh/IEqTIIvjctdq8RwCMER7a+yuWcQk45qRc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/108] bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD
Date: Tue, 16 Jul 2024 17:30:39 +0200
Message-ID: <20240716152746.931327629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f05cfc082915d..4303b31498d81 100644
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



