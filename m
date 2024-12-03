Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23537646;
	Tue,  3 Dec 2024 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238978; cv=none; b=JDgzW8BS16a5cPBDMOLMI05jbU2WH7bIr8QA880T7teemImKqfwRmur/W5d4lDrMeU422xgOfaDnJ0AMd8lhFlSwGHgHLtBlOORHh9ReJ0h4F4J17RaMR/mWKGaICJTmb7Ne1OdCnIAHvkfLAhaa2PyrrCjC2TwuQuZoX3AJnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238978; c=relaxed/simple;
	bh=6StEq2IYly367fzpQMcTFrnX1/Q0miHZ51VhaHq9BUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrk4NaW7pJwc+oVsxi2b2Ql0AD5wNGf6+3gHmQuiVJ6DDBNJbm0uKa1F7cwAFwV/J1HG40iQzEQ2T7AY/wm18I/o+0otTP1ysMTRMmlYUzuQBQqc5rEj46nr8eW9A4skvUc4X/gN7eMVm04pQDzfESqaMwRPjSJRjQHLHEZ7Aq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5+uAp6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5+uAp6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7CAC4CECF;
	Tue,  3 Dec 2024 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238978;
	bh=6StEq2IYly367fzpQMcTFrnX1/Q0miHZ51VhaHq9BUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5+uAp6/J+vkr9gNmYjSwr4H43h91+k0DQTO158JpFC/ZK9ME0tk865RZ42c9sQKz
	 PREOWTBhS7pzZX9e18/6SUzfbQCbMJw/zjiuSpfajMzRJgOSxtBF7xHwEygPRhzJdb
	 rHT/kwWgTcSbuxU0FMWmot4ZoBM2IWpfWaJjvE6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 462/817] powerpc/kexec: Fix return of uninitialized variable
Date: Tue,  3 Dec 2024 15:40:34 +0100
Message-ID: <20241203144013.908848194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 83b5a407fbb73e6965adfb4bd0a803724bf87f96 ]

of_property_read_u64() can fail and leave the variable uninitialized,
which will then be used. Return error if reading the property failed.

Fixes: 2e6bd221d96f ("powerpc/kexec_file: Enable early kernel OPAL calls")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240930075628.125138-1-zhangzekun11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 9738adabeb1fe..dc65c13911577 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -736,13 +736,18 @@ int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
 	if (dn) {
 		u64 val;
 
-		of_property_read_u64(dn, "opal-base-address", &val);
+		ret = of_property_read_u64(dn, "opal-base-address", &val);
+		if (ret)
+			goto out;
+
 		ret = kexec_purgatory_get_set_symbol(image, "opal_base", &val,
 						     sizeof(val), false);
 		if (ret)
 			goto out;
 
-		of_property_read_u64(dn, "opal-entry-address", &val);
+		ret = of_property_read_u64(dn, "opal-entry-address", &val);
+		if (ret)
+			goto out;
 		ret = kexec_purgatory_get_set_symbol(image, "opal_entry", &val,
 						     sizeof(val), false);
 	}
-- 
2.43.0



