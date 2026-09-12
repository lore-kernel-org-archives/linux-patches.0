Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579702F617C;
	Sat, 12 Sep 2026 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215694; cv=none; b=rbGX2CCU3l9oYACVl9Lgph7rAKIQU53UMdIMEIQFq+wRY9eSB9NJvUlx2TpUviw3YcGZ17E8yR9BfFmMELGGe3Nr9t5srtWQbpI2UWDr6kw3gxYb817CHXigm4+ZkCM7JSTV8fOlBM7QsBAKrrI3EzpNg2wGw6lvWL3wDGgzjmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215694; c=relaxed/simple;
	bh=zvhHQWsMxRdchbOdcfImlvn3BvJOo3h+nx0ULdATdcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT4+xyQg0QFQY14cPora2q9+k4FPuDWvprd9emWRaX+sYeu3rSHMY+O7FOz4Ihf4KO3v9ngX4FiDVLxhH9QqQF6NWY50LYcBlnBphrOoYp9uTPX7nyyErW4pmtrWvr43iU5spTZqy9Xi3o0osdAJWvdDNjUhkMjNKYsO7ojDhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BK3ZtjDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BK3ZtjDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5021F000FF;
	Sat, 12 Sep 2026 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215693;
	bh=wtXRUdsLtxzeVLyRbjYeClenjTNWoSVJd15+kiBw+w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BK3ZtjDoQfD3kv90d6fpx84g85G0uHajyePRu5R4/UHzuW/eKJCoWG8zLHdXo2N4F
	 KH6S41AIikseC6LH3uQr9ah8iB5ubBgzSJ0haM6tFYruMOfIs2IlqC2ORRCjbQk/xH
	 E25PeOcOHyyLW6GjMSDnXtDXtwTkASfdv3xYDYKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0584/1376] cacheinfo: dont propagate DT/ACPI error when arch supplies info (arm64)
Date: Sat, 12 Sep 2026 08:50:10 +0200
Message-ID: <20260912065620.547969410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 274259391c14166fcabae74f9fc0104223ff27a1 ]

cache_setup_properties() sets use_arch_info = true when DT/ACPI
provide no cache nodes and the arch can derive the topology from
CPU registers (e.g. arm64 reading CLIDR_EL1), but still returns the
original -ENOENT. cache_shared_cpu_map_setup() bails on that error
before the new flag can take effect, so the first CPU brought online
always trips a misleading warning:

  cacheinfo: Unable to detect cache hierarchy for CPU 0

Subsequent CPUs skip cache_setup_properties() entirely because
use_arch_info is now true, which is why only CPU0 hits it. This is
reproducible on arm64 with the QEMU 'virt' machine, whose default DT
has no cache nodes.

Clear ret after setting use_arch_info so the caller proceeds and
populates the shared cpu map via the arch-supplied leaves.

Fixes: ef9f643a9f8b ("cacheinfo: Add use_arch[|_cache]_info field/function")
Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260611-cacheinfo-v2-1-6069ef066cf3@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 89410127089b9..2af13612a40ab 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -332,9 +332,14 @@ static int cache_setup_properties(unsigned int cpu)
 	else if (!acpi_disabled)
 		ret = cache_setup_acpi(cpu);
 
-	// Assume there is no cache information available in DT/ACPI from now.
-	if (ret && use_arch_cache_info())
+	/*
+	 * No DT/ACPI cache nodes; fall back to arch-derived topology (e.g.
+	 * arm64 CLIDR_EL1) and clear the error to avoid a spurious warning.
+	 */
+	if (ret && use_arch_cache_info()) {
 		use_arch_info = true;
+		ret = 0;
+	}
 
 	return ret;
 }
-- 
2.53.0



