Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EBE31B13A;
	Mon, 18 Aug 2025 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522578; cv=none; b=ZBRQv5sf0EnMFGebiCu4Ne0EqbioyCZS53IXJVdnSwYSBcrfXSpceYGOhR5mSbUIaHMZPN9JqfCHzdghXWLv2Os6wnQa7ms1btDxh0gI7xjZLrYZB/zAxG4OgxDLWiSYLUwWRdz8UNW4sspYV7xO6xjvjzyaYfz5LhgFFhZC/1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522578; c=relaxed/simple;
	bh=r8tmck5aZvLuJMdhqmtYzl8AkQLgTFvx27ICYemEQd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLgJ/CA8Du0qW8kq3yAz838M2B2JwSBckFGuyiQuquu4RvS1Za7obM6mubvJFp+8ednDMZvmOBnMVLt4eTW3VJf0Twfv6gqYU4WI+iMZh4eV5h2dHRvFVnmz5ujh/H+EBAaW2lOOIp3CzX7PgsdMt+Df5oZiP/j6Ww9CX5h3jlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gc8P8h+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gc8P8h+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC42DC4CEEB;
	Mon, 18 Aug 2025 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522578;
	bh=r8tmck5aZvLuJMdhqmtYzl8AkQLgTFvx27ICYemEQd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc8P8h+8KU/B+5FNXbcympvg0qeXxZqnLwODaBeCMp7xV5gnu1qlMXFGlkup0Ayfp
	 TkppkqaDrdfhsw6NrzGwMa1iGioDbqfpctxx9IpfVyTK91Ptk+l+9CqTYWTRczPMbb
	 aBM9dNJjjmEUGcDdL4bYltpraSz/A9rbIv3inHyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/444] tools/power turbostat: Handle cap_get_proc() ENOSYS
Date: Mon, 18 Aug 2025 14:46:22 +0200
Message-ID: <20250818124502.263002606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit d34fe509f5f76d9dc36291242d67c6528027ebbd ]

Kernels configured with CONFIG_MULTIUSER=n have no cap_get_proc().
Check for ENOSYS to recognize this case, and continue on to
attempt to access the requested MSRs (such as temperature).

Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 9be6803ea10f..b663a76d31f1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6246,8 +6246,16 @@ int check_for_cap_sys_rawio(void)
 	int ret = 0;
 
 	caps = cap_get_proc();
-	if (caps == NULL)
+	if (caps == NULL) {
+		/*
+		 * CONFIG_MULTIUSER=n kernels have no cap_get_proc()
+		 * Allow them to continue and attempt to access MSRs
+		 */
+		if (errno == ENOSYS)
+			return 0;
+
 		return 1;
+	}
 
 	if (cap_get_flag(caps, CAP_SYS_RAWIO, CAP_EFFECTIVE, &cap_flag_value)) {
 		ret = 1;
-- 
2.39.5



