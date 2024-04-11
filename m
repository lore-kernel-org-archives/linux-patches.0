Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FC6BB29;
	Thu, 11 Apr 2024 10:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832342; cv=none; b=r3B6rBWmp4alWzETGWINjGpv+AqEwM7fXt8AuAGj8jXswAFMXpUgo7H8jPxB4LPIw+gDy9iE0yg3epjJjuSqiI/fOl+CAAQTr1o0boonWefmKaFpLwcOciQLuaV2BPF3l+HT+31Ar7l/jaVwuSmsmso/66AZg7WYgtsuu9vAMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832342; c=relaxed/simple;
	bh=zgr+sGQpD4vQs9Lqt3wFQfl7qlumGyGjAA2KC70zhjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o79Vh9qttdjLjTQHPlC88FllsJAaCkDK0pC/DuKkwRXphj1GA1ufJuf2wbq7FV1X1tDYEjDHcNpULkFdOK18v12Y6OvK9OzKRVPfvUz8Qf/5d9ZgLFHmp12jGC7T1QHsiLkkAcSwpEzUDeCKiY7ywLrd8TiycbZee4qBy5SCd9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOKyYr6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOKyYr6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EF1C433F1;
	Thu, 11 Apr 2024 10:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832342;
	bh=zgr+sGQpD4vQs9Lqt3wFQfl7qlumGyGjAA2KC70zhjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOKyYr6aekiC/gh8Nocf5x0MyTKDReNEn6jRRry0q/f/4VtWMxj1/5eIfG5umkqge
	 BtuwusadnlfcLpG0sjHTpt9cxJkLT+5bw5ggQNfN+BZs1SBpz301dcSwcENDxgb2Ih
	 ptawHkIEku9UbgxQK1c185Kp5oSp6vJX3R12XcyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/83] tools/power x86_energy_perf_policy: Fix file leak in get_pkg_num()
Date: Thu, 11 Apr 2024 11:56:49 +0200
Message-ID: <20240411095413.196865927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5fd9e594079cf..ebda9c366b2ba 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1241,6 +1241,7 @@ unsigned int get_pkg_num(int cpu)
 	retval = fscanf(fp, "%d\n", &pkg);
 	if (retval != 1)
 		errx(1, "%s: failed to parse", pathname);
+	fclose(fp);
 	return pkg;
 }
 
-- 
2.43.0



