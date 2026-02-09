Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438292BCF4C;
	Mon,  9 Feb 2026 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648524; cv=none; b=jJHWlVVLQMdLPbz6jF9VjBRkO5y1I1q1EYlQoK52apewLewOykvtYFq3qcG4oiI2O+kLCSYU4nnIiU8Zwafg95xODyYlTSoIUubNZIfHWN+Vs8dBc4/5rR9w1w4vkcTyioNL08gi8kW9jyRdQLzBDECWs7pBXOI/eOMQs4y8F4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648524; c=relaxed/simple;
	bh=rx9O9ukT7BuvYP8bydQy+XaXFmeezWVMO9quo2PfFiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drP5J6E3c4bzNjenuz/ax1yRA8ymV/hnu3ak2456+/8f7pJkzMUOOUeOGCBUrGZOS3mWkiLMHdNE6G0wdSTcHGOxgcdbh2vRyLPWAh9uz+qm01P/kXjlzG3uXcX50oGII1egSDzROnbaPiAEJW+CFeUyoOjy59awNWWixZ7IZO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXw3/33Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXw3/33Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D3DC116C6;
	Mon,  9 Feb 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648524;
	bh=rx9O9ukT7BuvYP8bydQy+XaXFmeezWVMO9quo2PfFiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXw3/33YYujaF1AG1ZbFyJdir8h3NUHpVTjGjQW3wHVVV9qUDj8rSO6yV7Hg+Ssvv
	 beUxbb3KMEZE/IxlTmpKtrMQJEk9toPS5nVjUPY4XXkhHZ3TL3CAg9R5Z4Fl9I9+HE
	 RhJpVq7Fqwc11IKcI9/SaYf5iERGtSs1UrwOkwRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiquan Li <zhiquan_li@163.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/86] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures
Date: Mon,  9 Feb 2026 15:23:42 +0100
Message-ID: <20260209142305.469047383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiquan Li <zhiquan_li@163.com>

[ Upstream commit e396a74222654486d6ab45dca5d0c54c408b8b91 ]

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
[ Makefile.kvm -> Makefile ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -212,6 +212,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD\
+	-U_FORTIFY_SOURCE \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \


