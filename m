Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D65946EF98;
	Tue, 21 Jul 2026 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660549; cv=none; b=BWGGDkPq9RDe2Voljfo9HZ2rZ1nHQ4/TBCvy/fxIKBfiLn2T+HM/ktiKr9KTsyLXh8XzEH5kLDnJjWbofrfNphOBf/vprreceafAJYJXq2x+fuCS0FM0ls6N8rd9HDV7sLnLlAdZ4QiZnQ79BDxUtpSoDPXVuMm7k/L1LQEiXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660549; c=relaxed/simple;
	bh=zVW7SiTNrTLhvpOhWVJWfazhEyv7jJqAqYRpcPeZRao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brdByZnUNEp/sAnfGzwX7AuTrgiJpKdBCZ1N5P4Joc6riwM8xfAO+AXtSpIok7Qvl5uR6Wq26dggVTTn946+8DKJd3h583JluHmUwImRCuy4wGqj/pTyN8I5smjHul4h3sk2SZKo+uM+ZedFqWtxn0ME4i/lzdlFqeDM/Am0gaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0Fbvyth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0Fbvyth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12E51F00A3A;
	Tue, 21 Jul 2026 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660547;
	bh=T6J62yco/Tso5xYI7pdk6HQ3p00ndIqj39RI5rGyCM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0FbvythWryZPMlfcVmCDWh0+YzUcUTvNut70ovaxpIzAjOe0hFHrIWrjX+Su0LzS
	 EA5RBAoGKDx0Z5cQftNOgXHp45dej+zDHKF8UpkRjoP9kmBoSAAI9ZGoXXzTBLYv+/
	 L6xc1ZUZzKUQosJN1VGNlo5eMV+lL97PXdneAcK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1022/2077] perf bpf: Fix map data leak in bpf_metadata_create() on alloc failure
Date: Tue, 21 Jul 2026 17:11:35 +0200
Message-ID: <20260721152616.927028459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit aece2b8966fc8de5be46ee9287d0f60d6690c300 ]

bpf_metadata_create() calls bpf_metadata_read_map_data() which
allocates map.btf and map.rodata.  If the subsequent
bpf_metadata_alloc() fails, the code does 'continue' which skips
bpf_metadata_free_map_data(), permanently leaking both allocations.

Fix by calling bpf_metadata_free_map_data() before continue.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: ab38e84ba9a80581 ("perf record: collect BPF metadata from existing BPF programs")
Cc: Blake Jones <blakejones@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index fe01551dc3e6cc..b65ad28cd950fc 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -395,8 +395,10 @@ static struct bpf_metadata *bpf_metadata_create(struct bpf_prog_info *info)
 			continue;
 
 		metadata = bpf_metadata_alloc(info->nr_prog_tags, map.num_vars);
-		if (!metadata)
+		if (!metadata) {
+			bpf_metadata_free_map_data(&map);
 			continue;
+		}
 
 		bpf_metadata_fill_event(&map, &metadata->event->bpf_metadata);
 
-- 
2.53.0



