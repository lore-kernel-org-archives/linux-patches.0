Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A624A3BED24;
	Tue, 21 Jul 2026 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654143; cv=none; b=sd0UhBOjisi245NuRoe2b+5pYg29R+cAXA1kAe/P+RCDojOWqFIcrvgBwBrnF9Waedbn+PwGBAHJhpXFScUqGWLH8EpuQavJuw2TBPYQQNy7pUGsOnWRY7tuD7pZNKN8FbWkaZX29yT8QHNsoPBGVUfgAwrOJ2dwTx5ezgMG/5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654143; c=relaxed/simple;
	bh=vhGXIFXyTCeVlV/ICz2m5lmYXWh4IvmgzbTd1NmGOqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGBuluOZpsBPvYPhpPgIJZtFHveJ4o1E0uSe5enY/DZ6PsZhPwq4+bpJ+1sIjsw2UHl6lTqE4vOwPS6kozIb8SqvDWmTEHYLpmdmyUTZQ3LSNKTmmt3ALU/bXcQhm/K5NymmYg2NP4+Jb+gHsMIkba5QyF44kzhePgsc5Jq2fdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS8JZNeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS8JZNeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3DA1F000E9;
	Tue, 21 Jul 2026 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654142;
	bh=QIfH4nXtzfdkwjgMIWPCjZP/YiPlsXSZlDS14SEOvKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JS8JZNehff/eZyL+uVHkqG1cVJlZVP34bhBQBeHznWSeg6OhQph9zIsr+6/bA8sPr
	 UIdKwsOOdBmojfm11W+1fjVn3s8AOaAYSYAZXmBm7pm5geCrScCMNVy9Gbl6mHXeC+
	 U18mtogMkZ1CdyaH2h2gGKLI5k8/1BXx7TDZniDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1593/2077] ASoC: SOF: topology: fix memory leak in snd_sof_load_topology
Date: Tue, 21 Jul 2026 17:21:06 +0200
Message-ID: <20260721152630.345356399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit d46f9f23897261da53ffbeb89d48a13982ba7d28 upstream.

When the topology filename contains "dummy" and tplg_cnt is 0, the
function returns -EINVAL directly without freeing the tplg_files
allocated by kcalloc() at line 2497. This leaks memory on every
such topology load attempt.

Fix this by setting ret = -EINVAL and jumping to the out: label,
which already handles the kfree(tplg_files) cleanup.

Fixes: 99c159279c6d ("ASoC: SOF: don't check the existence of dummy topology")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/tencent_3EED6D778DC52C3703A2D1EE8119372E8E08@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/topology.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2537,6 +2537,8 @@ int snd_sof_load_topology(struct snd_soc
 		if (strstr(file, "dummy")) {
 			dev_err(scomp->dev,
 				"Function topology is required, please upgrade sof-firmware\n");
+
+			kfree(tplg_files);
 			return -EINVAL;
 		}
 		tplg_files[0] = file;


