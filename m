Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778D32FA3F;
	Wed,  3 Dec 2025 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777584; cv=none; b=UOrpiZAw1jlEX9PTLZfspAt8SK5a/RXdmYaM7QRbfrxyyRyy0v25kFOlSMd8WBWoLF+SyBO0ZI1BW2a4NrXeD+0hAsVTMvza9dYG8orsJlAHOx8I6sTkcH94zOwFiom2XKWKD+uHCAK306idSY3k7WoeADekG4HIyfvOkMZRDwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777584; c=relaxed/simple;
	bh=W7hZ7iCicWUJ9soqv0rKm2GmieddqGRmxTEAOacEyEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvsPJzeAxmBrCsmL2bm9BSU2UVC0inHhHUEqYuxD8zE/qzWmad7m+fUTv8DG7qDIr7Jns6Q3ljSJJ1PiiSUrikWAZJsGWnuyOcGXtjCxXdZ0UNlnuvYWwZeCzfLHJ877ZaXANHnHLjLDv3RxXqk0jRu5DOodMsrxlPLBTiraens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zincj66p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zincj66p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD39C4CEF5;
	Wed,  3 Dec 2025 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777584;
	bh=W7hZ7iCicWUJ9soqv0rKm2GmieddqGRmxTEAOacEyEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zincj66pns/AsQAf8XkPfZVZ1dZhP5b95VLUARp7mGg1uRZLFqaIOLfbaGcIS0QUz
	 aHpR3usayX4oijbuhVnRwqt4TtMskg6hsU5383Rbu3F7m2ubnoPNMBJVHYxfqZmYMb
	 Fx0J9zXJbi9GV+skHAgMrZT5qt7WjSoIh3cZn1wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/392] tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage
Date: Wed,  3 Dec 2025 16:23:53 +0100
Message-ID: <20251203152417.157294242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 62127655b7ab7b8c2997041aca48a81bf5c6da0c ]

The fopen_or_die() function was previously hardcoded
to open files in read-only mode ("r"), ignoring the
mode parameter passed to it. This patch corrects
fopen_or_die() to use the provided mode argument,
allowing for flexible file access as intended.

Additionally, the call to fopen_or_die() in
err_on_hypervisor() incorrectly used the mode
"ro", which is not a valid fopen mode. This is
fixed to use the correct "r" mode.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index ebda9c366b2ba..c883f211dbcc9 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -630,7 +630,7 @@ void cmdline(int argc, char **argv)
  */
 FILE *fopen_or_die(const char *path, const char *mode)
 {
-	FILE *filep = fopen(path, "r");
+	FILE *filep = fopen(path, mode);
 
 	if (!filep)
 		err(1, "%s: open failed", path);
@@ -644,7 +644,7 @@ void err_on_hypervisor(void)
 	char *buffer;
 
 	/* On VMs /proc/cpuinfo contains a "flags" entry for hypervisor */
-	cpuinfo = fopen_or_die("/proc/cpuinfo", "ro");
+	cpuinfo = fopen_or_die("/proc/cpuinfo", "r");
 
 	buffer = malloc(4096);
 	if (!buffer) {
-- 
2.51.0



