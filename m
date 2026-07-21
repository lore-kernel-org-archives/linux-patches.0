Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E631AF1B;
	Tue, 21 Jul 2026 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660497; cv=none; b=NndVmCAAlJgQuqVb2EsNqG0kgj65RLm/5/iS05RDnWH6LPdkOe6XUkGPYEbBAkcV3Jy6wCXW4SPLxMQnGISdl5wY5GPdFjT/QEhKoqdZE9yCChCvSsJei6qKjCGHeywRbxa61R4eogwxdZI/bUowHQnEbl0lD7gPhLCXik38WYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660497; c=relaxed/simple;
	bh=/DmumT1uIMbOyexgrLdbDGxPypkw0xa2nqjBhl0nj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcGh0ODPxOLI/qkcktFlFoEFSP3xY810ZH6b0HdtWzmoi7wSx9WRBalFOL9ADgmNZcFe1FJufnhVn/pxSldLa6ph1Y4CDPL3En4vDqkp//hXdflq7xjve6unj0tscVDEHnAf4KNFszA7A0thAqWlZO3JByYQo+cZxaFJYvOjOqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iflFDq0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iflFDq0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45CD1F00A3E;
	Tue, 21 Jul 2026 19:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660462;
	bh=L3gmPzW/E8WlbkR8qYtB/28Vpt6aalfvPqeIb8sU8m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iflFDq0lEDJHpV6D4MKfAdoKAGpZ8Q+H7uWfiRmDkMoIBNomlhGa0btsage6nu8xm
	 Of5QV8cI3tV/GNzwuhWDJjwVn0ysIwbzvs41zGbfQgH2X9rDhxRWJHLYPk+GOWA5H/
	 NUa0cJJifZ4kbedHUsdZdJbZcPqQYa7rLcaasddA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Song Liu <song@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0989/2077] perf bpf: Use scnprintf() in snprintf_hex() and synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:11:02 +0200
Message-ID: <20260721152616.145806206@linuxfoundation.org>
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

[ Upstream commit cab3a9331ed0b3f884dd61c8a25b3cf123705982 ]

Both functions accumulate formatted output via ret += snprintf(buf + ret,
size - ret, ...).  If the buffer is too small and snprintf() returns more
than the remaining space, ret exceeds size and the next 'size - ret'
underflows, causing snprintf() to write past the buffer end.

Switch to scnprintf() which returns the actual number of bytes written,
making the accumulation safe.

Fixes: 7b612e291a5affb1 ("perf tools: Synthesize PERF_RECORD_* for loaded BPF programs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Song Liu <song@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index a27945c279efb7..2c09842469f1f2 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -36,7 +36,7 @@ static int snprintf_hex(char *buf, size_t size, unsigned char *data, size_t len)
 	size_t i;
 
 	for (i = 0; i < len; i++)
-		ret += snprintf(buf + ret, size - ret, "%02x", data[i]);
+		ret += scnprintf(buf + ret, size - ret, "%02x", data[i]);
 	return ret;
 }
 
@@ -140,7 +140,7 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	const struct btf_type *t;
 	int name_len;
 
-	name_len = snprintf(buf, size, "bpf_prog_");
+	name_len = scnprintf(buf, size, "bpf_prog_");
 	name_len += snprintf_hex(buf + name_len, size - name_len,
 				 prog_tags[sub_id], BPF_TAG_SIZE);
 	if (btf) {
@@ -153,9 +153,10 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 			short_name = info->name;
 	} else
 		short_name = "F";
-	if (short_name)
-		name_len += snprintf(buf + name_len, size - name_len,
-				     "_%s", short_name);
+	if (short_name) {
+		name_len += scnprintf(buf + name_len, size - name_len,
+				      "_%s", short_name);
+	}
 	return name_len;
 }
 
-- 
2.53.0



