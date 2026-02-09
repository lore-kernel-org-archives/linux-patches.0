Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AF237997D;
	Mon,  9 Feb 2026 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647208; cv=none; b=lPpHHWmeToYJBQ0wrJP2FUbSOze2Nw8gZPUNmb6wRzQz5Rq7qiJ2JhuE6061Jxyo8uhHcyiZZTeSXGatr09NcE5hF8xjlo9nlKebrq9Tmhgvvxt2WIMQDZZ0fdTTWpFjhhVfgiZRSH+ajUXbiK1fYy2taixOeloG2z8K3TlHy/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647208; c=relaxed/simple;
	bh=tQMAY3LqY7ovZ5Ikb3TXG1xQozyQe0bRquQ3JxFSpq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWjt6rVJiOjdstMnuH/CQorq7mu78dJ7yajTJKWMCN81jTP6dGy/uYEkSvagm3XzjHsH9YJC8GVLHTZWNsuStjADw7TqswWU8Rn72nG6yHB3DnKPhSHlyuJPjyvFN8ulOrq0tMd+F+ZxYe6cwfvKAJQRrYnq1Qn6eA7m3He53oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNp8tA9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNp8tA9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3391C116C6;
	Mon,  9 Feb 2026 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647208;
	bh=tQMAY3LqY7ovZ5Ikb3TXG1xQozyQe0bRquQ3JxFSpq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNp8tA9T863/eCzp7FSmokxdIWxdLVuzmjAKfYwKRz9o7ZnfdDMN5L/k5JBD6bOIP
	 RQgZts6FcNiCViUwiCW73yNygre4DkFL94/JbwTnQ2LIxVgq4YM5bW4HVuSBUWG+t2
	 RdP15yoI7ht+wLvmoFu5ASyxOV3FP4xlyzxdm/DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiquan Li <zhiquan_li@163.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 032/175] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures
Date: Mon,  9 Feb 2026 15:21:45 +0100
Message-ID: <20260209142321.630936614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiquan Li <zhiquan_li@163.com>

commit e396a74222654486d6ab45dca5d0c54c408b8b91 upstream.

Some distributions (such as Ubuntu) configure GCC so that
_FORTIFY_SOURCE is automatically enabled at -O1 or above.  This results
in some fortified version of definitions of standard library functions
are included.  While linker resolves the symbols, the fortified versions
might override the definitions in lib/string_override.c and reference to
those PLT entries in GLIBC.  This is not a problem for the code in host,
but it is a disaster for the guest code.  E.g., if build and run
x86/nested_emulation_test on Ubuntu 24.04 will encounter a L1 #PF due to
memset() reference to __memset_chk@plt.

The option -fno-builtin-memset is not helpful here, because those
fortified versions are not built-in but some definitions which are
included by header, they are for different intentions.

In order to eliminate the unpredictable behaviors may vary depending on
the linker and platform, add the "-U_FORTIFY_SOURCE" into CFLAGS to
prevent from introducing the fortified definitions.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
Link: https://patch.msgid.link/20260122053551.548229-1-zhiquan_li@163.com
Fixes: 6b6f71484bf4 ("KVM: selftests: Implement memcmp(), memcpy(), and memset() for guest use")
Cc: stable@vger.kernel.org
[sean: tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/Makefile.kvm |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -245,6 +245,7 @@ LINUX_TOOL_INCLUDE = $(top_srcdir)/tools
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
+	-U_FORTIFY_SOURCE \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -fno-strict-aliasing \


