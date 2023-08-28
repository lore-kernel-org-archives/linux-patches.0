Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC5D11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4470CC433C7;
	Mon, 28 Aug 2023 10:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218457;
	bh=cwOz45leAZMmWcSEh9Hd4p4uOz2dQa6colaYi56PqZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGDFUfwwoLuWEORYEPH1OhKFs5lBRHDgmaXUuCrqqkd1AXaaMS0F+MUFvbVyVWe+k
	 xD6OdlnwfsBeMZNaRG/vjrCLGfI136v0xkz04eubgWeyiCUzvD8Pu7XefEl9p5+7AD
	 ehw/1hPO1kRj0DCyk9OynSQKDAek5GKOQwHtV1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/129] powerpc: Fail build if using recordmcount with binutils v2.37
Date: Mon, 28 Aug 2023 12:13:09 +0200
Message-ID: <20230828101156.813408282@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 25ea739ea1d4d3de41acc4f4eb2d1a97eee0eb75 ]

binutils v2.37 drops unused section symbols, which prevents recordmcount
from capturing mcount locations in sections that have no non-weak
symbols. This results in a build failure with a message such as:
	Cannot find symbol for section 12: .text.perf_callchain_kernel.
	kernel/events/callchain.o: failed

The change to binutils was reverted for v2.38, so this behavior is
specific to binutils v2.37:
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=c09c8b42021180eee9495bd50d8b35e683d3901b

Objtool is able to cope with such sections, so this issue is specific to
recordmcount.

Fail the build and print a warning if binutils v2.37 is detected and if
we are using recordmcount.

Cc: stable@vger.kernel.org
Suggested-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230530061436.56925-1-naveen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 2fad158173485..daddada1a3902 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -439,3 +439,11 @@ checkbin:
 		echo -n '*** Please use a different binutils version.' ; \
 		false ; \
 	fi
+	@if test "x${CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT}" = "xy" -a \
+		"x${CONFIG_LD_IS_BFD}" = "xy" -a \
+		"${CONFIG_LD_VERSION}" = "23700" ; then \
+		echo -n '*** binutils 2.37 drops unused section symbols, which recordmcount ' ; \
+		echo 'is unable to handle.' ; \
+		echo '*** Please use a different binutils version.' ; \
+		false ; \
+	fi
-- 
2.40.1



