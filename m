Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE9A1C877E;
	Wed, 20 Nov 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107609; cv=none; b=rgGfRACwnGk2HStQPFnOdv4PD1UvLlmKFPcIMrkgr+AZr+hHk6tUy4VuCVO7Agc8rDa1o7ZCGVzGDKTwK936ZkNwrn2GRV0nQb+Uj19TPfodcVGbHL1SggnMFKBO7gh8Ef2TjYregC7PTwNO03WWHivHTT53QwRphyEUROVXFpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107609; c=relaxed/simple;
	bh=OT+rNTsveNed2DpCGccUKAUTncorZ1GwBiLcaZ4KFco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chT0fwb13Pp6+n7/KlOdpZ0bCd2iUEpVXUdeIhW3GluzzGJskxcvhiGRtMFpyEgLriXfC0KY9jwvxleZYdm9DMT/glVZIqVh26wQ1P8Qfp7Kca4/CI+xcEzV9rPNqg2vHqFaBf6iQ8sC8CUuWoxH/CduAggmxh50eJpU6ysvMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5ZJ9u2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5ZJ9u2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9155CC4CED2;
	Wed, 20 Nov 2024 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107608;
	bh=OT+rNTsveNed2DpCGccUKAUTncorZ1GwBiLcaZ4KFco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5ZJ9u2xX6bGu9ffUBYB2VrjZK5upVKW+R9dx19txR8LiQWXgiXlA2sdMa9R1UWKl
	 znCfEsxnOcSkm/JmpvzL/rDp/RZ6u17XtNdt6rUNnHglibvu3LbZ+8oQyM7DbQxC7f
	 k3CaaoV+fw0njpUJsKGUigUebTYcvEc1dxM5RPVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.6 59/82] lib/buildid: Fix build ID parsing logic
Date: Wed, 20 Nov 2024 13:57:09 +0100
Message-ID: <20241120125630.942098795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

The parse_build_id_buf does not account Elf32_Nhdr header size
when getting the build id data pointer and returns wrong build
id data as result.

This is problem only for stable trees that merged c83a80d8b84f
fix, the upstream build id code was refactored and returns proper
build id.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: c83a80d8b84f ("lib/buildid: harden build ID parsing logic")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/buildid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -40,7 +40,7 @@ static int parse_build_id_buf(unsigned c
 		    name_sz == note_name_sz &&
 		    memcmp(nhdr + 1, note_name, note_name_sz) == 0 &&
 		    desc_sz > 0 && desc_sz <= BUILD_ID_SIZE_MAX) {
-			data = note_start + note_off + ALIGN(note_name_sz, 4);
+			data = note_start + note_off + sizeof(Elf32_Nhdr) + ALIGN(note_name_sz, 4);
 			memcpy(build_id, data, desc_sz);
 			memset(build_id + desc_sz, 0, BUILD_ID_SIZE_MAX - desc_sz);
 			if (size)


