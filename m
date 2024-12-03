Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1081F130E;
	Tue,  3 Dec 2024 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238241; cv=none; b=OD/OpetPLWUsOb8O6a5J+IEmEjFGdgULggJ4CBbZjDepIAOoNthyuZWA71oLuKPA3lyl0XFmRlTWm1QR9p/1JOMd2KSl7CYvBpIdP/gx9uzErtVy1Le8rXTI+CLVUq334QdSmkrh6+tFg0rDUBBcbNj3uA1Dz/0z/KkJ+ckS3HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238241; c=relaxed/simple;
	bh=Xz8aWCWxwblNrrGWRoqxpjrQ7gjC+r8xroB0hQXyebo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgBs56BCvOV3j9Dh+I/miL4J5ih5ndXAbmfx5GyORkj0f7n5V+A4o1O1GWMyNgmCAZp/8IdNLCTkIK6g8/dpa2qkjMB1jqkEuNJPuYTS2nr2p0dx6UCeVFInGVXGgF9+8DwZ0wg3ai/FrNAonfoAUMNWsiAEgJldx02tqbCG/i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOCRNAsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOCRNAsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DC7C4CECF;
	Tue,  3 Dec 2024 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238241;
	bh=Xz8aWCWxwblNrrGWRoqxpjrQ7gjC+r8xroB0hQXyebo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOCRNAsdGsPetOuKJ9PV4/Sq+YErL8J6/eYxO8ogwWko6WT0Mrly/EUr4V0UK6H9B
	 zUCejRw054a0FwYUEZH3qsOm+7n1QSPmT/9jotVJY9OOvrP4DkxG5q4I9+13Q0nRSw
	 n0ZVDfHfoMlcNygoQgUd2471NuBTsYPkVggOMaPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 203/817] selftests/resctrl: Protect against array overrun during iMC config parsing
Date: Tue,  3 Dec 2024 15:36:15 +0100
Message-ID: <20241203144003.669334514@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 48ed4e799e8fbebae838dca404a8527763d41191 ]

The MBM and MBA tests need to discover the event and umask with which to
configure the performance event used to measure read memory bandwidth.
This is done by parsing the
/sys/bus/event_source/devices/uncore_imc_<imc instance>/events/cas_count_read
file for each iMC instance that contains the formatted
output: "event=<event>,umask=<umask>"

Parsing of cas_count_read contents is done by initializing an array of
MAX_TOKENS elements with tokens (deliminated by "=,") from this file.
Remove the unnecessary append of a delimiter to the string needing to be
parsed. Per the strtok() man page: "delimiter bytes at the start or end of
the string are ignored". This has no impact on the token placement within
the array.

After initialization, the actual event and umask is determined by
parsing the tokens directly following the "event" and "umask" tokens
respectively.

Iterating through the array up to index "i < MAX_TOKENS" but then
accessing index "i + 1" risks array overrun during the final iteration.
Avoid array overrun by ensuring that the index used within for
loop will always be valid.

Fixes: 1d3f08687d76 ("selftests/resctrl: Read memory bandwidth from perf IMC counter and from resctrl file system")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 8c275f6b4dd77..f118f659e8960 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -83,13 +83,12 @@ void get_event_and_umask(char *cas_count_cfg, int count, bool op)
 	char *token[MAX_TOKENS];
 	int i = 0;
 
-	strcat(cas_count_cfg, ",");
 	token[0] = strtok(cas_count_cfg, "=,");
 
 	for (i = 1; i < MAX_TOKENS; i++)
 		token[i] = strtok(NULL, "=,");
 
-	for (i = 0; i < MAX_TOKENS; i++) {
+	for (i = 0; i < MAX_TOKENS - 1; i++) {
 		if (!token[i])
 			break;
 		if (strcmp(token[i], "event") == 0) {
-- 
2.43.0



