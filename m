Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633096D1A0;
	Tue, 14 May 2024 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685284; cv=none; b=eRkSp0NvdhFqEvP5WClDEfddBowcpAb60WB4CD5cNpCkiFxmXxhfMJsaqzBNiNxnSEXlUi9HBiHR941n17wobtM9tI3BkI5QLy7w9EX5y8JAbU2S6R5NIo0tXFEgP1JYtBAlAtb27NcuKVwTpFFhCpnZH6mtW1IUb+TsMeUTZFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685284; c=relaxed/simple;
	bh=Tle048T71ZPlGZbeJghKXDDhfPAO6Pz6u9HgAbZzsDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqX/WDov0eSyoNGgZryKCjHxv7BA9G/IcsNgFoCUfFAaq/hrbN1Dsmh9o4emfECbHv2ET68c9aQ0rQzLqh2j60WFKLy20O1uemV2SDAIUID9M7X2otZ70GIGObl+AKPdu7bzSxqTIk8IGt2C0bA0BQPqfuSOK65xkGnXJtHcEVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2ZAuYWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2ZAuYWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B54C2BD10;
	Tue, 14 May 2024 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685284;
	bh=Tle048T71ZPlGZbeJghKXDDhfPAO6Pz6u9HgAbZzsDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2ZAuYWb3hUD6mYyyTHlhaDDtoIMJ3gNDoi/jhzSbe8Kng7agTs8YSJvjjZTrbFos
	 tTS63ZiM1LyeZaxv53KCwE5yGBzZVGWcCIZC6V/yfz6T7UsdbSQAMbULiTYGxqcXmw
	 kNyUJKD4x/n5ic9vSw8HM4qNXCn1+lWZzYUWNDDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/301] tools/power turbostat: Fix warning upon failed /dev/cpu_dma_latency read
Date: Tue, 14 May 2024 12:16:44 +0200
Message-ID: <20240514101037.269421125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit b6fe938317eed58e8c687bd5965a956e15fb5828 ]

Previously a failed read of /dev/cpu_dma_latency erroneously complained
turbostat: capget(CAP_SYS_ADMIN) failed, try "# setcap cap_sys_admin=ep ./turbostat

This went unnoticed because this file is typically visible to root,
and turbostat was typically run as root.

Going forward, when a non-root user can run turbostat...
Complain about failed read access to this file only if --debug is used.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 4dfeda4870f71..0561362301c53 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5479,7 +5479,8 @@ void print_dev_latency(void)
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		warnx("capget(CAP_SYS_ADMIN) failed, try \"# setcap cap_sys_admin=ep %s\"", progname);
+		if (debug)
+			warnx("Read %s failed", path);
 		return;
 	}
 
-- 
2.43.0



