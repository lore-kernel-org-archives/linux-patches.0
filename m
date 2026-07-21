Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6835EDBD;
	Tue, 21 Jul 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657331; cv=none; b=lBX9kBXGlAOg91hQE0Ltc0mRvM8MuNkONXJ/c4JZv0n8H4JhToVJy3nFZn5JauNEAuKUTVdmedFZOFi8hFh8uQ+v/RB3VVQwjFUZbGoClDAS1JE6oScxC/3OQGlwVaudI8ISr0aqwnuj7HQoSyBhAYqxMF8InjSswEX1ZCJcr2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657331; c=relaxed/simple;
	bh=IZnJcRUX7UmI/DbDaeR46202F3JxY4uloKXxt00YcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkkYRF/jpr9CKKuhS3bG1Cz3ZgOLmaQtQSlA3dQa9IL32HhZFD4UbD8+m38j4s/fGcnp9T4zWsoS5PoEJBe2KUmh6umBirS6UCgdnpFXcdF0/0PnOF6WDiyfI5+tiFV5QJP+d5Dj9JcspB7wD24griuRIAteNfpIPWzYxtT/ZRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lfTOwZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lfTOwZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6F61F000E9;
	Tue, 21 Jul 2026 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657330;
	bh=kPG1UEp6X9ZUuQ5aK/aklSHVjEN6bsF6CuuTmNKrEK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lfTOwZdPNvWLV/MZGyrOf9NvSO/q7hAtMGav60RilsO4jxDpwg3kwY5OZWnpHCeF
	 F+jsTDDDe9eOtZCfFJeSyADY7yw20siouL+XBX9BC73t8SkPuZN1pEoOde8dpnplOS
	 LAV4K4YAzhaEluOKlpXbwJiRIMg3YJw8CJvWRU44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0724/1611] perf bpf: Fix metadata leak in perf_env__add_bpf_info() on duplicate insert
Date: Tue, 21 Jul 2026 17:14:00 +0200
Message-ID: <20260721152531.665829235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a0e4362a3e7b592f1d58949ffe3d6decad39a17c ]

When perf_env__insert_bpf_prog_info() returns false (duplicate
program), the error path frees info_linear and info_node but not
info_node->metadata.  If bpf_metadata_create() had succeeded, the
metadata allocation is permanently leaked.

Fix by calling bpf_metadata_free() on info_node->metadata before
freeing info_node.  bpf_metadata_free() handles NULL, so this is
safe even when bpf_metadata_create() returned NULL.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: fdc3441f2d317b40 ("perf record: collect BPF metadata from new programs")
Cc: Blake Jones <blakejones@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index bfaf1c7b7352c9..2f5908cc8bd6f5 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -875,6 +875,7 @@ static int perf_env__add_bpf_info(struct perf_env *env, u32 id)
 		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
 			pr_debug("%s: duplicate add bpf info request for id %u\n",
 				 __func__, btf_id);
+			bpf_metadata_free(info_node->metadata);
 			free(info_linear);
 			free(info_node);
 			goto out;
-- 
2.53.0



