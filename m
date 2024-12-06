Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A653A7;
	Fri,  6 Dec 2024 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498430; cv=none; b=GPYElvODQvsOxYwXHuDPxtjLc+UoMqmLV3LdaTNhUn93BfuLLnEUla1P3zSqYG9rkT6BChDqBCjm+Zmpp1LTpAZ5mJlDdKCpkiRyPV7yT3RC9JQzAWAJpey0wAYdku1twOn7i/aZaSYsHv2Kw2K/SNG9yleYVr1kwgcTOxhJ170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498430; c=relaxed/simple;
	bh=3XzMYFM2rCZOARDJYIa0hEpx8y/DRVxkG0z2BzjxLsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmBN/pypGdQoyV+LTeC74sN0Dv+9kh9rLg8UK1qnLeVDkK6ywlqC30S+ErILxMpNA0p8kTAWRZ1EW2g6p86qxW9rqDYNwlF29lXjdyhqXXNwEIQS1vjfHg+t8kEe/msMTTGjLtvekrZksG/WqZ4LYesjWtDD4qeWgAi52ku416U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFVya6DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFVya6DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A9C4CED1;
	Fri,  6 Dec 2024 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498429;
	bh=3XzMYFM2rCZOARDJYIa0hEpx8y/DRVxkG0z2BzjxLsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFVya6DITLviLHNV/ufyGmMPKSrVXE1fD4xdGWSfslcujtCzB1FrQVBXXOhLDny2g
	 kfZcKZosChYHSKR8uoJRR6V3xiMcYH8sHIea7zBlXe4aQfhlQ1jF2alHKRrlJfY2lM
	 kKU+IX2hhW9r73EC7eTGM5Q+iqCkW9b/1so0HIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 581/676] modpost: disallow *driver to reference .meminit* sections
Date: Fri,  6 Dec 2024 15:36:40 +0100
Message-ID: <20241206143716.055412668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 50cccec15c48814765895891ca0d95d989b6a419 ]

Drivers must not reference .meminit* sections, which are discarded
when CONFIG_MEMORY_HOTPLUG=n.

The reason for whitelisting "*driver" in the section mismatch check
was to allow drivers to reference symbols annotated as __devinit or
__devexit that existed in the past.

Those annotations were removed by the following commits:

 - 54b956b90360 ("Remove __dev* markings from init.h")
 - 92e9e6d1f984 ("modpost.c: Stop checking __dev* section mismatches")

Remove the stale whitelist.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f6cbf70e455ee..7e88e6437540e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1007,12 +1007,6 @@ static int secref_whitelist(const char *fromsec, const char *fromsym,
 				    "*_console")))
 		return 0;
 
-	/* symbols in data sections that may refer to meminit sections */
-	if (match(fromsec, PATTERNS(DATA_SECTIONS)) &&
-	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS)) &&
-	    match(fromsym, PATTERNS("*driver")))
-		return 0;
-
 	/*
 	 * symbols in data sections must not refer to .exit.*, but there are
 	 * quite a few offenders, so hide these unless for W=1 builds until
-- 
2.43.0



