Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A14744CF44;
	Tue, 16 Jun 2026 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625453; cv=none; b=JGVIsq668lxBPTJ+2ueBWr0uTQPzu1xBd+Z5If+powm0XAuTEEOpGgrVdfsIXQUiMfLrcufW9d26UrHs2kZq037BgEuz7JjwT2HFxO4YbLwtJdJc4pcCmyhnt2klEV1SsAVunLCNtTQr0Mu/ULv40giHzGBFkBICYfnxmGCcC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625453; c=relaxed/simple;
	bh=6lrYXw6ZiEw9QnpttbDiAUflSXEuEvXNKuedETH/e0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lk3bhOcOlA8TssCgkrbn+zO5+SJuzRcNyBC0tMfRsKN3ifG7E3gOw52a7yBbO5IV9KSi+7qor41ohxEWcqVPoQlakmoWOTZC+sivUM1RmQ/nGfOoydt67/C44b2xbPxtQUvo8wWesHkkZnlnmTUztx22sn+fLicNnqgUtfGNmKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ch5VSGRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch5VSGRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF81F00ADF;
	Tue, 16 Jun 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625452;
	bh=bdqbvJL0hg86fMsIKmL8SCWfCS2pZvF8Z33Li4E8NY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ch5VSGRqGV9pw3gzLX+Pbs7Bwq+cIxJSvOcsN8h2Q19iz6UhRrexgaMj5WWM8Yilm
	 lvvpZ/93JT4O6cwtw5lrA44U6/3dq91qMr5CPPP1gdQ30N7numgEeVyFqm9DQCF8rr
	 nUYmyBWcRuUPbbWszaOvI9hFohZIoQdnsz3zqkFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/325] drm/vc4: fix krealloc() memory leak
Date: Tue, 16 Jun 2026 20:29:00 +0530
Message-ID: <20260616145104.904426736@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit 5d563a5da8717629ae72f9eadf1e0e340bd1658b ]

Don't just overwrite the original pointer passed to krealloc()
with its return value without checking latter:

    MEM = krealloc(MEM, SZ, GFP);

If krealloc() returns NULL, that erases the pointer
to the still allocated memory, hence leaks this memory.
Instead, use a temporary variable, check it's not NULL
and only then assign it to the original pointer:

    TMP = krealloc(MEM, SZ, GFP);
    if (!TMP) return;
    MEM = TMP;

While on it, use krealloc_array().

Fixes: 6d45c81d229d ("drm/vc4: Add support for branching in shader validation.")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20260606123817.37222-1-grandmaster@al2klimov.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_validate_shaders.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_validate_shaders.c b/drivers/gpu/drm/vc4/vc4_validate_shaders.c
index 2d74e786914cb3..7ce3ec0906c33b 100644
--- a/drivers/gpu/drm/vc4/vc4_validate_shaders.c
+++ b/drivers/gpu/drm/vc4/vc4_validate_shaders.c
@@ -288,15 +288,16 @@ static bool require_uniform_address_uniform(struct vc4_validated_shader_info *va
 {
 	uint32_t o = validated_shader->num_uniform_addr_offsets;
 	uint32_t num_uniforms = validated_shader->uniforms_size / 4;
+	u32 *offsets;
 
-	validated_shader->uniform_addr_offsets =
-		krealloc(validated_shader->uniform_addr_offsets,
-			 (o + 1) *
-			 sizeof(*validated_shader->uniform_addr_offsets),
-			 GFP_KERNEL);
-	if (!validated_shader->uniform_addr_offsets)
+	offsets = krealloc_array(validated_shader->uniform_addr_offsets,
+				 o + 1,
+				 sizeof(*validated_shader->uniform_addr_offsets),
+				 GFP_KERNEL);
+	if (!offsets)
 		return false;
 
+	validated_shader->uniform_addr_offsets = offsets;
 	validated_shader->uniform_addr_offsets[o] = num_uniforms;
 	validated_shader->num_uniform_addr_offsets++;
 
-- 
2.53.0



