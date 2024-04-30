Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4824E12C462;
	Tue, 30 Apr 2024 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475117; cv=none; b=le7pVnyZBtTNSv+XwPNBnt1PGWDKO5SQeYFpBitDORDCVlffxA2L+afbX29+NcWCfx4DgfZt39NYb3JNSpbhqvn8weTi2H4qYRbH4ioQkhd3yLPci1z355Km+iC6Q+d8JBBEFvPLQIxS66UTQCprd1itfIEHXBXRFhSZ+qRH+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475117; c=relaxed/simple;
	bh=sVA3NNT+wvNg2aBO4vYLHm5zzubEhYMVFd3LDamRGA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImjyaSU5SaAXFQzN7LGM3XyWR78+V9sdc0aCRhvfCWgEJv1H0DFJKsGtNuA2+RQc7DIHkZ/tFHn639mcWlLvf20t5bvQbTnOqeaSjeHflgRQcgbFzBVjW8/zSsRERK2qYNWDlFP1q26/THD+fTwJKW8NbYbykYDcHBEvJrQqCA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjRginkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjRginkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E64C2BBFC;
	Tue, 30 Apr 2024 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475117;
	bh=sVA3NNT+wvNg2aBO4vYLHm5zzubEhYMVFd3LDamRGA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjRginknUhuVroEY/OoQ6pLPARtz7hBFwIUXb7rqqMfFAC8vdf9I5STwDWwvgb+77
	 2JIgPcuk/iZQy9YpAJbT0rBfv9JXVsVPFTbZgIMScIsqWWwUrUxXanWeYYtB+7bod8
	 JHm9KmWJR8rSURnO9DrWki7/LAPiP+pxZYIOLfxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 138/138] riscv: Disable STACKPROTECTOR_PER_TASK if GCC_PLUGIN_RANDSTRUCT is enabled
Date: Tue, 30 Apr 2024 12:40:23 +0200
Message-ID: <20240430103053.465415373@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit a18b14d8886614b3c7d290c4cfc33389822b0535 upstream.

riscv uses the value of TSK_STACK_CANARY to set
stack-protector-guard-offset. With GCC_PLUGIN_RANDSTRUCT enabled, that
value is non-deterministic, and with riscv:allmodconfig often results
in build errors such as

cc1: error: '8120' is not a valid offset in '-mstack-protector-guard-offset='

Enable STACKPROTECTOR_PER_TASK only if GCC_PLUGIN_RANDSTRUCT is disabled
to fix the problem.

Fixes: fea2fed201ee5 ("riscv: Enable per-task stack canaries")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -450,6 +450,7 @@ config CC_HAVE_STACKPROTECTOR_TLS
 
 config STACKPROTECTOR_PER_TASK
 	def_bool y
+	depends on !GCC_PLUGIN_RANDSTRUCT
 	depends on STACKPROTECTOR && CC_HAVE_STACKPROTECTOR_TLS
 
 endmenu


