Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C383EBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A2FC433EF;
	Tue,  7 Mar 2023 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215815;
	bh=9Rd0waOKcoTHm8nXq0CQ+JjvJSAFcyFasPghAfRA24Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJL7fvISXoIXMYbmsVFoxaTvUNF0IYnwN/S9bvarZhdC7Gigo2n5c+1UYeRvxNloW
	 B/0UQex+pcj2bbHDCViwv7m0TIK4/QPZNASq0knkajL11hg9RnIyB8n2clVeamczd9
	 AaJlxtaP5QeALrVaofv6Oy5l5G6MZCjPJNebrbcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Florent Revest <revest@chromium.org>,
	Len Brown <lenb@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Robert Moore <robert.moore@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Will Deacon <will@kernel.org>,
	linux-acpi@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/567] ACPI: Dont build ACPICA with -Os
Date: Tue,  7 Mar 2023 18:01:59 +0100
Message-Id: <20230307165922.457244826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8f9e0a52810dd83406c768972d022c37e7a18f1f ]

The ACPICA code has been built with '-Os' since the beginning of git
history, though there's no explanatory comment as to why.

This is unfortunate as GCC drops the alignment specificed by
'-falign-functions=N' when '-Os' is used, as reported in GCC bug 88345:

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=88345

This prevents CONFIG_FUNCTION_ALIGNMENT and
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B from having their expected effect
on the ACPICA code. This is doubly unfortunate as in subsequent patches
arm64 will depend upon CONFIG_FUNCTION_ALIGNMENT for its ftrace
implementation.

Drop the '-Os' flag when building the ACPICA code. With this removed,
the code builds cleanly and works correctly in testing so far.

I've tested this by selecting CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B=y,
building and booting a kernel using ACPI, and looking for misaligned
text symbols:

* arm64:

  Before, v6.2-rc3:
    # uname -rm
    6.2.0-rc3 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    5009

  Before, v6.2-rc3 + fixed __cold:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    919

  After:
    # uname -rm
    6.2.0-rc3-00002-g267bddc38572 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    323
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | grep acpi | wc -l
    0

* x86_64:

  Before, v6.2-rc3:
    # uname -rm
    6.2.0-rc3 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    11537

  Before, v6.2-rc3 + fixed __cold:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    2805

  After:
    # uname -rm
    6.2.0-rc3-00002-g267bddc38572 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    1357
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | grep acpi | wc -l
    0

With the patch applied, the remaining unaligned text labels are a
combination of static call trampolines and labels in assembly, which can
be dealt with in subsequent patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-acpi@vger.kernel.org
Link: https://lore.kernel.org/r/20230123134603.1064407-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 59700433a96e5..f919811156b1f 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -3,7 +3,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os -D_LINUX -DBUILDING_ACPICA
+ccflags-y			:= -D_LINUX -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
-- 
2.39.2



