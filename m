Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D1B23A1B1;
	Thu, 12 Dec 2024 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022051; cv=none; b=d8cY3QqyRCjx6E4GwpZNGLU5J+NFD12c7IRTfA2T62oXRl2aHywGbAeqZdzzOwAd1D2HJaA7pQWNiIZ3P88tCKTHYKwzPZ8OwiJxKkuNRyKdAHaxXj+neKU/N5EmbYiRqomNeMKQ8y6sMVDokAKsjpssNe7NZMQmQrwcZRA/uz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022051; c=relaxed/simple;
	bh=A/UX5zLiH3aVteOcHITKDCXVOx5sJ3h+eBFfKFGe56g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSNjIzWtPJg1u5D3BnUjWZGoiSypNPBCo8pbyWI3n1eF18s+H95xVKS6+RN9O5lGYL3eY8q4+I1M98/cs0onLjY31KD+cicfM1d0vgphb6N3H76M5CIu3HXq6nz71j+LL+HcN79OtsvAA/HnRxSG0b8pdwklPrq7A8DKlQS6uSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVBH9zt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVBH9zt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884CDC4CECE;
	Thu, 12 Dec 2024 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022051;
	bh=A/UX5zLiH3aVteOcHITKDCXVOx5sJ3h+eBFfKFGe56g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVBH9zt2WDAhAtFfVdtWOvJf5G8UY4JLfIpDdwjHH/Q23r/WJJDCKYhPqwMmOwdGe
	 jETORFqbXT7wKDcjteDV2ccgu/9PZ2I9ug/LZ2aLzto0QMafdddAhYCdl5e6OcykM3
	 2akcb2ss/jwfV88dp4HBMGf7z3niMTQXjbqXTkgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/565] selftests/resctrl: Protect against array overrun during iMC config parsing
Date: Thu, 12 Dec 2024 15:55:29 +0100
Message-ID: <20241212144316.775334670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 02110e7ee6361..04cb4aab51170 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -102,13 +102,12 @@ void get_event_and_umask(char *cas_count_cfg, int count, bool op)
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



