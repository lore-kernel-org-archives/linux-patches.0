Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85202EF297;
	Tue, 17 Jun 2025 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176865; cv=none; b=lt/6YMyO0vMo+xmF55CV6HnUVhCi9v8DT5NMRTVdyWYeih2CsfmBku6S0IWaFfiki3KbeUJtd4gwGuOBEIONK7Ad014e8cvHg1bHeVbKcTEa+4xgH1WqcQAaSLqrK6/8pj4qZnemHZpJcToyQKKCJJ1e6PH6sJ4czDeqyMBDS64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176865; c=relaxed/simple;
	bh=6++8/E2qwlXO18K7fYF09VqEkOBCuGzgeUyAvHLHLa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isfJgPbNzSJAgljrm2//L18VcoiXTAhcOkNvpw3dmkJTtKhqb2I0F+SbjYObL36hrbEj2Tr86lQ53Iu0/jaYdEKmzfqDL6ziN92vMGz5vvvr6MUAuTjBJ4bbwoHFRmo/ht6Uc7LINJalrmTGD9vpy45K5J+5BpHsw2T7PagNx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6H9573H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6H9573H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EB5C4CEE3;
	Tue, 17 Jun 2025 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176865;
	bh=6++8/E2qwlXO18K7fYF09VqEkOBCuGzgeUyAvHLHLa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6H9573HfSRPUrRiE4c8a7OpVI0xk9niSlxa28C/NumRKbKJxJece9AEZtBUydESl
	 w/Gd3aJZrficHqE4KemoOn9z7R1YG2uT5Lm+MnZCCaHGnyElU8KOKRikaiq6rM33RM
	 1iR9k+g4aWzhdz0SguE2W8NXmuGaFDSLzyRP1TNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 233/780] libbpf: Use proper errno value in linker
Date: Tue, 17 Jun 2025 17:19:01 +0200
Message-ID: <20250617152500.943140867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 358b1c0f56ebb6996fcec7dcdcf6bae5dcbc8b6c ]

Return values of the linker_append_sec_data() and the
linker_append_elf_relos() functions are propagated all the
way up to users of libbpf API. In some error cases these
functions return -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250430120820.2262053-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 56f5068e2ebab..a469e5d4fee70 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1376,7 +1376,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		} else {
 			if (!secs_match(dst_sec, src_sec)) {
 				pr_warn("ELF sections %s are incompatible\n", src_sec->sec_name);
-				return -1;
+				return -EINVAL;
 			}
 
 			/* "license" and "version" sections are deduped */
@@ -2223,7 +2223,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
 			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
-			return -1;
+			return -EINVAL;
 		}
 
 		/* shdr->sh_link points to SYMTAB */
-- 
2.39.5



