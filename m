Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9889320CDC;
	Mon, 18 Aug 2025 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523901; cv=none; b=DQCCY40s62/FcgWpbP8ddWL+yloo5P8GXUz9hwBumk246GNbEXhZqzG3FyoWlf5x6fm5dwU7JiFVhFgRQDp9HdvgkQw50orc/ypBSzwcgVpFRUKGx89JP+sKIamHO9Ha3XghzN0+Ii6FjjtBC+JaGhclr2Kz/OcWowHJRRoVWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523901; c=relaxed/simple;
	bh=YpS5FfSFbGuwKB8BU0BlnKv4tU+BavGJegnnNkygYVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiepAlqdxweA+7n11s233o9Z4ux2yl1D97xPlZStfIT3JT7uEbfI479z3XVDIBnq+KhUmMPAzucRi9SSNDwQMVVBE85MKH6O1rgNHflR62lGNpyeOoE022cJcv+tvrbmBjGSneZOukgy4mx9aoi0iY1zgwd45EiAkrJ94b82+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZE51DSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZE51DSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E25C4CEF1;
	Mon, 18 Aug 2025 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523901;
	bh=YpS5FfSFbGuwKB8BU0BlnKv4tU+BavGJegnnNkygYVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZE51DSmjB57ypSpXKuLkIyEaXdWlXiDJ/k2q2JNlT7JdsXtDIGSntauNuYW73LmR
	 5BxE6UZH6d4P76WvNDm1ZQCNIgFwmc4lMVNXXjRK/mhM+1hcitKyUe4Q3oh4X8uBuD
	 CRR25eiYZenZad2vCaBNGF36Y5a1iR0L9llgNaL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 308/515] bpftool: Fix JSON writer resource leak in version command
Date: Mon, 18 Aug 2025 14:44:54 +0200
Message-ID: <20250818124510.295617661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 85cd83fed8267cde0dd1cea719808aad95ae4de7 ]

When using `bpftool --version -j/-p`, the JSON writer object
created in do_version() was not properly destroyed after use.
This caused a memory leak each time the version command was
executed with JSON output.

Fix: 004b45c0e51a (tools: bpftool: provide JSON output for all possible commands)

Suggested-by: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250617132442.9998-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index cd5963cb6058..2b7f2bd3a7db 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -534,9 +534,9 @@ int main(int argc, char **argv)
 		usage();
 
 	if (version_requested)
-		return do_version(argc, argv);
-
-	ret = cmd_select(commands, argc, argv, do_help);
+		ret = do_version(argc, argv);
+	else
+		ret = cmd_select(commands, argc, argv, do_help);
 
 	if (json_output)
 		jsonw_destroy(&json_wtr);
-- 
2.39.5



