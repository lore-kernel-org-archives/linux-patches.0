Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34DD2EAE5;
	Thu, 11 Apr 2024 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829914; cv=none; b=XO+wRQRmWebbQOkTRpjwrhA6kV5F1n5+llRIGec+NMYiorz8nZlVT3H4SHcR0byrm/RJSWNvLUrcao+4TD0hlvuzR7u7ufu6lE8bNcWBHcBDwIUg0bX4KtIRNCPAeT+lLqQXXVJgQntFpyI4R9o6m5yxuYY2ajDgydBkYXl+99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829914; c=relaxed/simple;
	bh=Gg9PHJ+fWFWQilwsnPo5ZntFewBAVjOyUAZQOabBPGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd9au1dLbbgVaVmwYJi60m1HGwn7SFX52IRWvqvebgP4fS/5LyAoHEiCNjrK3vns9aK7BBYK+/wUxwFuSGtic81oqv9uwwmUlXlEMW8+iThFEhT9DjIKrdtyQVcZaYhQvcxZvNDQ4m6mXoHH91eNImUhHnJVO1GdUFseWSLnnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5rvHgjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5rvHgjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F74C433C7;
	Thu, 11 Apr 2024 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829914;
	bh=Gg9PHJ+fWFWQilwsnPo5ZntFewBAVjOyUAZQOabBPGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5rvHgjEJCFTwS9T9xHQb8sCXZo/T8pgiAPryUOaBd7JMBcPeMeiCa9CgZpv/jm5Q
	 TolaZpT7Oxh0cmCswBSB708lC8eU7ZKlr5pqWqegzTzGNsRTbO3Jfc81oGfEu4o+tC
	 pVSPjxSFAmhT5NPz4+zd42rNrzM7RdLtHRknz8os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/175] tools/power x86_energy_perf_policy: Fix file leak in get_pkg_num()
Date: Thu, 11 Apr 2024 11:56:11 +0200
Message-ID: <20240411095424.018194284@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit f85450f134f0b4ca7e042dc3dc89155656a2299d ]

In function get_pkg_num() if fopen_or_die() succeeds it returns a file
pointer to be used. But fclose() is never called before returning from
the function.

Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 2aba622d1c5aa..470d03e143422 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1112,6 +1112,7 @@ unsigned int get_pkg_num(int cpu)
 	retval = fscanf(fp, "%d\n", &pkg);
 	if (retval != 1)
 		errx(1, "%s: failed to parse", pathname);
+	fclose(fp);
 	return pkg;
 }
 
-- 
2.43.0



