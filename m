Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8381170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3F2C433C8;
	Mon, 11 Sep 2023 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440636;
	bh=s7UhqM2SnS08/mny9mDQEA1AFgjWlIz4jW1KnQv2fp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1ZBS1rIFPmqSQAGgM9eflfxYho7auPkFDZllXE90RXsplgjmNGbis6oSvu0h2+ye
	 ZtWdtqPQTvP7Gv4R8Rvs0wWDIzXIgn8fR3/y0llA7IpRypACkRhLqT/FNwmJEqjBe/
	 MIkT0el2kpIhWTIZoZrlCyAIBar/iFzE7yBLcon8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Vedovati <marco.vedovati@crowdstrike.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 131/739] libbpf: Set close-on-exec flag on gzopen
Date: Mon, 11 Sep 2023 15:38:50 +0200
Message-ID: <20230911134654.746219531@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Vedovati <marco.vedovati@crowdstrike.com>

[ Upstream commit 8e50750f122e59ea4cab4b4f696ef22b391bedc9 ]

Enable the close-on-exec flag when using gzopen. This is especially important
for multithreaded programs making use of libbpf, where a fork + exec could
race with libbpf library calls, potentially resulting in a file descriptor
leaked to the new process. This got missed in 59842c5451fe ("libbpf: Ensure
libbpf always opens files with O_CLOEXEC").

Fixes: 59842c5451fe ("libbpf: Ensure libbpf always opens files with O_CLOEXEC")
Signed-off-by: Marco Vedovati <marco.vedovati@crowdstrike.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230810214350.106301-1-martin.kelly@crowdstrike.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7cc79bf764550..e07dff7eba600 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1975,9 +1975,9 @@ static int bpf_object__read_kconfig_file(struct bpf_object *obj, void *data)
 		return -ENAMETOOLONG;
 
 	/* gzopen also accepts uncompressed files. */
-	file = gzopen(buf, "r");
+	file = gzopen(buf, "re");
 	if (!file)
-		file = gzopen("/proc/config.gz", "r");
+		file = gzopen("/proc/config.gz", "re");
 
 	if (!file) {
 		pr_warn("failed to open system Kconfig\n");
-- 
2.40.1



