Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F2E17CA12;
	Mon, 10 Mar 2025 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628732; cv=none; b=MFVHESt49jZCZprj+II5OaS4W+isBFjnNKgMO+UwFK6C6/sOVhySzNYBl1vIzc619VJ/rJwmtwlKYkJ8bP0EuG/Z7pXxxMxX3Aom8pRUi3YRq25L2mPLBV011rflmChYhdicC6OXtOE7AnupoGtF6i61+PFLF2J9sinzcunhMW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628732; c=relaxed/simple;
	bh=xfg8D5PubB0udR0puMIEEGLILKMNVB/RFb0DjJclbyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq4rRVP/vQiz0xsgoApgDVPGk90wT99ClTUaBGJRZWUTjmp/TRnqbSZYt7H4pcaX8mLZjyDQLfkOcwv3jNGyqjNuTOoNoNN5Pigt0JUvLEEhCyCq9kVid5TOaCt5s9GsxEZ6wqU3ZUK4gP42ogi7t9pZw378zaoW9NQIEnG8+lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix57Gv/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix57Gv/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66521C4CEE5;
	Mon, 10 Mar 2025 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628731;
	bh=xfg8D5PubB0udR0puMIEEGLILKMNVB/RFb0DjJclbyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix57Gv/eFN9FrME9AYkjiq5AsLjjWyzzSJ2QMb7/7CqIl9siElwPVZ5YPpS164O2V
	 /gHrxtjFyTa5KrNnJPKkgnAfl47gHhQByODXDkd7RGFckVosB0G4DknVoW5sBPa6br
	 EIrNQi5e6mYbSOgFwnrz4cOhou8g68xn2QA4MIyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/620] fs: fix proc_handler for sysctl_nr_open
Date: Mon, 10 Mar 2025 17:57:34 +0100
Message-ID: <20250310170545.904053113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@gmail.com>

[ Upstream commit d727935cad9f6f52c8d184968f9720fdc966c669 ]

Use proc_douintvec_minmax() instead of proc_dointvec_minmax() to handle
sysctl_nr_open, because its data type is unsigned int, not int.

Fixes: 9b80a184eaad ("fs/file: more unsigned file descriptors")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Link: https://lore.kernel.org/r/20241124034636.325337-1-alexjlzheng@tencent.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index a8d4a2fb9c67f..e03ff9a2c2b1f 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -109,7 +109,7 @@ static struct ctl_table fs_stat_sysctls[] = {
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_douintvec_minmax,
 		.extra1		= &sysctl_nr_open_min,
 		.extra2		= &sysctl_nr_open_max,
 	},
-- 
2.39.5



