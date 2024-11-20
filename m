Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C41C9EDF;
	Wed, 20 Nov 2024 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107681; cv=none; b=dLnYvLrmonytpl6MXRlaU1xTG24GL/X+4dGNwyDQpD/lrT6sI0FqrwGKtDXATtBvQLTLf6dDpH30g17Hi6+8pI0HhL0dGzEgXUu7t7vUBFk5sSg+PCFoWAw5QFMoEL8rRDH+UL8UqeV+WwB8kNGYoZjEYNlpfYgz9qQKBIR/kSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107681; c=relaxed/simple;
	bh=3GUO4/8PWdAaaT4aLdQYfVunXM0sTkhrbLFjsdxuEXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6ofIzUgW5HNfOp6OAKK5DW1sLUDfD8d1+cmuugrv6Glo6zcpKGSYrzI8Fv3pbqKGKup1YIAyEJltSDn7jFa2rLwyUIJ8AdTR8bcOJpoS+7iAioeFzeKHh3Ipmq13crM6A5ChZCbvKamZ51/UKT7CkqeM6RubXtmmpBA8mgxRCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlKUZT3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlKUZT3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C7BC4CECD;
	Wed, 20 Nov 2024 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107680;
	bh=3GUO4/8PWdAaaT4aLdQYfVunXM0sTkhrbLFjsdxuEXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlKUZT3LKGm5zl+kWkaeI+sabZN6enpG3384kI5eG4wVbL5EBOsRyPSkGWNnmp+6f
	 XRNC3ovMSX57LVpRlXq39doS6G6/9tyhPxK6WhM/hxiCznpbR+Uxmwj9c1Kamta5RK
	 BWimNcmEQmolq0YZyKUIXtdKeeHzb1HoZ8P/mSJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.1 38/73] lib/buildid: Fix build ID parsing logic
Date: Wed, 20 Nov 2024 13:58:24 +0100
Message-ID: <20241120125810.524264449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

The parse_build_id_buf does not account Elf32_Nhdr header size
when getting the build id data pointer and returns wrong build
id data as result.

This is problem only for stable trees that merged 84887f4c1c3a
fix, the upstream build id code was refactored and returns proper
build id.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 84887f4c1c3a ("lib/buildid: harden build ID parsing logic")
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


