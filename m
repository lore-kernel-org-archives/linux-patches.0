Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B343C19A288;
	Fri, 24 Apr 2026 13:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038019; cv=none; b=j/oTu9HzeIk4SADEkeUlBGGDYw8s3u0/RXf/qwda+FYsWwSZxEWSr6erq9Hg0Epf9mw76R8yxJ90pvYKAJu8vr/EG0OuhSVrcLxPMGPknjKKMCux7jbWGRSzivWXUfOwvQQL+4XolxHSoTNtSv7BFQLSMYkQp8i0lKDB5C8okz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038019; c=relaxed/simple;
	bh=XoKqkzOac3r4jNc5W+hMyJ8IbSeBPGtmxYS9eXO4LiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0NtwZkyD98+BvD9NMxDlMMWQPtB4XwZ0URYpBz43UKhLQ6l7eca+if139IyMAVZ6lBb6d1dsvFabSjSMRrFq6MN9lU5U1XFjFaVY0WvD25NI/Vc13Zrp0Qonf5Jim626lILk55zUhM518KabyGG5h+nnrWAwtVakMW3kly7yj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADV5zAlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADV5zAlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6C1C19425;
	Fri, 24 Apr 2026 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038019;
	bh=XoKqkzOac3r4jNc5W+hMyJ8IbSeBPGtmxYS9eXO4LiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADV5zAlSLHLtIh9XtVFVlz6J65eTnI2xxVi4jC5XFciIXf7tL2tB/tIyVx9dL9QWT
	 zVhBXFXgCbozYW6Ye9RV7j+mjN1YmxHteTr1DXLVpNM36g6M1/ZDM30QPD8VFrhLV+
	 VLBrlEfJA3HQ33erdc62WuJPXU0mKmc46k50nI0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/166] Revert "perf unwind-libdw: Fix invalid reference counts"
Date: Fri, 24 Apr 2026 15:30:40 +0200
Message-ID: <20260424132559.270836745@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenta Akagi <k@mgml.me>

This reverts commit eddddf4ed7f69697cb54e714e773f764c8d3b67e.

Upstream commit f815fc0c66e7 ("perf unwind-libdw: Fix invalid reference counts"),
was backported to v6.6.128 as eddddf4ed7f6.

However, this commit depends on map_symbol__exit, which was introduced
in v6.7 as commit 56e144fe9826 ("perf mem_info: Add and use
map_symbol__exit and addr_map_symbol__exit") and is absent in v6.6.y.
This results in a build failure.

This is a revert of a backport, so there is no upstream commit.

Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/unwind-libdw.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index bd027fdf6af17..6013335a8daea 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -133,8 +133,8 @@ static int entry(u64 ip, struct unwind_info *ui)
 	}
 
 	e->ip	  = ip;
-	e->ms.maps = maps__get(al.maps);
-	e->ms.map = map__get(al.map);
+	e->ms.maps = al.maps;
+	e->ms.map = al.map;
 	e->ms.sym = al.sym;
 
 	pr_debug("unwind: %s:ip = 0x%" PRIx64 " (0x%" PRIx64 ")\n",
@@ -319,9 +319,6 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (err)
 		pr_debug("unwind: failed with '%s'\n", dwfl_errmsg(-1));
 
-	for (i = 0; i < ui->idx; i++)
-		map_symbol__exit(&ui->entries[i].ms);
-
 	dwfl_end(ui->dwfl);
 	free(ui);
 	return 0;
-- 
2.53.0



