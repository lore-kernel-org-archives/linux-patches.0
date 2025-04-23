Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA219DF4C;
	Wed, 23 Apr 2025 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420150; cv=none; b=RbFybxucr5hGDrnWz/rBQ/FT7QR94RaG6FeBn5UbeT2VuoZsC83R5Ce9KCusnRpUPP4iNks7fR+V5eeDEMOMlD696o8CchjX2/sDmRxZ0rkAGN+YW5pgPl6HOWLmtefRfoScnKQihyRHt1WETllrnEPunlg9a3bLFbsvvPO4H/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420150; c=relaxed/simple;
	bh=hhP14TKCZ8V8oi8nwDl66JIAMfKJLqalxIuQoMEV5yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUn87HphbBcuUmvqUoVPqJW4/l2HM+j984muusceOWtO0s6glycDXQjn3fvJcbrvb58YMRuorS+gvAV+XH8/V2cfcv6ulsxb0NpJKzBANMMiAMivYvglKzqpOfEatWY6VNuLEvRg+KIDkjuVP5IpqdzX0zD6WH54LjsKup3UOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu/eRtJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu/eRtJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0109C4CEE2;
	Wed, 23 Apr 2025 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420150;
	bh=hhP14TKCZ8V8oi8nwDl66JIAMfKJLqalxIuQoMEV5yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xu/eRtJOfcW1jnF3ECvMuWlgaVxpN0MWnMseobqivlRY8XTfD2tHcUDAwzQDiSvwR
	 RyZWUGEm03aK+FgBwXvhFW6CziTMMcRgZg6/gTKwke5cvebezaQPPk8umgfbKAnWLt
	 uEgfd9+zsQMgUoWCtqEqHHvsZzsUVvsSgeGzgcmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/291] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Wed, 23 Apr 2025 16:40:10 +0200
Message-ID: <20250423142625.268700991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 208baa3ec9043a664d9acfb8174b332e6b17fb69 ]

If malloc returns NULL due to low memory, 'config' pointer can be NULL.
Add a check to prevent NULL dereference.

Link: https://lore.kernel.org/r/20250219122715.3892223-1-quic_zhonhan@quicinc.com
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/bench/parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index e63dc11fa3a53..48e25be6e1635 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -120,6 +120,10 @@ FILE *prepare_output(const char *dirname)
 struct config *prepare_default_config()
 {
 	struct config *config = malloc(sizeof(struct config));
+	if (!config) {
+		perror("malloc");
+		return NULL;
+	}
 
 	dprintf("loading defaults\n");
 
-- 
2.39.5



