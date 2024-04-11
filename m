Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB37663A2;
	Thu, 11 Apr 2024 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832463; cv=none; b=mN1RQX8hPTXamyPp3ydHqlu5dYXsrlrGvFurx1U6paktQc2mo7M3KblnACFiTsKdH7M/kN6q85xSV99im+vM0I0Sa6jpyLZP1GqDLi+Nw+2f8DMWoiLco9bvbSUImvE8xU6dk/t0fGzyUJEV6gT30tfMxTGGFJBXMOqq9Kb63ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832463; c=relaxed/simple;
	bh=iRg/eG72TM9czoabkc+yY8ssTC9eio6s35EEoMwIgr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGEjcS+QAY/3Ib2XW3SH9OPtwPCAxuSCE3Gpz9589+QlRXsU3J9SajO9KxDfaKp3Kr3JX9gx8HjR/gc1rnpBzM27+gmYchod9eoTkr/mM8B2VBvD6avJeTnIyQlPsJSJ6MgYsM3aG3pE+uU67eJcDMH3EDluzkoRn4YRs9RbeC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eggfXQ65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eggfXQ65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33849C433C7;
	Thu, 11 Apr 2024 10:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832463;
	bh=iRg/eG72TM9czoabkc+yY8ssTC9eio6s35EEoMwIgr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eggfXQ65xoqkmY8Ic8CLVpaVmcB34pdJDOiJZJnwbJHCWWqvqkpyDCwv7qbOe9DlG
	 jHaWMya5laXIGrjVWFRPW4xoihGCnv3c39WWUTx58XqrD6eOrvEeu55+y1FMzKYjBM
	 7UuQVNVP//a4xRL1StQa15RZe/PA0ZjGWQhBBFqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/83] tools: iio: replace seekdir() in iio_generic_buffer
Date: Thu, 11 Apr 2024 11:57:29 +0200
Message-ID: <20240411095414.401127200@linuxfoundation.org>
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

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 4e6500bfa053dc133021f9c144261b77b0ba7dc8 ]

Replace seekdir() with rewinddir() in order to fix a localized glibc bug.

One of the glibc patches that stable Gentoo is using causes an improper
directory stream positioning bug on 32bit arm. That in turn ends up as a
floating point exception in iio_generic_buffer.

The attached patch provides a fix by using an equivalent function which
should not cause trouble for other distros and is easier to reason about
in general as it obviously always goes back to to the start.

https://sourceware.org/bugzilla/show_bug.cgi?id=31212

Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Link: https://lore.kernel.org/r/20240108103224.3986-1-petre.rodan@subdimension.ro
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 6a00a6eecaef0..c5c5082cb24e5 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -376,7 +376,7 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 		goto error_close_dir;
 	}
 
-	seekdir(dp, 0);
+	rewinddir(dp);
 	while (ent = readdir(dp), ent) {
 		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
 			   "_en") == 0) {
-- 
2.43.0



