Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A68336405A;
	Wed, 20 May 2026 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299691; cv=none; b=Ov5Wfu+8d1vWKTKUWaJDsE6zy3e3aT5+s1FJ6VJYC3wV2FVaiK7be3qWSNUHzImW3O5D3AurxI1tKzC3gtUvoMYsvHFvk++1ZeUSdGXQWH5u8D38vmGJeTXFf0GHlxds1GjutAfirmD7X7G3IRydVC/+ZC3hU4gj9YKVF7Ff6ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299691; c=relaxed/simple;
	bh=lS+52D/hZ7gS8ZD3LxW5PoRnEDOiu9iYrXiOpwhMWB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzE2sMOi2Z/TuJwKZVNAv1AsgcI3gMU7S6MVEjUljJLZyQ1TARvDYRUPonS7gLt8kB5PmQa3LNK5cIvLd7BKhWNWc9Y6wLGTOFPPIIOIVjWPII7zCvA37G2ZIRqolzmckjQdMX9Ug78yLKBdct9BovnKJzodM7vUB9GYhy2G3rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5e2JynV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5e2JynV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C241F000E9;
	Wed, 20 May 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299690;
	bh=AFq1xrGLYTOLAld3gm+S1YCaZZaTPcHj4Hv++jn/q2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5e2JynVgoz4VMvfDQUmk4deTbOV5OHa4hz1sEuMUlZn3ORpHRaFTZpL5wQGEyZMA
	 p+gcNGMf9lnbUqyHpGzBUvRZF+PeurWW/0AnXcZstLqbC80hILt5kOwKjlz1B3fDzB
	 8Xv/XuSPNQicLekFKuXtOsakTonJmXbhjnxQ5obs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Costa Shulyupin <costa.shul@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 868/957] rtla: Fix parse_cpu_set() bug introduced by strtoi()
Date: Wed, 20 May 2026 18:22:31 +0200
Message-ID: <20260520162153.391842750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Costa Shulyupin <costa.shul@redhat.com>

[ Upstream commit 6ea8a206108fe8b5940c2797afc54ae9f5a7bbdd ]

The patch 'Replace atoi() with a robust strtoi()' introduced a bug
in parse_cpu_set(), which relies on partial parsing of the input string.

The function parses CPU specifications like '0-3,5' by incrementing
a pointer through the string. strtoi() rejects strings with trailing
characters, causing parse_cpu_set() to fail on any CPU list with
multiple entries.

Restore the original use of atoi() in parse_cpu_set().

Fixes: 7e9dfccf8f11 ("rtla: Replace atoi() with a robust strtoi()")
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20260112192642.212848-2-costa.shul@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index bf20077cca742..b4cd93f784522 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -113,18 +113,16 @@ int parse_cpu_set(char *cpu_list, cpu_set_t *set)
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
 	for (p = cpu_list; *p; ) {
-		if (strtoi(p, &cpu))
-			goto err;
-		if (cpu < 0 || cpu >= nr_cpus)
+		cpu = atoi(p);
+		if (cpu < 0 || (!cpu && *p != '0') || cpu >= nr_cpus)
 			goto err;
 
 		while (isdigit(*p))
 			p++;
 		if (*p == '-') {
 			p++;
-			if (strtoi(p, &end_cpu))
-				goto err;
-			if (end_cpu < cpu || end_cpu >= nr_cpus)
+			end_cpu = atoi(p);
+			if (end_cpu < cpu || (!end_cpu && *p != '0') || end_cpu >= nr_cpus)
 				goto err;
 			while (isdigit(*p))
 				p++;
-- 
2.53.0



